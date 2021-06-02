// assert matching_return_value
return true ? 5 : 0

// assert matching_return_value
return false ? 5 : 0

// assert matching_return_value
return false ? 5 : (false ? 5 : 0)

// assert matching_return_value
return false ? 5 : (true ? 5 : 0)

// assert matching_return_value
return true ? 5 : (true ? 5 : 0)

// assert matching_return_value
return true ? 5 : (false ? 5 : 0)

// assert matching_return_value
return true ? (false ? 5 : 0) : (false ? 5 : 0)

// assert matching_return_value
return true ? (true ? 5 : 0) : (false ? 5 : 0)
