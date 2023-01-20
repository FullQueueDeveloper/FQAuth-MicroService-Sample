import Vapor
import FQAuthMiddleware

extension Application {

  func configureSigning() {
    self.jwt.signers.useAuthPrivate()
  }
}
