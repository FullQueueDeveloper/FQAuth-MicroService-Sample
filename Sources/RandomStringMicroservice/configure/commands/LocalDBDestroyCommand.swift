import Vapor
import Sh

#if DEBUG
struct LocalDBDestroyCommand: Command {

  let owner: String, password: String, stem: String
  init(owner: String, password: String, stem: String) {
    self.owner = owner
    self.password = password
    self.stem = stem
  }

  let help: String = "Destroy local Postgres databases for development and testing"

  func run(using context: ConsoleKit.CommandContext, signature: Signature) throws {

    try sh(.terminal, "dropdb -U postgres --if-exists \(stem)_dev")
    try sh(.terminal, "dropdb -U postgres --if-exists \(stem)_test")

    try sh(.terminal, """
      psql \
        -U postgres \
        --command="DROP USER IF EXISTS \(stem)" \
        --command="\\du" \
        postgres
      """
           )
  }

  struct Signature: CommandSignature {
    init() { }
  }
}
#endif
