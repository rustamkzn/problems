// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "MathTrainer",
    platforms: [
        .macOS(.v14)
    ],
    products: [
        .executable(name: "MathTrainer", targets: ["MathTrainer"])
    ],
    targets: [
        .executableTarget(
            name: "MathTrainer",
            path: "Sources/MathTrainer"
        )
    ]
)
