//
//  FMDBStoreGenerator
//
//  Copyright (c) 2013 Kouji Ishii
//
//  This software is released under the MIT License.
//
//  http://opensource.org/licenses/mit-license.php
//

#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>
#import <objc/runtime.h>

#import "KO2Directory.h"
#import "KO2Generator.h"

//@interface KO2Directory()
//- (BOOL) createDirectory:(NSString*) dirPath;
//@end

@interface KO2DirectoryTests : XCTestCase
@end

@implementation KO2DirectoryTests

- (void)setUp
{
    [super setUp];
}

- (void)tearDown
{
    [super tearDown];
}

- (void)testString
{
    KO2Directory* target = [KO2Directory directoryWithOutputPath:@"/Path"];
    
    XCTAssertEqualObjects(target.string, @"/Path");
}

- (void)testCreateModelDirectory
{
    KO2Directory* target = [KO2Directory new];
    
    KO2Generator* entity = [KO2Generator new];
    entity.outputDirectory = [KO2Directory directoryWithOutputPath:@"/Path"];
    
    Method privateMethod = class_getInstanceMethod([KO2Directory class], @selector(createDirectory:));
    Method mockMethod = class_getInstanceMethod([KO2DirectoryTests class], @selector(createDirectory:));
    method_exchangeImplementations(privateMethod, mockMethod);
    
    BOOL result = [target createModelDirectory:entity];
    
    method_exchangeImplementations(mockMethod, privateMethod);
    
    XCTAssertTrue(result);
    XCTAssertEqualObjects(target.string, @"/Path/Models");
}

- (void)testCreateStoreDirectory
{
    KO2Directory* target = [KO2Directory new];
    
    KO2Generator* entity = [KO2Generator new];
    entity.outputDirectory = [KO2Directory directoryWithOutputPath:@"/Path"];
    entity.storeClassSuffix = @"repository";
    
    Method privateMethod = class_getInstanceMethod([KO2Directory class], @selector(createDirectory:));
    Method mockMethod = class_getInstanceMethod([KO2DirectoryTests class], @selector(createDirectory:));
    method_exchangeImplementations(privateMethod, mockMethod);
    
    BOOL result = [target createStoreDirectory:entity];

    method_exchangeImplementations(mockMethod, privateMethod);
    
    XCTAssertTrue(result);
    XCTAssertEqualObjects(target.string, @"/Path/Repositories");
}

- (void)testCreateFMDBCoreDirectory
{
    KO2Directory* target = [KO2Directory new];
    
    KO2Generator* entity = [KO2Generator new];
    entity.outputDirectory = [KO2Directory directoryWithOutputPath:@"/Path"];
    entity.storeClassSuffix = @"repository";
    
    Method privateMethod = class_getInstanceMethod([KO2Directory class], @selector(createDirectory:));
    Method mockMethod = class_getInstanceMethod([KO2DirectoryTests class], @selector(createDirectory:));
    method_exchangeImplementations(privateMethod, mockMethod);
    
    BOOL result = [target createFMDBCoreDirectory:entity];
    
    method_exchangeImplementations(mockMethod, privateMethod);    
    
    XCTAssertTrue(result);
    XCTAssertEqualObjects(target.string, @"/Path/fmdb");
}

- (void)testCreateDirectory_YES
{
    KO2Directory* target = [KO2Directory new];
    
    NSFileManager* manager =[NSFileManager defaultManager];
    id mock = [OCMockObject partialMockForObject:manager];
    [[[mock expect] andReturnValue:@YES] createDirectoryAtURL:[OCMArg any] withIntermediateDirectories:YES attributes:nil error:[OCMArg setTo:nil]];
    
    id result = [target performSelector:@selector(createDirectory:) withObject:@"/path"];
    
    [mock verify];
    [mock stopMocking];
    XCTAssertTrue(result);
    
}

- (void)testCreateDirectory_NO
{
    KO2Directory* target = [KO2Directory new];
    
    NSFileManager* manager =[NSFileManager defaultManager];
    id mock = [OCMockObject partialMockForObject:manager];
    [[[mock expect] andReturnValue:@NO] createDirectoryAtURL:[OCMArg any] withIntermediateDirectories:YES attributes:nil error:[OCMArg setTo:nil]];
    
    id result = [target performSelector:@selector(createDirectory:) withObject:@"/path"];
    
    [mock verify];
    [mock stopMocking];
    XCTAssertFalse(result);
    
}

#pragma mark - Stub Method

- (BOOL) createDirectory:(NSString*) dirPath {
    return YES;
}

@end
