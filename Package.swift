// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftDockerClient",
    platforms: [
        .macOS(.v10_15)
    ],
    dependencies: [
        .package(url: "https://github.com/swift-server/async-http-client.git", from: "1.0.0")
    ],
    targets: [
        .target(
            name: "SwiftDockerClientModel",
            dependencies: []),
        .target(
            name: "SwiftDockerClient",
            dependencies: [
                "SwiftDockerClientModel",
                .product(name: "AsyncHTTPClient", package: "async-http-client")
            ]),
        .executableTarget(name: "Examples",
                          dependencies: [
                            "SwiftDockerClient",
                            "SwiftDockerClientModel"
                          ]),
        .testTarget(
            name: "SwiftDockerClientTests",
            dependencies: ["SwiftDockerClient", "SwiftDockerClientModel"]),
    ]
)
