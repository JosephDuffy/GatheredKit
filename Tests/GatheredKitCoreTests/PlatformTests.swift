import XCTest

// swift-format-ignore: AlwaysUseLowerCamelCase

/// Tests to that will show which platform is being tested in the list of tests.
final class PlatformTests: XCTestCase {
    #if os(iOS)
    func test_iOS() {
        XCTAssertTrue(true)
    }
    #endif

    #if targetEnvironment(macCatalyst)
    func test_macCatalyst() {
        XCTAssertTrue(true)
    }
    #endif

    #if os(macOS)
    func test_macOS() {
        XCTAssertTrue(true)
    }
    #endif

    #if os(tvOS)
    func test_tvOS() {
        XCTAssertTrue(true)
    }
    #endif
}
