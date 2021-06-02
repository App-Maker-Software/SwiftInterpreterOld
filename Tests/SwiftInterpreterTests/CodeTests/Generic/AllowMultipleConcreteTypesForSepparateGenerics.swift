// assert matching_stack_value_result
func genericTest<T, U>(_ val1: T, _ val2: U) -> T {
    return val1
}
let someInt = 1
let someDouble = 1.5
let result = genericTest(someInt, someDouble)

// assert matching_stack_value_result
func genericTest<T, U>(_ val1: T, _ val2: U) -> T {
    return val1
}
let someInt = 1
let someDouble = 1.5
let result = genericTest(someDouble, someInt)

// assert does_not_compile
func genericTest<T>(_ val1: T, _ val2: U) -> T {
    return val1
}
