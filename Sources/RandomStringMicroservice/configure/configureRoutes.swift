import Vapor

extension Application {

  func configureRoutes() {
    self.routes.get("sample") { request in
      "hello"
    }
    
    self.routes.post("sample/regenerate") { request in
      HTTPStatus.ok
    }
  }
}
