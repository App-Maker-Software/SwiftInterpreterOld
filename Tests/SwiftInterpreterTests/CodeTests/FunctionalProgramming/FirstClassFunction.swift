// assert matching_return_value
func testFunc() -> Int {
    return 5
}
let testFunc2 = testFunc
return testFunc2()

// assert matching_return_value
func testFunc() -> Int {
    return 5
}
func testFunc2(_ otherFunc: () -> Int) -> Int {
    return otherFunc()
}
return testFunc2(testFunc)
