// assert does_not_compile
func genericTest(_ val: T) -> T {
    return val
}
let result = genericTest(3)

// assert matching_stack_value_result
func genericTest<T>(_ val: T) -> T {
    return val
}
let result = genericTest("hello world")

// assert matching_stack_value_result
func genericTest<T>(_ val: T) -> T {
    return val
}
let result = genericTest(5 + 2)

// assert matching_stack_value_result
func genericTest<T>(_ val: T) -> T {
    return val
}
let val1 = genericTest(5)
let val2 = genericTest(2)
let result = val1 + val2

// assert does_not_compile
func genericTest<T>(_ val: T) -> T {
    return val
}
let val1 = genericTest(5.5)
let val2 = genericTest(2)
let result = val1 + val2

// assert matching_stack_value_result
func genericTest<T>(_ val: T) -> T {
    return val
}
let val1 = genericTest(5.5)
let val2 = genericTest(2.2)
let result = val1 + val2

// assert matching_stack_value_result
func genericTest<T>(_ val: T) -> T {
    return val
}
let val1 = genericTest(5.0)
let val2 = genericTest(2.2)
let result = val1 + val2

// assert matching_stack_value_result
func genericTest<T>(_ val: T) -> T {
    return val
}
let val1 = genericTest(5.0)
let result = val1 + 2.0

// assert does_not_compile
func genericTest<T>(_ val: T) -> T {
    return val
}
let val1 = genericTest(5)
let result = val1 + 2.0
