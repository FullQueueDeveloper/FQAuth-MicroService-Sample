import Vapor

extension Application {

  func configure() throws {

    try self.configurePostgres()
    self.configureMigrations()
    try self.configureRoutes()
    self.configureCommands()
    self.configureSigning()
  }
}
