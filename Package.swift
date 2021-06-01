// swift-tools-version:5.4
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription
import Foundation

var products: [Product] = [
    .library(
        name: "SwiftInterpreter",
        targets: ["SwiftInterpreter"]
    )
]
var dependencies: [Package.Dependency] = [
    .package(name: "SwiftASTConstructor", url: "https://github.com/App-Maker-Software/SwiftASTConstructor.git", .exact("0.50400.0")),
]
var targets: [Target] = [
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
    .binaryTarget(name: "SwiftInterpreterBinary", url: "https://github.com/App-Maker-Software/SwiftInterpreter/releases/download/0.3/SwiftInterpreterBinary.xcframework.zip", checksum: "a1942a1ffb6e32a96867721532d31806df61d86b92ec13ef8b01784d988be24a")
]

if ProcessInfo.processInfo.environment["BUILD_SWIFT_INTERPRETER_FROM_SOURCE"] != nil {
    // add source as a dependency
    dependencies.append(.package(name: "SwiftInterpreterSource", url: "git@github.com:App-Maker-Software/SwiftInterpreterSource.git", .branch("main")))
    // add source as a target
    targets.append(.target(name: "SwiftInterpreterFromSource", dependencies: ["SwiftInterpreterSource"]))
    // add local binary builds as a target
    targets.append(.binaryTarget(name: "SwiftInterpreterLocalBinary", path: "../SwiftInterpreterSource/SwiftInterpreterBinary.xcframework"))
    // add two new products, one for building from source, and one for testing local binary builds
    products.append(contentsOf: [
        .library(
            name: "SwiftInterpreterFromSource",
            targets: ["SwiftInterpreterFromSource"]
        ),
        .library(
            name: "SwiftInterpreterFromLocalBinary",
            targets: ["SwiftInterpreterLocalBinary"]
        ),
    ])
    // add new dependencies to test target
    if targets[1].name != "SwiftInterpreterTests" { // sanity check
        fatalError()
    }
    let copy = targets[1]
    copy.name = "SwiftInterpreterFromSourceTests"
    copy.path = "Tests/_SwiftInterpreterFromSourceTests"
    copy.dependencies = [
        "SwiftInterpreterFromSource",
        .product(name: "SwiftASTConstructor", package: "SwiftASTConstructor")
    ]
    targets.append(copy)
    let copy2 = targets[1]
    copy2.name = "SwiftInterpreterFromLocalBinaryTests"
    copy2.path = "Tests/_SwiftInterpreterFromLocalBinaryTests"
    copy2.dependencies = [
        "SwiftInterpreterLocalBinary",
        .product(name: "SwiftASTConstructor", package: "SwiftASTConstructor")
    ]
    targets.append(copy2)
}

let package = Package(
    name: "SwiftInterpreter",
    products: products,
    dependencies: dependencies,
    targets: targets
)
