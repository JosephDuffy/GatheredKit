import Foundation
import Combine

public protocol AnyProperty: AnySnapshot {
    var displayName: String { get }
    var typeErasedFormatter: Formatter { get }
    var typeErasedPublisher: AnyPublisher<Any, Never> { get }
}
