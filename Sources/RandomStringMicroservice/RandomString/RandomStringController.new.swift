import Vapor
import FQAuthMiddleware

extension RandomStringController {

  /**
   - Returns the newly generated random string.
   */

  func new(request: Request) throws -> EventLoopFuture<Response> {
    let userID = request.fqSessionToken!.userID

    return RandomStringModel
      .query(on: request.db(.psql))
      .filter(\.$userID, .equal, userID)
      .first()
      .flatMap { maybeModel in
        if let model = maybeModel {
          return self.newRandomString(for: model, for: request)
        } else {
          let newModel = RandomStringModel()
          newModel.userID = userID
          return self.newRandomString(for: newModel, for: request)
        }
      }
  }

  private func newRandomString(for model: RandomStringModel, for request: Request) -> EventLoopFuture<Response> {
    let newRandomString = UUID().uuidString
    model.randomString = newRandomString
    return model
      .save(on: request.db(.psql))
      .transform(to: newRandomString.encodeResponse(status: .created, for: request))
  }
}
