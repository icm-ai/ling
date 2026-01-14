// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "Ling",
    platforms: [
        .iOS(.v17),
        .macOS(.v14)
    ],
    products: [
        .library(name: "LingCore", targets: ["LingCore"]),
        .library(name: "LingServices", targets: ["LingServices"]),
        .library(name: "LingPersistence", targets: ["LingPersistence"]),
        .library(name: "LingApp", targets: ["LingApp"])
    ],
    targets: [
        .target(
            name: "LingCore"
        ),
        .target(
            name: "LingPersistence",
            dependencies: ["LingCore"]
        ),
        .target(
            name: "LingServices",
            dependencies: ["LingCore"]
        ),
        .target(
            name: "LingApp",                
            dependencies: ["LingCore", "LingServices", "LingPersistence"]
        )
    ]
)
