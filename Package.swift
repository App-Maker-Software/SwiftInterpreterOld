// swift-tools-version:5.4
import PackageDescription
import Foundation

// depending on which branch we are on, we will declare different dependencies and targets
let gitBranch = shell("git branch --show-current").trimmingCharacters(in: .newlines)

// any git branch with "develop" in the dev will build from source
var BUILD_FROM_SOURCE: Bool = false
if gitBranch.contains("develop") {
    BUILD_FROM_SOURCE = true
} else {
    BUILD_FROM_SOURCE = false
}

// swiftui support only for binary builds
var SWIFTUI_SUPPORT: Bool = false
if gitBranch.contains("binary") || gitBranch.contains("main") {
    SWIFTUI_SUPPORT = true
} else {
    SWIFTUI_SUPPORT = false
}

// Dependencies
var dependencies: [Package.Dependency]!
if BUILD_FROM_SOURCE {
    dependencies = [
        .package(name: "SwiftInterpreterSource", path: "../SwiftInterpreterSource"),
        .package(name: "SwiftASTConstructor", url: "https://github.com/App-Maker-Software/SwiftASTConstructor.git", .exact("0.50400.0")),
        .package(name: "ViewInspector", url: "git@github.com:nalexn/ViewInspector.git", from: "0.8.1")
    ]
} else {
    dependencies = [
        .package(name: "SwiftASTConstructor", url: "https://github.com/App-Maker-Software/SwiftASTConstructor.git", .exact("0.50400.0")),
        .package(name: "ViewInspector", url: "git@github.com:nalexn/ViewInspector.git", from: "0.8.1")
    ]
}

// Targets
var targets: [Target]!
let testTargets: [Target] = [
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
    )
] + (SWIFTUI_SUPPORT ? [.testTarget(name: "SwiftUIInterpreterTests", dependencies: [
    "SwiftInterpreter",
    .product(name: "SwiftASTConstructor", package: "SwiftASTConstructor"),
    "ViewInspector"
])] : [])
if BUILD_FROM_SOURCE {
    targets = [
        .target(name: "SwiftInterpreter", dependencies: ["SwiftInterpreterSource"]),
    ] + testTargets
} else {
    targets = [
        .target(name: "SwiftInterpreter", dependencies: ["SwiftInterpreterBinary"]),
        .binaryTarget(name: "SwiftInterpreterBinary", url: "https://github.com/App-Maker-Software/SwiftInterpreter/releases/download/0.4.6/SwiftInterpreterBinary.xcframework.zip", checksum: "0caaff876afd62262ff3b6c99e1344c117771a9e4143e76282ada6c7e7b62d2f")
    ] + testTargets
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


// utils
// source: https://stackoverflow.com/a/50035059/3902590
func rawShell(_ command: String) -> String {
    let task = Process()
    let pipe = Pipe()
    
    task.standardOutput = pipe
    task.standardError = pipe
    task.arguments = ["-c", command]
    task.launchPath = "/bin/zsh"
    task.launch()
    
    let data = pipe.fileHandleForReading.readDataToEndOfFile()
    let output = String(data: data, encoding: .utf8)!
    
    return output
}
// adds package path to the call
func shell(_ command: String) -> String {
    let thisPackageDir = URL(fileURLWithPath: #file).deletingLastPathComponent().path
    return rawShell("cd \(thisPackageDir);\(command)")
}
