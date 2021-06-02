// assert matching_return_value
return [1][0]

// assert matching_return_value
let x = [1]
let y = x[0]
return y

// assert matching_return_value
let x = [1]
let y = x[0] + x[0]
return y

// assert matching_return_value
let x = [1, 2]
let y = x[x[0]] + x[0]
return y

// assert matching_return_value
let x = ["test"]
let y = x[0]
let z = [y]
return z[0]

// assert matching_return_value
let msgArray = ["hello","world"]
let msgString = msgArray[0] + msgArray[1]
return msgString

