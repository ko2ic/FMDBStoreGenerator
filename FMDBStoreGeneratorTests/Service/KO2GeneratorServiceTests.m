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

#import "KO2GeneratorService.h"
#import "FMDatabase.h"
#import "KO2SqliteMasterStore.h"

@interface KO2GeneratorServiceTests : XCTestCase

@end

@implementation KO2GeneratorServiceTests

- (void)setUp
{
    [super setUp];
}

- (void)tearDown
{
    [super tearDown];
}

- (void)testGenerate
{
    KO2GeneratorService* target = [KO2GeneratorService new];
    
    KO2Generator* entity = [KO2Generator new];
    entity.sqlFilePath = @"/sqlFilePath";
    
    id dirMock = [OCMockObject mockForClass:[KO2Directory class]];
    [[[dirMock stub] andReturn:dirMock] new];
    [[[dirMock stub] andReturnValue:@YES] createModelDirectory:entity];
    [[[dirMock stub] andReturnValue:@YES] createStoreDirectory:entity];
    [[[dirMock stub] andReturnValue:@YES] createFMDBCoreDirectory:entity];

//    id dbMock = [OCMockObject niceMockForClass:[FMDatabase class]];
//    [[[dbMock stub] andReturn:dbMock] databaseWithPath:entity.sqlFilePath];
    
    Method openMethod = class_getInstanceMethod([FMDatabase class], @selector(open));
    Method mockMethod = class_getInstanceMethod([KO2GeneratorServiceTests class], @selector(openMock));
    method_exchangeImplementations(openMethod, mockMethod);
    
    id storeMock = [OCMockObject mockForClass:[KO2SqliteMasterStore class]];
    [[[storeMock stub] andReturn:storeMock] storeWithDatabase:[OCMArg any]];
    NSArray* tableNames = [NSArray array];
    [[[storeMock stub] andReturn:tableNames] findTableNames];

    NSArray* tables = [NSArray array];
    [[[storeMock stub] andReturn:tables] findTables:tableNames];
    
    [target generate:entity];
    
}

#pragma mark - Mock Method

- (BOOL)openMock {
    return YES;
}


@end
