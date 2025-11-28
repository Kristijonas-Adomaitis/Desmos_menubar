// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "DesmosMenubarApp",
    platforms: [
        .macOS(.v12)
    ],
    products: [
        .executable(
            name: "DesmosMenubarApp",
            targets: ["DesmosMenubarApp"]
        )
    ],
    targets: [
        .executableTarget(
            name: "DesmosMenubarApp",
            dependencies: []
        )
    ]
)
