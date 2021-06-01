# Swift Interpreter

An embeddable Swift interpreter for all versions of iOS, Mac, tvOS, and watchOS. Takes in Swift AST data constructed from [SwiftAST](https://github.com/App-Maker-Software/SwiftAST). Powers [LiveApp](http://github.com/App-Maker-Software/LiveApp) and [App Maker Professional](https://appmakerios.com).

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

To build from source, first clone [SwiftInterpreterSource](https://github.com/App-Maker-Software/SwiftInterpreterSource) in the same directory as this repo.

<img width="330" alt="image" src="https://user-images.githubusercontent.com/8505851/120383244-e4622700-c2e1-11eb-84b5-8ac140bc45fa.png">

Then run `swift package generate-xcodeproj` to produce `SwiftInterpreter.xcodeproj`.

Then drag the `SwiftInterpreterSource` folder into the navigation panel of SwiftInterpreter. This should prompt asking to create a workspace. Create the workspace under the `SwiftInterpreter` folder and call it `SwiftInterpreter.xcworkspace`.

<img width="781" alt="image" src="https://user-images.githubusercontent.com/8505851/120383455-212e1e00-c2e2-11eb-9b9f-76842b8d75b1.png">

Open the workspace and edit the `SwiftInterpreter-Package` schema. Set an environment variable called `BUILD_SWIFT_INTERPRETER_FROM_SOURCE` to `1`.

<img width="1172" alt="image" src="https://user-images.githubusercontent.com/8505851/120383532-373bde80-c2e2-11eb-9be5-40e6336cf761.png">

Now when you build, it will automatically build the Swift Interpreter from source and use that in your tests.


