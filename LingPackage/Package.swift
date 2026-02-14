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
        .library(name: "LingApp", targets: ["LingApp"]),
        .library(name: "LingExtension", targets: ["LingExtension"]),
        .library(name: "LingTranslationFeature", targets: ["LingTranslationFeature"])
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
        ),
        .target(
            name: "LingExtension",
            dependencies: ["LingCore", "LingServices", "LingPersistence"]
        ),
        .target(
            name: "LingTranslationFeature",
            dependencies: ["LingCore", "LingServices", "LingPersistence", "LingExtension"]
        )
    ]
)
