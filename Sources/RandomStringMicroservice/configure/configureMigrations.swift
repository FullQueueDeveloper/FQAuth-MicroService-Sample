import FluentPostgresDriver
import Vapor

extension Application {
  func configureMigrations() {
    self.migrations.add(CreateFunctionMigration(),
                        CreateRandomStringsMigration(),
                        to: .psql)
  }
}
