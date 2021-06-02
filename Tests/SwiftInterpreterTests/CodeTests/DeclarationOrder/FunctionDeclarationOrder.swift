// assert matching_stack_value_result
func test() -> Int {
    return 5
}
let result = test()

// assert does_not_compile
func withinFunc() -> Int {
    let result = test()
    func test() -> Int {
        return 5
    }
    return result
}
withinFunc()

// assert matching_stack_value_result
func withinFunc() -> Int {
    func test() -> Int {
        return 5
    }
    let test2 = test()
    return test2
}
let result = withinFunc()
