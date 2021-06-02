// assert matching_stack_value_x
let x = 12 % 2

// assert matching_stack_value_x
let x = 13 % 2

// assert matching_stack_value_x
let x = 13 % 10

// assert matching_stack_value_x
let x = 1303 % 7

// assert does_not_compile
let x = 1303 % 7.5

// assert does_not_compile
let x = 1303.5 % 7

// assert does_not_compile
let x = 1303 % 7.0

// assert does_not_compile
let x = 1303.0 % 7

// assert does_not_compile
let x = 1303.0 % 7.0
