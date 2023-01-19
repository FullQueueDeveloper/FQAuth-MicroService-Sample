import XCTest
import XCTVapor
import FQAuthMiddleware
@testable import RandomStringMicroservice

final class RandomStringMicroserviceTests: XCTestCase {

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
    try app.test(.GET, "/api/sample") { response in
      XCTAssertEqual(response.status, .unauthorized)
    }
  }

  func testNoUserMeansReturnsNoContentStatusCode() throws {
    
    let headers = HTTPHeaders([("Auth", "Bearer \(Fixtures.token)")])
    try app.test(.GET, "/api/sample",
                 headers: headers) { response in
      XCTAssertEqual(response.status, .noContent)
    }
  }
}
