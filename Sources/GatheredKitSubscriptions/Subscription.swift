public protocol Subscription {
    func cancel()
}

/// A subscription to value updates.
public protocol ValueSubscription<Value>: Subscription {
    associatedtype Value

    var values: AsyncStream<Value> { get }
}

/// A subscription to error updates.
public protocol ErrorSubscription<Error>: Subscription {
    associatedtype Error: Swift.Error

    var errors: AsyncStream<Error> { get }
}

public protocol ResultSubscription<Value, Error>: ValueSubscription, ErrorSubscription where Error: Swift.Error {
    associatedtype Value
    associatedtype Error

    var results: AsyncStream<Result<Value, Error>> { get }
}

extension ResultSubscription where Error == Never {
    public var errors: AsyncStream<Never> {
        AsyncStream(unfolding: { nil })
    }
}

import Foundation

/// An object used to store subscriptions to ``GatheredKit.Property`` instances.
public final class PropertySubscriptionsStorage<Value, Error: Swift.Error>: @unchecked Sendable {
    private final class Weak<Wrapped: AnyObject> {
        weak var wrapped: Wrapped?

        init(_ wrapped: Wrapped) {
            self.wrapped = wrapped
        }
    }

    private var subscriptions: [UUID: Weak<PropertySubscription<Value, Error>>] = [:]

    private let subscriptionsLock = NSLock()

    public init() {}

    public func makeValueSubscription() -> PropertySubscription<Value, Error> {
        let uuid = UUID()
        let subscription = PropertySubscription<Value, Error> { [weak self] in
            guard let self else { return }
            self.subscriptionsLock.lock()
            self.subscriptions.removeValue(forKey: uuid)
            self.subscriptionsLock.unlock()
        }
        subscriptionsLock.lock()
        subscriptions[uuid] = Weak(subscription)
        subscriptionsLock.unlock()
        return subscription
    }

    public func notifySubscribersOfValue(_ value: Value) {
        let subscriptionsCopy: [UUID: Weak<PropertySubscription<Value, Error>>]
        subscriptionsLock.lock()
        subscriptionsCopy = subscriptions
        subscriptionsLock.unlock()

        let subscriptions = subscriptionsCopy.values.compactMap(\.wrapped)
        for subscription in subscriptions {
            subscription.handleValue(value)
        }
    }
}

public final class PropertySubscription<Value, Error: Swift.Error>: ResultSubscription, @unchecked Sendable {
    public var results: AsyncStream<Result<Value, Error>> {
        AsyncStream { continuation in
            resultRelay.addContinuation(continuation)

            cancelationLock.lock()
            if hasBeenCancelled {
                continuation.finish()
            }
            cancelationLock.unlock()
        }
    }

    public var values: AsyncStream<Value> {
        AsyncStream { continuation in
            resultRelay.addContinuation(continuation)

            cancelationLock.lock()
            if hasBeenCancelled {
                continuation.finish()
            }
            cancelationLock.unlock()
        }
    }

    public var errors: AsyncStream<Error> {
        AsyncStream { continuation in
            resultRelay.addContinuation(continuation)

            cancelationLock.lock()
            if hasBeenCancelled {
                continuation.finish()
            }
            cancelationLock.unlock()
        }
    }

    private let cancelationHandler: () -> Void
    private var hasBeenCancelled = false
    private let cancelationLock = NSLock()

    private let resultRelay: UpdatesRelay<Value, Error>

    /// Create a new subscription, which can be used to
    public init(cancelationHandler: @escaping () -> Void) {
        self.cancelationHandler = cancelationHandler

        let resultRelay = UpdatesRelay<Value, Error>()
        self.resultRelay = resultRelay
    }

    deinit {
        cancel()
    }

    public func handleValue(_ value: Value) {
        resultRelay.relayValue(value)
    }

    public func handleError(_ error: Error) {
        resultRelay.relayError(error)
    }

    /// Cancel the subscript, preventing any more values being yielded by the
    /// async streams.
    public func cancel() {
        cancelationLock.lock()
        guard !hasBeenCancelled else {
            cancelationLock.unlock()
            return
        }

        hasBeenCancelled = true
        resultRelay.relayFinish()
        cancelationHandler()
        cancelationLock.unlock()
    }
}

