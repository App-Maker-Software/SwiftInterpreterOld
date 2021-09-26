# Swift Interpreter

An embeddable Swift interpreter for all versions of iOS, Mac, tvOS, and watchOS. Takes in Swift AST data constructed from [SwiftAST](https://github.com/App-Maker-Software/SwiftAST). Powers [LiveApp](http://github.com/App-Maker-Software/LiveApp) and [App Maker Professional](https://appmakerios.com).

# Notice: Moving

The Swift interpreter is being both re-written and published open source. You will find the open source version [here](https://github.com/App-Maker-Software/SwiftInterpreter) once it is published. This repository will be archived and renamed to SwiftInterpreterOld.








## Features

Optional Libraries Supported

- Foundation
- Combine
- SwiftUI

See [TEST_RESULTS.md](https://github.com/App-Maker-Software/SwiftInterpreter/blob/main/TEST_RESULTS.md).

## Test Results

The Swift interpreter has automated tests which run against real compiled Swift. You can see those test results in the generated MD file called [TEST_RESULTS.md](https://github.com/App-Maker-Software/SwiftInterpreter/blob/main/TEST_RESULTS.md).

Each time `run_tests.sh` is run while on the "staging" or "main" branch, this md `TEST_RESULTS.md` is automatically updated.

## Adding a Test

You can add a new test by adding a folder under [CodeTests](https://github.com/App-Maker-Software/SwiftInterpreter/tree/main/Tests/SwiftInterpreterTests/CodeTests) with the desired test suite name with swift files for each test you would like to run.

For example: `Tests/SwiftInterpreterTests/CodeTests/TEST_SUITE/TEST_NAME.swift`

Some example test files:

```swift
// assert matching_return_value
var arr = [0]
arr.append(10)
return arr[1]
```

```swift
// assert matching_stack_value_x
var x = 5
x += 10
```

```swift
// assert does_not_compile
let x = 5
let y = 5.0
let z = x + y // error, you cannot sum an Int and Double
```

These will automatically produce a test to compare the result of running the interpreted Swift against the result of running compiled Swift.

There are three assertions currently supported.

1. `// assert matching_return_value`

- you must provide a `return` statement at the end of your program

2. `// assert matching_stack_value_x`

- where `x` can be any global variable name

2. `// assert does_not_compile`

- does not attempt to compile the Swift code, as it would fail
- test expects interpreter to throw an error

## Building from Source

Note: The Swift Interpreter is provided as a prebuilt binary, if you would like to have access to source, contact Joe Hinkle.


## XCFramework Stub

There is a "stub" of the Swift Interpreter XCFramework which is simply an empty XCFramework. This existence of this stub is to allow for a hack for schema-tied dependencies in Swift Packages until conditional target dependencies is fully implemented in SPM. https://github.com/apple/swift-evolution/blob/main/proposals/0273-swiftpm-conditional-target-dependencies.md

The hack works by having a build script swap out a hard link to either point to the real XCFramework or the stub depending on the selected scheme. i.e. "Debug" builds will have the hard link point to the real XCFramework, while "Release" builds will point to the stub. This will probably only be used by [LiveApp](http://github.com/App-Maker-Software/LiveApp). There we are wanting to use the interpreter to provide developer tools, but we don't want to change how production builds work. 
