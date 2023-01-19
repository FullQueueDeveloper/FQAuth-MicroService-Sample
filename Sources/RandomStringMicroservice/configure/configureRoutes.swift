import Vapor

extension Application {

  func configureRoutes() throws {
    try self.routes.register(collection: RandomStringController())
  }
}
