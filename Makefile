test:
	xcodebuild \
    -workspace FMDBStoreGenerator.xcworkspace \
    -scheme FMDBStoreGeneratorTests \
    -configuration Debug \
    -sdk macosx10.9 \
	ONLY_ACTIVE_ARCH=NO \
     TEST_AFTER_BUILD=YES \
     TEST_HOST= \
     GCC_INSTRUMENT_PROGRAM_FLOW_ARCS=YES \
     GCC_GENERATE_TEST_COVERAGE_FILES=YES \
     clean build test

send-coverage:
	coveralls \
    -e FMDBStoreGeneratotTests/Models
