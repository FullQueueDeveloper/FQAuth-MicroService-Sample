import Fluent

final class RandomStringModel: Model {

  static var schema: String = "random_strings"

  @ID
  var id: UUID?

  @Field(key: "user_id")
  var userID: UUID

  @Field(key: "random_string")
  var randomString: String

  @Field(key: "created_at")
  var createdAt: Date

  @Field(key: "updated_at")
  var updatedAt: Date
  
}
