rm -rf archives
rm -rf SwiftInterpreterBinary.xcframework.zip
./build-xcodeproj.sh
./create-and-build-all-frameworks.sh
./create-xcframework.sh
zip -r SwiftInterpreterBinary.xcframework.zip SwiftInterpreterBinary.xcframework
rm -rf SwiftInterpreterBinary.xcframework
rm -rf archives
rm -rf SwiftInterpreterBinary.xcodeproj
rm -rf .build
rm -rf .swiftpm
