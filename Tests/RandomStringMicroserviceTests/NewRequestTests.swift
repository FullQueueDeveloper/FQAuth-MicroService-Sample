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

  func testWhenUnauthorizedReturnUnauthorizedStatusCode() throws {
    try app.test(.POST, "/api/sample/new") { response in
      XCTAssertEqual(response.status, .unauthorized)
    }
  }

  func testWhenAuthorizedReturnCreatedStatusCode() throws {

    let userID = UUID(uuidString: "2A5AA76F-AB4A-4053-9E7D-63FB03F8535C")!

    let token = FQAuthSessionToken(userID: userID,
                                   expiration: .init(value: Date(timeIntervalSinceNow: 600)))
    let jwt = try app.jwt.signers.sign(token)
    let headers = HTTPHeaders([("Authorization", "Bearer \(jwt)")])

    try app.test(.POST, "/api/sample/new", headers: headers) { response in
      XCTAssertEqual(response.status, .created)

      let created = try RandomStringModel
        .query(on: app.db(.psql))
        .filter(\.$userID, .equal, userID)
        .first().wait()

      XCTAssertNotNil(created)
      XCTAssertNotNil(created?.randomString)
    }
  }

  func testWhenAuthorizedAndModelExistsAlreadyReturnUpdated() throws {
    let userID = UUID(uuidString: "2A5AA76F-AB4A-4053-9E7D-63FB03F8535C")!

    let existingModel = RandomStringModel()
    existingModel.randomString = "arst"
    existingModel.userID = userID

    try existingModel.save(on: app.db(.psql)).wait()

    let token = FQAuthSessionToken(userID: userID,
                                   expiration: .init(value: Date(timeIntervalSinceNow: 600)))
    let jwt = try app.jwt.signers.sign(token)
    let headers = HTTPHeaders([("Authorization", "Bearer \(jwt)")])

    try app.test(.POST, "/api/sample/new", headers: headers) { response in
      XCTAssertEqual(response.status, .created)

      let retrievedModel = try RandomStringModel
        .query(on: app.db(.psql))
        .filter(\.$userID, .equal, userID)
        .first()
        .wait()
      XCTAssertNotNil(retrievedModel)
      XCTAssertNotNil(retrievedModel?.randomString)
      XCTAssertNotEqual(retrievedModel?.randomString, existingModel.randomString)
    }
  }
}
