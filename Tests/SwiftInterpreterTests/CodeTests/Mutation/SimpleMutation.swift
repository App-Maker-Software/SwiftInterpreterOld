// assert matching_stack_value_x
var x = 5
x = x + 5

// assert matching_stack_value_x
var x = 5
x = x + 5
x = x - 2

// assert matching_stack_value_x
var x = 5
x += 3

// assert does_not_compile
let x = 5
x += 3

// assert does_not_compile
let x = 5
x = x + 5
