xcodebuild -create-xcframework \
 -framework archives/SwiftInterpreterBinary-iOS.xcarchive/Products/Library/Frameworks/SwiftInterpreterBinary.framework \
 -framework archives/SwiftInterpreterBinary-macOS.xcarchive/Products/Library/Frameworks/SwiftInterpreterBinary.framework \
 -framework archives/SwiftInterpreterBinary-tvOS.xcarchive/Products/Library/Frameworks/SwiftInterpreterBinary.framework \
 -framework archives/SwiftInterpreterBinary-watchOS.xcarchive/Products/Library/Frameworks/SwiftInterpreterBinary.framework \
 -framework archives/SwiftInterpreterBinary-iOSsim.xcarchive/Products/Library/Frameworks/SwiftInterpreterBinary.framework \
 -framework archives/SwiftInterpreterBinary-tvOSsim.xcarchive/Products/Library/Frameworks/SwiftInterpreterBinary.framework \
 -framework archives/SwiftInterpreterBinary-watchOSsim.xcarchive/Products/Library/Frameworks/SwiftInterpreterBinary.framework \
 -output SwiftInterpreterBinary.xcframework

# -framework archives/SwiftInterpreterBinary-macOSCatalyst.xcarchive/Products/Library/Frameworks/SwiftInterpreterBinary.framework \
