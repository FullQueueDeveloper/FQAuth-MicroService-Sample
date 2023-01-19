import Vapor

extension Application {

  func configure() throws {

    try self.configurePostgres()
    self.configureMigrations()
    self.configureRoutes()
    self.configureCommands()
  }
}
