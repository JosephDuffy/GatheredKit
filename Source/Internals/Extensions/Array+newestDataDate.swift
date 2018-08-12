import Foundation

public extension Array where Element: Value {

    func newestDataDate() -> Date {
        return map { $0.date }.reduce(Date.distantPast) { $0 > $1 ? $0 : $1 }
    }

}
