import FluentPostgresDriver

final class CreateRandomStringsMigration: PostgresScriptMigration {

  let up: [String] = [
    """
    create table "random_strings" (
      id uuid PRIMARY KEY DEFAULT uuid_generate_v4 (),
      user_id uuid NOT NULL,
      random_string text NOT NULL,
      created_at timestamp WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP NOT NULL,
      updated_at timestamp WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP NOT NULL
    );
    """,
    #"""
    CREATE TRIGGER random_strings_updated_at_timestamp
      BEFORE UPDATE ON "random_strings" FOR EACH ROW
      EXECUTE PROCEDURE updated_at_timestamp();
    """#,
    ]

  let down: [String] = [
    #"DROP TABLE IF EXISTS "random_strings""#,
    ]
}
