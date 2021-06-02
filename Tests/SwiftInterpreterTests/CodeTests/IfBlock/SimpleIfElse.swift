// assert matching_stack_value_x
var x = 0
if true {
    x = 2
} else if false {
    x = 3
}

// assert matching_stack_value_x
var x = 0
if x == 2 {
    x = 2
} else if true {
    x = 3
}

// assert matching_stack_value_x
var x = 0
if x == 2 {
    x = 2
} else if false {
    x = 3
} else if false {
    x = 3
}

// assert matching_stack_value_x
var x = 0
if x == 2 {
    x = 2
} else if false {
    x = 3
} else if false {
    x = 33
} else {
    x = 10
}

// assert matching_stack_value_x
var x = 0
if x == 2 {
    x = 2
} else if x == 0 {
    x = 3
} else {
    x = 0
}

// assert matching_stack_value_x
var x = 0
if x == 0 {
    x = 2
} else if x == 2 {
    x = 3
} else {
    x = 0
}

// assert matching_stack_value_x
var x = 2
if x == 0 {
    x = 2
} else if x == 2 {
    x = 3
} else {
    x = 0
}
