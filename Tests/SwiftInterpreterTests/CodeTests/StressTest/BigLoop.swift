// assert matching_return_value
var i = 0
while i < 10000 {
    i = i + 1
}
return i

// assert matching_return_value
var i = 0
while i < 10000 {
    i = i + 1
    var j = 0
    while j < 10 {
        j = j + 1
    }
}
return i