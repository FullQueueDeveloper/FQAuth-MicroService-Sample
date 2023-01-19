import Vapor
import Fluent

#if DEBUG
extension Application {
  func resetDatabase() throws {
    try self.autoRevert().wait()
    try self.autoMigrate().wait()
  }
}
#endif
