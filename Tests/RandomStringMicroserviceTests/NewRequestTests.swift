import XCTest
import XCTVapor
import FQAuthMiddleware
@testable import RandomStringMicroservice

final class NewRequestTests: XCTestCase {

  var app: Application!
  override func setUpWithError() throws {
    app = Application(.testing)
    try app.configure()
    try app.resetDatabase()
  }

  override func tearDownWithError() throws {
    app.shutdown()
  }

  func testUnauthorizedGetReturnsUnauthorizedStatusCode() throws {
    try app.test(.POST, "/api/sample/new") { response in
      XCTAssertEqual(response.status, .unauthorized)
    }
  }
}
