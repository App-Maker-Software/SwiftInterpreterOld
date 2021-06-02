// assert matching_return_value
var test = [0]
test.append(1)
return test[1]

// assert does_not_compile
let test = [0]
test.append(1)
return test[1]

// assert does_not_compile
var test = [0].append(1)
return test[1]

// assert does_not_compile
let test = [0].append(1)
return test[1]

// assert does_not_compile
func makeArray() -> [Int] {
    return [0]
}
let test = makeArray().append(1)
return test[1]

// assert does_not_compile
func makeArray() -> [Int] {
    return [0]
}
var test = makeArray().append(1)
return test[1]

// assert does_not_compile
func makeArray() -> [Int] {
    return [0]
}
let test = makeArray()
test.append(1)
return test[1]

// assert matching_return_value
func makeArray() -> [Int] {
    return [0]
}
var test = makeArray()
test.append(1)
return test[1]

// assert matching_return_value
var test = [0]
test.append(contentsOf: [1,2])
return test[2]

// assert does_not_compile
let test = [0]
test.append(contentsOf: [1,2])
return test[2]

// assert does_not_compile
var test = [0].append(contentsOf: [1,2])
return test[2]

// assert does_not_compile
let test = [0].append(contentsOf: [1,2])
return test[2]

// assert does_not_compile
func makeArray() -> [Int] {
    return [0]
}
let test = makeArray().append(contentsOf: [1,2])
return test[2]

// assert does_not_compile
func makeArray() -> [Int] {
    return [0]
}
var test = makeArray().append(contentsOf: [1,2])
return test[2]

// assert does_not_compile
func makeArray() -> [Int] {
    return [0]
}
let test = makeArray()
test.append(contentsOf: [1,2])
return test[2]

// assert matching_return_value
func makeArray() -> [Int] {
    return [0]
}
var test = makeArray()
test.append(contentsOf: [1,2])
return test[2]
