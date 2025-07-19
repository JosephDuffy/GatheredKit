import SwiftDiagnostics

struct GatheredKitFixItMessage: FixItMessage {
    let fixItID: MessageID
    let message: String

    init(id: String, message: String) {
        fixItID = MessageID.makeGatheredKitMessageID(id: id)
        self.message = message
    }
}

