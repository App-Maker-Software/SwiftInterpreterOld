// assert matching_return_value
func test(_ x: Int) -> Int {
    return x
}
return test(5)

// assert matching_return_value
func test(x: Int) -> Int {
    return x
}
return test(x: 5)

// assert matching_return_value
func test(inLabel outLabel: Int) -> Int {
    return outLabel
}
return test(inLabel: 5)

// assert matching_return_value
func test(_ outLabel: Int) -> Int {
    return outLabel
}
return test(5)
