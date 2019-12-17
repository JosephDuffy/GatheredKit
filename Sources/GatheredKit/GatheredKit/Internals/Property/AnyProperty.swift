import Foundation
import Combine

public protocol AnyProperty: Snapshot & AnyProducer {
    var displayName: String { get }
    var typeErasedFormatter: Formatter { get }
    var typeErasedPublisher: AnyPublisher<Any, Never> { get }
}
