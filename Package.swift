// swift-tools-version:5.4
import PackageDescription
import Foundation

let package = Package(
    name: "SwiftInterpreter",
    products: [
        .library(
            name: "SwiftInterpreter",
            targets: ["SwiftInterpreter"]
        ),
        .library(
            name: "SwiftInterpreterDebugOnly",
            targets: ["SwiftInterpreterDebugOnly"]
        )
    ],
    dependencies: [
        .package(name: "SwiftASTConstructor", url: "https://github.com/App-Maker-Software/SwiftASTConstructor.git", .exact("0.50400.0")),
//        .package(name: "SwiftInterpreterSource", url: "git@github.com:App-Maker-Software/SwiftInterpreterSource.git", .branch("main")),
    ],
    targets: [
        .target(name: "SwiftInterpreter", dependencies: ["SwiftInterpreterBinary"]),
        .target(
            name: "SwiftInterpreterDebugOnly",
//            dependencies: [.target(name: "SwiftInterpreterBinary", .when(configuration: .debug))], // does not work, awaiting spm support
            linkerSettings: [.linkedFramework("SwiftInterpreterBinary", .when(configuration: .debug))] // relies on build script to embeded and sign the xcframework for debug builds
        ),
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
        .binaryTarget(name: "SwiftInterpreterBinary", url: "https://github.com/App-Maker-Software/SwiftInterpreter/releases/download/0.4.2/SwiftInterpreterBinary.xcframework.zip", checksum: "ed63486b19736bc235aeedace5f94d5dd364c0dc6acd887828f6b295c3830ebc")
    ]
)
