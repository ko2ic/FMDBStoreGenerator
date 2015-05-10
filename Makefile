test:
	xcodebuild \
    -workspace FMDBStoreGenerator.xcworkspace \
    -scheme FMDBStoreGeneratorTests \
    -configuration Debug \
    -sdk macosx10.10 \
		-destination 'platform=OS X,arch=x86_64' \
     clean build test

send-coverage:
	coveralls \
    -e FMDBStoreGeneratotTests/Models
