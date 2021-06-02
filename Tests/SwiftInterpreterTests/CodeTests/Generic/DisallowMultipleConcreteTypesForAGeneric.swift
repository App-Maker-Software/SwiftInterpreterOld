// assert matching_stack_value_result
func genericTest<T>(_ val1: T, _ val2: T) -> T {
    return val1
}
let result = genericTest(1, 3)

// assert matching_stack_value_result
func genericTest<T>(_ val1: T, _ val2: T) -> T {
    return val1
}
let result = genericTest(1, 3.5)

// assert does_not_compile
func genericTest<T>(_ val1: T, _ val2: T) -> T {
    return val1
}
let someInt = 1
let result = genericTest(someInt, 3.5)

// assert does_not_compile
func genericTest<T, U>(_ val1: T, _ val2: T, _ val3: U) -> T {
    return val1
}
let someInt = 1
let someDouble = 1.5
let someDouble2 = 1.5
let result = genericTest(someInt, someDouble, someDouble2)

// assert matching_stack_value_result
func genericTest<T, U>(_ val1: T, _ val2: T, _ val3: U) -> T {
    return val1
}
let someInt = 1
let someInt2 = 1
let someDouble = 1.5
let result = genericTest(someInt, someInt2, someDouble)
