// assert matching_return_value
var arr = [0]
var i = 1
while i <= 10 {
    i = i + 1
    arr.append(i)
}
return arr[2] + arr[4]
