// swift-tools-version:5.7

import PackageDescription

let package = Package(
  name: "RandomStringMicroservice",
  platforms: [
      .macOS(.v11),
  ],
  products: [
    .executable(name: "RandomStringMicroservice", targets: ["RandomStringMicroservice"]),
  ],
  dependencies: [
    .package(url: "https://github.com/vapor/vapor.git", from: "4.65.1"),
    .package(url: "https://github.com/vapor/jwt.git", from: "4.2.1"),

    .package(url: "https://github.com/vapor/fluent.git", from: "4.3.1"),
    .package(url: "https://github.com/vapor/fluent-postgres-driver.git", from: "2.1.3"),
    .package(url: "https://github.com/vapor/postgres-kit.git", from: "2.3.0"),

    .package(url: "https://github.com/FullQueueDeveloper/FQAuth", branch: "initial"),
    .package(url: "https://github.com/FullQueueDeveloper/Sh", from: "1.0.0"),

  ],
  targets: [
    .executableTarget(name: "RandomStringMicroservice", dependencies: [
      .product(name: "Vapor", package: "vapor"),
      .product(name: "JWT", package: "jwt"),

      .product(name: "PostgresKit", package: "postgres-kit"),
      .product(name: "Fluent", package: "fluent"),
      .product(name: "FluentPostgresDriver", package: "fluent-postgres-driver"),
      .product(name: "FQAuthMiddleware", package: "FQAuth"),
      "Sh",
    ],
    swiftSettings: [
        .unsafeFlags(["-cross-module-optimization"], .when(configuration: .release))
    ]),
  ]
)
