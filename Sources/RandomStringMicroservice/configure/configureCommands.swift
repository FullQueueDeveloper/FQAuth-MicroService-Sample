import Vapor
import PostgresNIO
import Sh

extension Application {
  func configureCommands() {
    
#if DEBUG
    var localDBCommands = Commands()
    localDBCommands.use(LocalDBCreateCommand(owner: "random_string",
                                             password: "RandomString",
                                             stem: "random_string"),
                        as: "create")
    localDBCommands.use(LocalDBDestroyCommand(owner: "random_string",
                                              password: "RandomString",
                                              stem: "random_string"),
                        as: "destroy")
    
    let localDBGroup = localDBCommands.group(help: "Manage local Postgres databases for development and testing")
    self.commands.use(localDBGroup, as: "local-db")
#endif
  }
}
