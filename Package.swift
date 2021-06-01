// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription
import Foundation

var dependencies: [Package.Dependency] = [
    .package(name: "SwiftAST", url: "https://github.com/App-Maker-Software/SwiftAST.git", .exact("0.50400.0")),
]
let targets: [Target] = [
    .target(name: "SwiftInterpreter"),
    .testTarget(
        name: "SwiftInterpreterTests",
        dependencies: [
            "SwiftInterpreter",
            .product(name: "SwiftASTConstructor", package: "SwiftAST")
        ],
        exclude: [
            "CodeTests/",
            "quick_test.py",
            "quick_test.pyc",
            "build_automatic_tests.py",
            "build_automatic_tests.pyc"
        ]
    ),
]

if ProcessInfo.processInfo.environment["BUILD_SWIFT_INTERPRETER_FROM_SOURCE"] != nil {
    dependencies.append(.package(name: "SwiftInterpreterSource", path: "../SwiftInterpreterSource"))
    targets[0].dependencies = ["SwiftInterpreterSource"]
} else if if ProcessInfo.processInfo.environment["TEST_SWIFT_INTERPRETER_BINARY"] != nil {
    targets.append(.binaryTarget(name: "SwiftInterpreterBinary", path: "../SwiftInterpreterSource/SwiftInterpreterBinary.xcframework.zip"))
    targets[0].dependencies = ["SwiftInterpreterBinary"]
} else {
    #error("no remote binary support yet")
//    targets.append(.binaryTarget(name: "SwiftInterpreterBinary", url: "https://github.com/App-Maker-Software/SwiftInterpreter/releases/download/<#T##String#>/SwiftInterpreterBinary.xcframework.zip", checksum: <#T##String#>))
    targets[0].dependencies = ["SwiftInterpreterBinary"]
}

let package = Package(
    name: "SwiftInterpreter",
    products: [
        .library(
            name: "SwiftInterpreter",
            targets: ["SwiftInterpreter"]
        )
    ],
    dependencies: dependencies,
    targets: targets
)
