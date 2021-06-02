// assert matching_return_value
func test() -> Int {
    return 5
}
return test()

// assert matching_stack_value_x
func test() -> Int {
    return 5
}
let x = test()

// assert does_not_compile
func test() {
    return 5
}
let x = test()
