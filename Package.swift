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
//        .package(name: "SwiftInterpreterSource", url: "git@github.com:App-Maker-Software/SwiftInterpreterSource.git", .branch("main")),
    ],
    targets: [
        .target(name: "SwiftInterpreter", dependencies: ["SwiftInterpreterBinary"]),
//        .target(name: "SwiftInterpreter", dependencies: ["SwiftInterpreterSource"]),
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
        .binaryTarget(name: "SwiftInterpreterBinary", url: "https://github.com/App-Maker-Software/SwiftInterpreter/releases/download/0.4.1/SwiftInterpreterBinary.xcframework.zip", checksum: "5603eea98a18a3f0b6844f92a95904e7d855e97043f07ff0fb4a9eaf116bb61b")
    ]
)
