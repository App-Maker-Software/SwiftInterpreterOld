# Swift Interpreter

An embeddable Swift interpreter for all versions of iOS, Mac, tvOS, and watchOS. Takes in Swift AST data constructed from [SwiftAST](https://github.com/App-Maker-Software/SwiftAST). Powers [LiveApp](http://github.com/App-Maker-Software/LiveApp) and [App Maker Professional](https://appmakerios.com).

## Features

Optional Libraries Supported

- Foundation
- Combine
- SwiftUI

See (TEST_RESULTS.md)[https://github.com/App-Maker-Software/SwiftInterpreter/blob/main/TEST_RESULTS.md].

## Test Results

The Swift interpreter has automated tests which run against real compiled Swift. You can see those test results in the generated MD file called (TEST_RESULTS.md)[https://github.com/App-Maker-Software/SwiftInterpreter/blob/main/TEST_RESULTS.md].

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