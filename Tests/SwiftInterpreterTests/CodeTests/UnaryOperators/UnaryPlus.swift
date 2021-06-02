// assert matching_return_value
let x = 5
return +x

// assert matching_return_value
let x = 5
let y = +x
return y

// assert matching_return_value
let x = 5
let y = +x
return +y

// assert matching_return_value
let x = 5
return +(+x)
