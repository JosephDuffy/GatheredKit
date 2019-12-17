import XCTest

/// Tests to aid with knowing which platform is being tested via the output.
final class PlatformTests: XCTestCase {

    #if os(iOS)
    func test_iOS() {
        XCTAssertTrue(true)
    }
    #elseif os(macOS)
    func test_macOS() {
        XCTAssertTrue(true)
    }
    #elseif os(tvOS)
    func test_tvOS() {
        XCTAssertTrue(true)
    }
    #else
    func test_unknown() {
        XCTFail("Platform requires `#if os` checks")
    }
    #endif

}
