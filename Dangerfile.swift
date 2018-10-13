import Foundation
import Danger

struct VersionFile {
    enum Interpreter {
        case regex(String)
        case closure((String) -> String?)
    }

    let path: String
    let interpreter: Interpreter

    func getVersions() -> [String] {
        guard let data = FileManager.default.contents(atPath: path) else {
            warn("Unable to find file at " + path)
            return []
        }
        guard let content = String(data: data, encoding: .utf8) else {
            warn("Could not decode data at " + path + " as UTF8")
            return []
        }

        switch interpreter {
        case .regex(let regex):
            do {
                let regex = try NSRegularExpression(pattern: regex, options: [])
                let matches = regex.matches(in: content, options: [], range: NSRange(location: 0, length: content.count))
                return matches.compactMap { match in
                    guard match.numberOfRanges > 1 else {
                        warn("Failed to find capture group for match \(match)")
                        return nil
                    }
                    let range = match.range(at: 1)
                    let startIndex = content.index(content.startIndex, offsetBy: range.location)
                    let indexPastEnd = content.index(content.startIndex, offsetBy: range.location + range.length)
                    return String(content[startIndex..<indexPastEnd])
                }
            } catch {
                warn("Error creating version check regex from \(regex): \(error.localizedDescription)")
                return []
            }
        case .closure(let closure):
            guard let version = closure(content) else { return [] }
            return [version]
        }
    }
}

let projectPath = "./GatheredKit.xcodeproj/project.pbxproj"
let swiftVersionPath = ".swift-version"

func checkSwiftVersions() {
    check(versionFiles: [
        VersionFile(path: "./GatheredKit.xcodeproj/project.pbxproj", interpreter: .regex("SWIFT_VERSION = (.*);")),
        VersionFile(path: ".swift-version", interpreter: .closure({ $0.trimmingCharacters(in: .whitespacesAndNewlines) })),
    ], versionKind: "Swift")
}

func checkPodspec() {
    check(versionFiles: [
        VersionFile(path: "./Source/Info.plist", interpreter: .regex("<key>CFBundleShortVersionString</key>\\s*<string>(.*)</string>")),
        VersionFile(path: "./GatheredKit.podspec", interpreter: .regex("version\\s*= \"(.*)\"")),
    ], versionKind: "framework")
}

func check(versionFiles: [VersionFile], versionKind: String) {
    let versions = versionFiles.reduce(Set<String>(), { versions, versionFile in
        var versions = versions

        let fileVersions = versionFile.getVersions()

        for fileVersion in fileVersions {
            if let first = versions.first, !versions.contains(fileVersion) {
                warn("Found mismatched version. Expected " + first + ", found " + fileVersion + " in " + versionFile.path)
                versions.insert(fileVersion)
            } else if versions.isEmpty {
                versions.insert(fileVersion)
            }
        }

        return versions
    })

    let paths = versionFiles.map { $0.path }

    if versions.isEmpty {
        warn("Found no \(versionKind) versions in files: \(paths)")
    } else {
        message("All \(versionKind) versions are in-sync: \(paths)")
    }
}

checkSwiftVersions()
checkPodspec()
