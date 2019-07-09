// swift-tools-version:4.2

import PackageDescription

let package = Package(
    name: "swift-watch",
    dependencies: [
        .package(url: "https://github.com/JohnSundell/Files", from: "3.1.0"),
        .package(url: "https://github.com/daniel-pedersen/SKQueue", from: "1.2.0"),
        .package(url: "https://github.com/surfandneptune/CommandCougar", from: "1.1.1"),
        .package(url: "https://github.com/onevcat/Rainbow", from: "3.1.0"),
    ],
    targets: [
        .target(
            name: "swift-watch",
            dependencies: ["Files", "SKQueue", "CommandCougar", "Rainbow"]
        ),
    ]
)
