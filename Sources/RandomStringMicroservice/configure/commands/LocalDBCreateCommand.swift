import Vapor
import Sh

#if DEBUG
struct LocalDBCreateCommand: Command {

  let owner: String, password: String, stem: String
  init(owner: String, password: String, stem: String) {
    self.owner = owner
    self.password = password
    self.stem = stem
  }

  let help: String = "Create local Postgres databases for development and testing. Install Postgres using `brew install postgresql`."

  func run(using context: ConsoleKit.CommandContext, signature: Signature) throws {
    try createRole(name: owner, password: password)

    try createDB(name: "\(stem)_test",
                 owner: owner)
    try ensureDBConnection(name: "\(stem)_test",
                           owner: owner,
                           password: password)

    try createDB(name: "\(stem)_dev",
                 owner: owner)
    try ensureDBConnection(name: "\(stem)_dev",
                           owner: owner,
                           password: password)
  }

  private func createDB(name: String, owner: String) throws {
    try sh(.terminal, "createdb -U postgres --owner=\(owner) \(name)")
  }

  private func ensureDBConnection(name: String, owner: String, password: String) throws {
    try sh(.null,
           """
           psql \
             --username=\(owner) \
             --host=localhost \(name) \
             -c "select version()"
           """,
           environment: ["PGPASSWORD": password])
  }

  private func createRole(name: String, password: String) throws {
    let createUserScript =
      """
      DO
      $do$
      BEGIN
        IF EXISTS (SELECT FROM pg_catalog.pg_roles WHERE rolname = '\(name)') THEN
          RAISE NOTICE 'User "\(name)" already exists. Skipping.';
        ELSE
          CREATE ROLE \(name) LOGIN PASSWORD '\(password)';
        END IF;
      END
      $do$;
      """

    try sh(.terminal,
            #"""
            psql \
              -U postgres \
              --command="$CREATE_USER_SCRIPT" \
              --command="\du" \
              postgres
            """#,
           environment: ["CREATE_USER_SCRIPT": createUserScript])
  }

  struct Signature: CommandSignature {
    init() { }
  }
}

#endif
