// swift-tools-version:4.2

import PackageDescription

let package = Package(
    name: "swift-watch",
    dependencies: [
        .package(url: "https://github.com/JohnSundell/Files.git", from: "2.0.0"),
        .package(url: "https://github.com/daniel-pedersen/SKQueue.git", from: "1.1.0"),
        .package(url: "https://github.com/surfandneptune/CommandCougar.git", from: "1.0.0"),
        .package(url: "https://github.com/onevcat/Rainbow", from: "3.0.3"),
    ],
    targets: [
        .target(
            name: "swift-watch",
            dependencies: ["Files", "SKQueue", "CommandCougar", "Rainbow"]),
    ]
)
