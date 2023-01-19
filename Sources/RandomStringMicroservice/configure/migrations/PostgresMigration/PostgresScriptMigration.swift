import FluentPostgresDriver
import PostgresKit

protocol PostgresScriptMigration: PostgresMigration {
  var up: [String] { get }
  var down: [String] { get }
}

extension PostgresScriptMigration {
  func prepare(on database: PostgresDatabase) -> EventLoopFuture<Void> {
    database.exec(up)
  }

  func revert(on database: PostgresDatabase) -> EventLoopFuture<Void> {
    database.exec(down)
  }
}

extension PostgresDatabase {

  func exec(_ strings: [String]) -> EventLoopFuture<Void> {
    strings
      .reduce(eventLoop.future()) { partial, nextString in
        partial.flatMap { self.exec(nextString) }
      }
  }

  func exec(_ string: String) -> EventLoopFuture<Void>{
    self.logger.log(level: .trace, .init(stringLiteral: string))
    return self.simpleQuery(string, { _ in })
  }
}