//extension PropertySubscription: Sendable where Value: Sendable, Error: Sendable {}

private final class UpdatesRelay<Value, Error: Swift.Error>: @unchecked Sendable {
    private var resultContinuations: [UUID: AsyncStream<Result<Value, Error>>.Continuation] = [:]
    private let resultContinuationsLock = NSLock()

    private var valueContinuations: [UUID: AsyncStream<Value>.Continuation] = [:]
    private let valueContinuationsLock = NSLock()

    private var errorContinuations: [UUID: AsyncStream<Error>.Continuation] = [:]
    private let errorContinuationsLock = NSLock()

    init() {}

    func addContinuation(_ continuation: AsyncStream<Result<Value, Error>>.Continuation) {
        let uuid = UUID()

        continuation.onTermination = { _ in
            self.resultContinuationsLock.lock()
            self.resultContinuations.removeValue(forKey: uuid)
            self.resultContinuationsLock.unlock()
        }

        resultContinuationsLock.lock()
        resultContinuations[uuid] = continuation
        resultContinuationsLock.unlock()
    }

    func addContinuation(_ continuation: AsyncStream<Value>.Continuation) {
        let uuid = UUID()

        continuation.onTermination = { _ in
            self.valueContinuationsLock.lock()
            self.valueContinuations.removeValue(forKey: uuid)
            self.valueContinuationsLock.unlock()
        }

        valueContinuationsLock.lock()
        valueContinuations[uuid] = continuation
        valueContinuationsLock.unlock()
    }

    func addContinuation(_ continuation: AsyncStream<Error>.Continuation) {
        let uuid = UUID()

        continuation.onTermination = { _ in
            self.errorContinuationsLock.lock()
            self.errorContinuations.removeValue(forKey: uuid)
            self.errorContinuationsLock.unlock()
        }

        errorContinuationsLock.lock()
        errorContinuations[uuid] = continuation
        errorContinuationsLock.unlock()
    }

    func relayValue(_ value: Value) {
        let valueContinuations: [UUID: AsyncStream<Value>.Continuation]
        let resultContinuations: [UUID: AsyncStream<Result<Value, Error>>.Continuation]

        valueContinuationsLock.lock()
        valueContinuations = self.valueContinuations
        valueContinuationsLock.unlock()

        resultContinuationsLock.lock()
        resultContinuations = self.resultContinuations
        resultContinuationsLock.unlock()

        for valueContinuation in valueContinuations.values {
            valueContinuation.yield(value)
        }

        for resultContinuation in resultContinuations.values {
            resultContinuation.yield(.success(value))
        }
    }

    func relayError(_ error: Error) {
        let errorContinuations: [UUID: AsyncStream<Error>.Continuation]
        let resultContinuations: [UUID: AsyncStream<Result<Value, Error>>.Continuation]

        errorContinuationsLock.lock()
        errorContinuations = self.errorContinuations
        errorContinuationsLock.unlock()

        resultContinuationsLock.lock()
        resultContinuations = self.resultContinuations
        resultContinuationsLock.unlock()

        for errorContinuation in errorContinuations.values {
            errorContinuation.yield(error)
        }

        for resultContinuation in resultContinuations.values {
            resultContinuation.yield(.failure(error))
        }
    }

    func relayFinish() {
        let valueContinuations: [UUID: AsyncStream<Value>.Continuation]
        let errorContinuations: [UUID: AsyncStream<Error>.Continuation]
        let resultContinuations: [UUID: AsyncStream<Result<Value, Error>>.Continuation]

        valueContinuationsLock.lock()
        valueContinuations = self.valueContinuations
        valueContinuationsLock.unlock()

        errorContinuationsLock.lock()
        errorContinuations = self.errorContinuations
        errorContinuationsLock.unlock()

        resultContinuationsLock.lock()
        resultContinuations = self.resultContinuations
        resultContinuationsLock.unlock()

        for valueContinuation in valueContinuations.values {
            valueContinuation.finish()
        }

        for errorContinuation in errorContinuations.values {
            errorContinuation.finish()
        }

        for resultContinuation in resultContinuations.values {
            resultContinuation.finish()
        }
    }
}
