import SwiftDiagnostics

extension MessageID {
    static func makeGatheredKitMessageID(id: String) -> MessageID {
        MessageID(domain: "uk.josephduffy.GatheredKit", id: id)
    }
}
