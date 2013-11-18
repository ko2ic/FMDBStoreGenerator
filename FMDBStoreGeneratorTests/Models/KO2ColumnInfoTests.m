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

#import "KO2ColumnInfo.h"


@interface KO2ColumnInfoTests : XCTestCase

@end

@implementation KO2ColumnInfoTests{
    KO2ColumnInfo* target;
}

- (void)setUp
{
    [super setUp];
    target = [[KO2ColumnInfo alloc] initWithEntityName:@"testEntityName"];
}

- (void)tearDown
{
    target = nil;
    [super tearDown];
}

- (void)testColumnNameUpperCase
{
    target.columnName = @"column_name";
    XCTAssertEqualObjects(target.columnNameUpperCase,@"COLUMN_NAME");
    
    // TODO: respond to columnName
}

- (void)testPropertyName
{
    target.columnName = @"column_name";
    XCTAssertEqualObjects(target.propertyName,@"columnName");
    
    target.columnName = @"id";
    XCTAssertEqualObjects(target.propertyName,@"testEntityNameId");
    
    target.columnName = @"ID";
    XCTAssertEqualObjects(target.propertyName,@"testEntityNameId");

}

- (void) testIsDate
{
    target.columnName = @"aDateTime";
    XCTAssertTrue(target.isDate);

    target.columnName = @"aDate";
    XCTAssertFalse(target.isDate);
}

- (void) testIsBool
{
    target.columnName = @"aFlag";
    XCTAssertTrue(target.isBool);
    
    target.columnName = @"aBool";
    XCTAssertFalse(target.isBool);
}

- (void) testIsReal
{
    target.type = @"real";
    XCTAssertTrue(target.isReal);

    target.type = @"REAL";
    XCTAssertTrue(target.isReal);

    target.type = @"TEXT";
    XCTAssertFalse(target.isReal);
}

- (void) testIsInteger
{
    id mock1 = [OCMockObject partialMockForObject:target];
    [[[mock1 stub] andReturnValue:@NO] isBool];
    
    target.type = @"INTEGER";
    XCTAssertTrue(target.isInteger);
    
    target.type = @"integer";
    XCTAssertTrue(target.isInteger);

    target.type = @"TEXT";
    XCTAssertFalse(target.isInteger);
    
    [mock1 stopMocking];

    id mock2 = [OCMockObject partialMockForObject:target];
    [[[mock2 stub] andReturnValue:@YES] isBool];
    
    target.type = @"integer";
    XCTAssertFalse(target.isInteger);
    
    target.type = @"INTEGER";
    XCTAssertFalse(target.isInteger);
    
    [mock2 stopMocking];
}

- (void) testIsVarchar
{
    id mock1 = [OCMockObject partialMockForObject:target];
    [[[mock1 stub] andReturnValue:@NO] isDate];
    [[[mock1 stub] andReturnValue:@NO] isBool];
    
    target.type = @"VARCHAR";
    XCTAssertTrue(target.isVarchar);

    target.type = @"varchar";
    XCTAssertTrue(target.isVarchar);
    
    target.type = @"TEXT";
    XCTAssertTrue(target.isVarchar);
    
    target.type = @"text";
    XCTAssertTrue(target.isVarchar);
    
    [mock1 stopMocking];

    id mock2 = [OCMockObject partialMockForObject:target];
    [[[mock2 stub] andReturnValue:@YES] isDate];
    [[[mock2 stub] andReturnValue:@NO] isBool];
    
    // datetime
    target.type = @"VARCHAR";
    XCTAssertFalse(target.isVarchar);

    target.type = @"varchar";
    XCTAssertFalse(target.isVarchar);
    
    target.type = @"TEXT";
    XCTAssertFalse(target.isVarchar);
    
    target.type = @"text";
    XCTAssertFalse(target.isVarchar);

    [mock2 stopMocking];
    
    id mock3 = [OCMockObject partialMockForObject:target];
    [[[mock3 stub] andReturnValue:@NO] isDate];
    [[[mock3 stub] andReturnValue:@YES] isBool];
    
    // flag
    target.columnName = @"aFlag";
    target.type = @"VARCHAR";
    XCTAssertFalse(target.isVarchar);
    
    target.type = @"varchar";
    XCTAssertFalse(target.isVarchar);
    
    target.type = @"TEXT";
    XCTAssertFalse(target.isVarchar);
    
    target.type = @"text";
    XCTAssertFalse(target.isVarchar);
}

