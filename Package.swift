// swift-tools-version:5.4
import PackageDescription
import Foundation

let package = Package(
    name: "SwiftInterpreter",
    products: [
        .library(
            name: "SwiftInterpreter",
            targets: ["SwiftInterpreter"]
        )
    ],
    dependencies: [
        .package(name: "SwiftASTConstructor", url: "https://github.com/App-Maker-Software/SwiftASTConstructor.git", .exact("0.50400.0")),
    ],
    targets: [
        .target(name: "SwiftInterpreter", dependencies: ["SwiftInterpreterBinary"]),
        .testTarget(
            name: "SwiftInterpreterTests",
            dependencies: [
                "SwiftInterpreter",
                .product(name: "SwiftASTConstructor", package: "SwiftASTConstructor")
            ],
            exclude: [
                "CodeTests/",
                "quick_test.py",
                "quick_test.pyc",
                "build_automatic_tests.py",
                "build_automatic_tests.pyc"
            ]
        ),
        .binaryTarget(name: "SwiftInterpreterBinary", url: "https://github.com/App-Maker-Software/SwiftInterpreter/releases/download/0.4.0/SwiftInterpreterBinary.xcframework.zip", checksum: "43b88947a17d2304613f773635f28f2470794f5b9107286da03df27cf37e4815")
    ]
)
