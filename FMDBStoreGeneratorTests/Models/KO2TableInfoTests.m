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

#import "KO2TableInfo.h"
#import "KO2ColumnInfo.h"

@interface KO2TableInfoTests : XCTestCase

@end

@implementation KO2TableInfoTests{
KO2TableInfo* target;
}

- (void)setUp
{
    [super setUp];
    target = [KO2TableInfo tableInfoWithTableName:@"table_name"];
}

- (void)tearDown
{
    [super tearDown];
}

- (void)testEntityClassName
{
    XCTAssertEqualObjects(target.entityClassName, @"TableName");

    KO2TableInfo* tName = [KO2TableInfo tableInfoWithTableName:@"t_table_name"];
    
    XCTAssertEqualObjects(tName.entityClassName, @"TableName");

    tName = [KO2TableInfo tableInfoWithTableName:@"T_TABLE_NAME"];
    
    XCTAssertEqualObjects(tName.entityClassName, @"TableName");
    
    KO2TableInfo* mName = [KO2TableInfo tableInfoWithTableName:@"m_table_name"];
    
    XCTAssertEqualObjects(mName.entityClassName, @"TableNameMaster");
    
    mName = [KO2TableInfo tableInfoWithTableName:@"M_TABLE_NAME"];
    
    XCTAssertEqualObjects(mName.entityClassName, @"TableNameMaster");
    
}

- (void) testAddColumnInfo
{
    KO2ColumnInfo* pkColumn1 = [[KO2ColumnInfo alloc]initWithEntityName:@"entityName"];
    pkColumn1.isPk = YES;
    pkColumn1.columnName = @"pk1";
    [target addColumnInfo:pkColumn1];
    KO2ColumnInfo* pkColumn2 = [[KO2ColumnInfo alloc]initWithEntityName:@"entityName"];
    pkColumn2.isPk = YES;
    pkColumn2.columnName = @"pk2";
    [target addColumnInfo:pkColumn2];

    KO2ColumnInfo* notPkColumn1 = [[KO2ColumnInfo alloc]initWithEntityName:@"entityName"];
    notPkColumn1.isPk = NO;
    notPkColumn1.columnName = @"pk1";
    [target addColumnInfo:notPkColumn1];
    KO2ColumnInfo* notPkColumn2 = [[KO2ColumnInfo alloc]initWithEntityName:@"entityName"];
    notPkColumn2.isPk = NO;
    notPkColumn2.columnName = @"pk2";
    [target addColumnInfo:notPkColumn2];
    
    XCTAssertEqual((int)target.primaryKeyInfo.count, 2);
    XCTAssertEqual([target.primaryKeyInfo objectAtIndex:0], pkColumn1);
    XCTAssertEqual([target.primaryKeyInfo objectAtIndex:1], pkColumn2);

    XCTAssertEqual((int)target.notPrimaryKeyInfo.count, 2);
    XCTAssertEqual([target.notPrimaryKeyInfo objectAtIndex:0], notPkColumn1);
    XCTAssertEqual([target.notPrimaryKeyInfo objectAtIndex:1], notPkColumn2);
    
}


@end
