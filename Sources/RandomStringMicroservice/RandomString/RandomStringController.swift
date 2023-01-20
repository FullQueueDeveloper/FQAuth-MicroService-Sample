import Vapor
import FQAuthMiddleware

final class RandomStringController: RouteCollection {

  func boot(routes: RoutesBuilder) throws {
    routes.group("api") { api in
      api.group(FQAuthMiddleware()) { guarded in
        guarded.get("sample", use: self.get(request:))
        guarded.post("sample/regenerate", use: self.new(request:))
      }
    }
  }
}
