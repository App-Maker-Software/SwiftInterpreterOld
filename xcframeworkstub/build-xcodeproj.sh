rm -rf SwiftInterpreterBinary.xcodeproj
swift package generate-xcodeproj
sed -i '' -e 's/SKIP_INSTALL = "YES";/SKIP_INSTALL = "NO";/g' SwiftInterpreterBinary.xcodeproj/project.pbxproj
sed -i '' -e 's/TARGET_NAME = "SwiftInterpreterBinary";/TARGET_NAME = "SwiftInterpreterBinary";\nBUILD_LIBRARY_FOR_DISTRIBUTION = "YES";\nSTRIP_STYLE = "non-global";\nSTRIP_SWIFT_SYMBOLS = "YES";\nSTRIP_INSTALLED_PRODUCT = "YES";/g' SwiftInterpreterBinary.xcodeproj/project.pbxproj
sed -i '' -e 's/SWIFT_OPTIMIZATION_LEVEL = "-Owholemodule";/SWIFT_OPTIMIZATION_LEVEL = "-Osize";/g' SwiftInterpreterBinary.xcodeproj/project.pbxproj
sed -i '' -e 's/GCC_OPTIMIZATION_LEVEL = "s";/GCC_OPTIMIZATION_LEVEL = "z";/g' SwiftInterpreterBinary.xcodeproj/project.pbxproj

