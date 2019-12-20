import Foundation
import Combine

public protocol AnyProperty: class, AnySnapshot {
    var displayName: String { get }
    var typeErasedFormatter: Formatter { get }
    var typeErasedPublisher: AnyPublisher<AnySnapshot, Never> { get }
}
