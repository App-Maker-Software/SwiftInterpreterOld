// assert matching_return_value
return () == ()

// assert matching_return_value
return () == Void()

// assert matching_return_value
return Void() == ()

// assert matching_return_value
return Void() == Void()

// assert matching_return_value
func getNothing() {}
return getNothing() == Void()

// assert matching_return_value
func getNothing() -> Void {}
return getNothing() == Void()

// assert matching_return_value
func getNothing() -> () {}
return getNothing() == Void()

// assert matching_return_value
func getNothing() {}
return Void() == getNothing()

// assert matching_return_value
func getNothing() -> Void {}
return Void() == getNothing()

// assert matching_return_value
func getNothing() -> () {}
return Void() == getNothing()
