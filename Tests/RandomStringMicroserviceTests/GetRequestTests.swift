import XCTest
import XCTVapor
import FQAuthMiddleware
import JWT
@testable import RandomStringMicroservice

final class GetRequestTests: XCTestCase {

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

  func testNoUserNotExistingReturnsNoContentStatusCode() throws {

    let userID = UUID(uuidString: "2A5AA76F-AB4A-4053-9E7D-63FB03F8535C")!
    let token = FQAuthSessionToken(userID: userID,
                                   deviceName: "Xample",
                                   expiration: .init(value: Date(timeIntervalSinceNow: 600)),
                                   iss: IssuerClaim("tomato"))

    let jwt = try app.jwt.signers.sign(token)
    
    let headers = HTTPHeaders([("Authorization", "Bearer \(jwt)")])
    try app.test(.GET, "/api/sample",
                 headers: headers) { response in
      XCTAssertEqual(response.status, .noContent)
    }
  }

  func testExistingAuthenticatedUserReturnRandomString() throws {
    let userID = UUID(uuidString: "2A5AA76F-AB4A-4053-9E7D-63FB03F8535C")!

    let model = RandomStringModel()
    model.randomString = "arst"
    model.userID = userID
    model.id = UUID()
    try model.save(on: app.db(.psql)).wait()


    let token = FQAuthSessionToken(userID: userID,
                                   deviceName: "Xample",
                                   expiration: .init(value: Date(timeIntervalSinceNow: 600)),
                                   iss: .init(value: "tomato"))

    let jwt = try app.jwt.signers.sign(token)
    let headers = HTTPHeaders([("Authorization", "Bearer \(jwt)")])
    try app.test(.GET, "/api/sample",
                 headers: headers) { response in
      XCTAssertEqual(response.status, .ok)
      XCTAssertEqual(String(buffer: response.body), "arst")
    }
  }
}
