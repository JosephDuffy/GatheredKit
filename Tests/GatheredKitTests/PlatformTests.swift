import XCTest

// swift-format-ignore: AlwaysUseLowerCamelCase

/// Tests to that will show which platform is being tested in the list of tests.
final class PlatformTests: XCTestCase {
    #if os(iOS)
    func test_iOS() { XCTAssertTrue(true) }
    #elseif targetEnvironment(macCatalyst)
    func test_macCatalyst() { XCTAssertTrue(true) }
    #elseif os(macOS)
    func test_macOS() { XCTAssertTrue(true) }
    #elseif os(tvOS)
    func test_tvOS() { XCTAssertTrue(true) }
    #else
    func test_unkownPlatform() { XCTFail("Unsupported platform") }
    #endif
}
