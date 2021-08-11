xcodebuild archive \
-project SwiftInterpreterBinary.xcodeproj \
-configuration "Release" \
-destination="iOS" \
-sdk iphoneos \
-scheme SwiftInterpreterBinary-Package \
-archivePath "archives/SwiftInterpreterBinary-iOS" \
SKIP_INSTALL=NO \
STRIP_STYLE=non-global \
STRIP_SWIFT_SYMBOLS=YES \
BUILD_LIBRARY_FOR_DISTRIBUTION=YES

xcodebuild archive \
-project SwiftInterpreterBinary.xcodeproj \
-configuration "Release" \
-destination="macOS" \
-sdk macosx \
-scheme SwiftInterpreterBinary-Package \
-archivePath "archives/SwiftInterpreterBinary-macOS" \
SKIP_INSTALL=NO \
STRIP_STYLE=non-global
STRIP_SWIFT_SYMBOLS=YES \
BUILD_LIBRARY_FOR_DISTRIBUTION=YES

#xcodebuild archive \
#-project SwiftInterpreterBinary.xcodeproj \
#-configuration "Release" \
#-destination 'platform=macOS,arch=x86_64h,variant=Mac Catalyst'
#-sdk macosx \
#-scheme SwiftInterpreterBinary-Package \
#-archivePath "archives/SwiftInterpreterBinary-macOSCatalyst" \
#SKIP_INSTALL=NO \
#STRIP_STYLE=non-global
#STRIP_SWIFT_SYMBOLS=YES \
#BUILD_LIBRARY_FOR_DISTRIBUTION=YES \
#SUPPORTS_MACCATALYST=YES

xcodebuild archive \
-project SwiftInterpreterBinary.xcodeproj \
-configuration "Release" \
-destination="tvOS" \
-sdk appletvos \
-scheme SwiftInterpreterBinary-Package \
-archivePath "archives/SwiftInterpreterBinary-tvOS" \
SKIP_INSTALL=NO \
STRIP_STYLE=non-global
STRIP_SWIFT_SYMBOLS=YES \
BUILD_LIBRARY_FOR_DISTRIBUTION=YES

xcodebuild archive \
-project SwiftInterpreterBinary.xcodeproj \
-configuration "Release" \
-destination="watchOS" \
-sdk watchos \
-scheme SwiftInterpreterBinary-Package \
-archivePath "archives/SwiftInterpreterBinary-watchOS" \
SKIP_INSTALL=NO \
STRIP_STYLE=non-global
STRIP_SWIFT_SYMBOLS=YES \
BUILD_LIBRARY_FOR_DISTRIBUTION=YES


xcodebuild archive \
-project SwiftInterpreterBinary.xcodeproj \
-configuration "Release" \
-destination="iOS" \
-sdk iphonesimulator \
-scheme SwiftInterpreterBinary-Package \
-archivePath "archives/SwiftInterpreterBinary-iOSsim" \
SKIP_INSTALL=NO \
STRIP_STYLE=non-global
STRIP_SWIFT_SYMBOLS=YES \
BUILD_LIBRARY_FOR_DISTRIBUTION=YES

xcodebuild archive \
-project SwiftInterpreterBinary.xcodeproj \
-configuration "Release" \
-destination="tvOS" \
-sdk appletvsimulator \
-scheme SwiftInterpreterBinary-Package \
-archivePath "archives/SwiftInterpreterBinary-tvOSsim" \
SKIP_INSTALL=NO \
STRIP_STYLE=non-global
STRIP_SWIFT_SYMBOLS=YES \
BUILD_LIBRARY_FOR_DISTRIBUTION=YES

xcodebuild archive \
-project SwiftInterpreterBinary.xcodeproj \
-configuration "Release" \
-destination="watchOS" \
-sdk watchsimulator \
-scheme SwiftInterpreterBinary-Package \
-archivePath "archives/SwiftInterpreterBinary-watchOSsim" \
SKIP_INSTALL=NO \
STRIP_STYLE=non-global
STRIP_SWIFT_SYMBOLS=YES \
BUILD_LIBRARY_FOR_DISTRIBUTION=YES
