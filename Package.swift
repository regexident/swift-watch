// swift-tools-version: 5.4
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "swift-watch",
    platforms: [
        .macOS(.v10_15),
    ],
    products: [
        .executable(
            name: "swift-watch",
            targets: [
                "swift-watch",
            ]
        ),
    ],
    dependencies: [
        .package(
            url: "https://github.com/JohnSundell/Files",
            from: "3.1.0"
        ),
        .package(
            url: "https://github.com/daniel-pedersen/SKQueue",
            from: "1.2.0"
        ),
        .package(
            url: "https://github.com/surfandneptune/CommandCougar",
            from: "1.1.1"
        ),
        .package(
            url: "https://github.com/onevcat/Rainbow",
            from: "3.1.0"
        ),
    ],
    targets: [
        .executableTarget(
            name: "swift-watch",
            dependencies: [
                "Files",
                "SKQueue",
                "CommandCougar",
                "Rainbow",
            ]
        ),
    ]
)
