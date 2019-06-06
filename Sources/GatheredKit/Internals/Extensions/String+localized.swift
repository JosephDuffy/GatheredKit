extension String {
    
    var localized: String {
        let appLocalizedString = NSLocalizedString(self, comment: "")
        guard appLocalizedString == self else {
            return appLocalizedString
        }
        
        let frameworkBundle = Bundle(for: FrameworkClass.self)
        return NSLocalizedString(self, bundle: frameworkBundle, comment: "")
    }
    
}

private final class FrameworkClass { }