- (void) testIsNSNumber
{
    id mock1 = [OCMockObject partialMockForObject:target];
    [[[mock1 stub] andReturnValue:@YES] isReal];
    
    XCTAssertTrue(target.isNSNumber);
    
    [mock1 stopMocking];
    
    id mock2 = [OCMockObject  partialMockForObject:target];
    [[[mock2 stub] andReturnValue:@NO] isReal];
    [[[mock2 stub] andReturnValue:@YES] isInteger];;
    [[[mock2 stub] andReturnValue:@NO] isNotNull];
    [[[mock2 stub] andReturnValue:@NO] isPk];
    
    XCTAssertTrue(target.isNSNumber);
    
    [mock2 stopMocking];
    
    id mock3 = [OCMockObject  partialMockForObject:target];
    [[[mock3 stub] andReturnValue:@NO] isReal];
    [[[mock3 stub] andReturnValue:@NO] isInteger];;
    [[[mock3 stub] andReturnValue:@NO] isNotNull];
    [[[mock3 stub] andReturnValue:@NO] isPk];
    
    XCTAssertFalse(target.isNSNumber);
    
    [mock3 stopMocking];
    
    id mock4 = [OCMockObject  partialMockForObject:target];
    [[[mock4 stub] andReturnValue:@NO] isReal];
    [[[mock4 stub] andReturnValue:@YES] isInteger];;
    [[[mock4 stub] andReturnValue:@YES] isNotNull];
    [[[mock4 stub] andReturnValue:@NO] isPk];
    
    XCTAssertFalse(target.isNSNumber);
    
    [mock4 stopMocking];
    
    id mock5 = [OCMockObject  partialMockForObject:target];
    [[[mock5 stub] andReturnValue:@NO] isReal];
    [[[mock5 stub] andReturnValue:@YES] isInteger];;
    [[[mock5 stub] andReturnValue:@NO] isNotNull];
    [[[mock5 stub] andReturnValue:@YES] isPk];
    
    XCTAssertFalse(target.isNSNumber);
    
    [mock5 stopMocking];
    
}

- (void) testIsNSInteger
{
    id mock1 = [OCMockObject partialMockForObject:target];
    [[[mock1 stub] andReturnValue:@YES] isInteger];
    [[[mock1 stub] andReturnValue:@YES] isNotNull];
    
    XCTAssertTrue(target.isNSInteger);
    [mock1 stopMocking];
    
    id mock2 = [OCMockObject partialMockForObject:target];
    [[[mock2 stub] andReturnValue:@YES] isInteger];
    [[[mock2 stub] andReturnValue:@NO] isNotNull];
    [[[mock2 stub] andReturnValue:@YES] isPk];

    XCTAssertTrue(target.isNSInteger);
    [mock2 stopMocking];
    
    id mock3 = [OCMockObject partialMockForObject:target];
    [[[mock3 stub] andReturnValue:@YES] isInteger];
    [[[mock3 stub] andReturnValue:@NO] isNotNull];
    [[[mock3 stub] andReturnValue:@NO] isPk];
    
    XCTAssertFalse(target.isNSInteger);
    [mock3 stopMocking];
    
    id mock4 = [OCMockObject partialMockForObject:target];
    [[[mock4 stub] andReturnValue:@NO] isInteger];
    
    XCTAssertFalse(target.isNSInteger);
    [mock4 stopMocking];
}

@end
