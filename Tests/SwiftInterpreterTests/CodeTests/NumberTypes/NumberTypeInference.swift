// assert matching_return_value
let x = 5.5
let y = 5.7
return x + y

// assert matching_return_value
let x = 3
let y = 5
return x + y

// assert does_not_compile
let x = 5
let y = 5.5
return x + y

// assert matching_return_value
return 5 + 5.3
