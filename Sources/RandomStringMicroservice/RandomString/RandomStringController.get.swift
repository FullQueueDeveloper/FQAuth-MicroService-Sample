import Vapor
import FQAuthMiddleware
import FluentPostgresDriver
import FluentKit
import Fluent

extension RandomStringController {

  func get(request: Request) async throws -> String {

    let userID = request.fqSessionToken!.userID!

    let maybe = try await RandomStringModel
      .query(on: request.db(.psql))
      .filter(\RandomStringModel.$userID, .equal, userID)
      .first()

    if let model = maybe {
      return model.randomString
    } else {
      throw Abort(.noContent)
    }
  }
}
