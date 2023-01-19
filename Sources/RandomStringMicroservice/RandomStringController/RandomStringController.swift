import Vapor
import FQAuthMiddleware

final class RandomStringController: RouteCollection {

  func boot(routes: RoutesBuilder) throws {

    routes.group("api") { api in
      api.group(FQAuthMiddleware()) { guarded in

        guarded.get("sample") { request in
          "hello"
        }

        guarded.post("sample/regenerate") { request in
          HTTPStatus.ok
        }
      }
    }
  }
}


public struct FQAuthMiddleware: Middleware {
  public func respond(to request: Request, chainingTo next: Responder) -> EventLoopFuture<Response> {
    guard let _ = request.auth.get(FQAuthSessionToken.self) else {
      return request.eventLoop.future(error: Abort(.unauthorized))
    }
    return next.respond(to: request)
  }
}
