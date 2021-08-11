// swift-tools-version:5.4
import PackageDescription

let package = Package(
    name: "SwiftInterpreterBinary",
    products: [
        .library(
            name: "SwiftInterpreterBinary",
            targets: ["SwiftInterpreterBinary"]
        ),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "SwiftInterpreterBinary",
            dependencies: []
        ),
    ]
)
