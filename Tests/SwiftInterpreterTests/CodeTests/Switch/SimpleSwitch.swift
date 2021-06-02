// assert matching_return_value
let x = 1
switch x {
case 1:
    return "hello"
default:
    return "world"
}

// assert matching_return_value
let x = 1
switch x {
case 1:
    return "hello"
default:
    return "world"
}

// assert matching_return_value
let x = 10
switch x {
case 1:
    return "hello"
default:
    return "world"
}

// assert matching_return_value
let x = 1.0
switch x {
case 1:
    return "hello"
default:
    return "world"
}

// assert matching_return_value
let x = 1.5
switch x {
case 1:
    return "hello"
default:
    return "world"
}

// assert does_not_compile
let x = 1
switch x {
case 1.0:
    return "hello"
default:
    return "world"
}

// assert matching_return_value
func x() -> Int {
    return 1
}
switch x() {
case 1:
    return "hello"
default:
    return "world"
}

// assert matching_return_value
func x() -> Double {
    return 1.0
}
switch x() {
case 1:
    return "hello"
default:
    return "world"
}

// assert does_not_compile
func x() -> Int {
    return 1
}
switch x() {
case 1.0:
    return "hello"
default:
    return "world"
}

// assert matching_return_value
func x() -> Double {
    return 1
}
switch x() {
case 1.0:
    return "hello"
default:
    return "world"
}