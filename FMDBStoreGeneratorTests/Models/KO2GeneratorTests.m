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

#import "KO2Generator.h"
#import "KO2Directory.h"

@interface KO2GeneratorTests : XCTestCase{
    NSString* tempPath;
    id directoryMock;
    id bundleMock;
}

@end



@implementation KO2GeneratorTests

- (void)setUp
{
    [super setUp];
    NSString* recourcePath = [[NSBundle mainBundle] resourcePath];
    NSBundle* resourceBundle = [NSBundle bundleWithPath:recourcePath];
    
    tempPath = [NSTemporaryDirectory() stringByAppendingString:@"/FMDBStoreGeneratorTests"];
    
    [[NSFileManager defaultManager] createDirectoryAtPath:tempPath
                              withIntermediateDirectories:YES attributes:nil error:nil];
    
    directoryMock = [OCMockObject mockForClass:[KO2Directory class]];
    [[[directoryMock stub] andReturn:tempPath] string];
    
    bundleMock = [OCMockObject mockForClass:[NSBundle class]];
    [[[bundleMock stub] andReturn:resourceBundle] mainBundle];
    
}

- (void)tearDown
{
//    [[NSFileManager defaultManager] removeItemAtPath:tempPath error:nil];
    [directoryMock stopMocking];
    [bundleMock stopMocking];
    [super tearDown];
}

- (void)testGenerateTemplateDatabaseManagerH
{
    KO2Generator* entity = [[KO2Generator alloc]init];
    entity.sqlFilePath = @"sqlFilePath";
    entity.classPrefix = @"PRE";
    entity.storeClassSuffix = @"repository";
    entity.entityClassSuffix = @"entity";
    
    KO2Generator* target = [KO2Generator generatorWith:entity andTemplateFileName:@"TemplateDatabaseManager.h" andOutputDirectory:directoryMock];
    
    // test target
    [target generateCoreClass:@"DatabaseManager.h"];
    
    [self assertEqualFile:@"Expected_DatabaseManager.h" actualFile:@"PREDatabaseManager.h"];
}

- (void)testGenerateTemplateDatabaseManagerM
{
    KO2Generator* entity = [[KO2Generator alloc]init];
    entity.sqlFilePath = @"sqlFilePath";
    entity.classPrefix = @"PRE";
    entity.storeClassSuffix = @"repository";
    entity.entityClassSuffix = @"entity";
    
    KO2Generator* target = [KO2Generator generatorWith:entity andTemplateFileName:@"TemplateDatabaseManager.m" andOutputDirectory:directoryMock];
    
    // test target
    [target generateCoreClass:@"DatabaseManager.m"];

    [self assertEqualFile:@"Expected_DatabaseManager.m" actualFile:@"PREDatabaseManager.m"];
}

- (void)testGenerateTemplateStoreFmdbBaseH
{
    KO2Generator* entity = [[KO2Generator alloc]init];
    entity.sqlFilePath = @"sqlFilePath";
    entity.classPrefix = @"PRE";
    entity.storeClassSuffix = @"repository";
    entity.entityClassSuffix = @"entity";
    
    KO2Generator* target = [KO2Generator generatorWith:entity andTemplateFileName:@"TemplateStoreFmdbBase.h" andOutputDirectory:directoryMock];
    
    // test target
    [target generateCoreClass:@"RepositoryFmdbBase.h"];
    [directoryMock stopMocking];
    [bundleMock stopMocking];

    [self assertEqualFile:@"Expected_StoreFmdbBase.h" actualFile:@"PRERepositoryFmdbBase.h"];
}

- (void)testGenerateTemplateStoreFmdbBaseM
{
    KO2Generator* entity = [[KO2Generator alloc]init];
    entity.sqlFilePath = @"sqlFilePath";
    entity.classPrefix = @"PRE";
    entity.storeClassSuffix = @"repository";
    entity.entityClassSuffix = @"entity";

    KO2Generator* target = [KO2Generator generatorWith:entity andTemplateFileName:@"TemplateStoreFmdbBase.m" andOutputDirectory:directoryMock];
    
    // test target
    [target generateCoreClass:@"RepositoryFmdbBase.m"];
    [directoryMock stopMocking];
    [bundleMock stopMocking];

    [self assertEqualFile:@"Expected_StoreFmdbBase.m" actualFile:@"PRERepositoryFmdbBase.m"];
}

- (void)testGenerateTemplateTransactionServiceH
{
    KO2Generator* entity = [[KO2Generator alloc]init];
    entity.sqlFilePath = @"sqlFilePath";
    entity.classPrefix = @"PRE";
    entity.storeClassSuffix = @"repository";
    entity.entityClassSuffix = @"entity";
    
    KO2Generator* target = [KO2Generator generatorWith:entity andTemplateFileName:@"TemplateTransactionService.h" andOutputDirectory:directoryMock];
    
    // test target
    [target generateCoreClass:@"TransactionService.h"];

    [self assertEqualFile:@"Expected_TransactionService.h" actualFile:@"PRETransactionService.h"];
    
}

- (void)testGenerateTemplateTransactionServiceM
{
    KO2Generator* entity = [[KO2Generator alloc]init];
    entity.sqlFilePath = @"sqlFilePath";
    entity.classPrefix = @"PRE";
    entity.storeClassSuffix = @"repository";
    entity.entityClassSuffix = @"entity";
    
    KO2Generator* target = [KO2Generator generatorWith:entity andTemplateFileName:@"TemplateTransactionService.m" andOutputDirectory:directoryMock];
    
    // test target
    [target generateCoreClass:@"TransactionService.m"];
    
    [self assertEqualFile:@"Expected_TransactionService.m" actualFile:@"PRETransactionService.m"];
}

- (void)testGenerateStoreH_MasterTable
{
    KO2Generator* entity = [[KO2Generator alloc]init];
    entity.sqlFilePath = @"sqlFilePath";
    entity.classPrefix = @"AAA";
    entity.storeClassSuffix = @"repository";
    entity.entityClassSuffix = @"entity";
    KO2TableInfo* table = [KO2TableInfo tableInfoWithTableName:@"m_table_name"];

    KO2ColumnInfo* column1 = [[KO2ColumnInfo alloc] initWithEntityName:table.entityClassName];    
    [table addColumnInfo:column1];
    
    KO2Generator* target = [KO2Generator generatorWith:entity andTemplateFileName:@"TemplateStore.h" andOutputDirectory:directoryMock];
    
    // test target
    [target generateWithTable:table];
   
    [self assertEqualFile:@"Expected_Store.h_Master" actualFile:@"AAATableNameMasterRepository.h"];
    
}

- (void)testGenerateStoreH_TransactionTable
{
    KO2Generator* entity = [[KO2Generator alloc]init];
    entity.sqlFilePath = @"sqlFilePath";
    entity.classPrefix = @"AAA";
    entity.storeClassSuffix = @"repository";
    entity.entityClassSuffix = @"entity";
    KO2TableInfo* table = [KO2TableInfo tableInfoWithTableName:@"t_table_name"];
    
    KO2ColumnInfo* column1 = [[KO2ColumnInfo alloc] initWithEntityName:table.entityClassName];
    [table addColumnInfo:column1];
    
    KO2Generator* target = [KO2Generator generatorWith:entity andTemplateFileName:@"TemplateStore.h" andOutputDirectory:directoryMock];
    
    // test target
    [target generateWithTable:table];
    
    [self assertEqualFile:@"Expected_Store.h_Transaction" actualFile:@"AAATableNameRepository.h"];
    
}

- (void)testGenerate_Integer
{
    KO2Generator* entity = [[KO2Generator alloc]init];
    entity.sqlFilePath = @"sqlFilePath";
    entity.classPrefix = @"INT";
    entity.storeClassSuffix = @"repository";
    entity.entityClassSuffix = @"entity";
    KO2TableInfo* table = [KO2TableInfo tableInfoWithTableName:@"table_name"];
    
    KO2ColumnInfo* column1 = [[KO2ColumnInfo alloc] initWithEntityName:table.entityClassName];
    column1.columnName = @"id";
    column1.isPk = YES;
    column1.type = @"integer";
    [table addColumnInfo:column1];
    
    KO2ColumnInfo* column2 = [[KO2ColumnInfo alloc] initWithEntityName:table.entityClassName];
    column2.columnName = @"id2";
    column2.isPk = YES;
    column2.type = @"integer";
    [table addColumnInfo:column2];

    KO2ColumnInfo* column3 = [[KO2ColumnInfo alloc] initWithEntityName:table.entityClassName];
    column3.columnName = @"id3";
    column3.isPk = NO;
    column3.type = @"integer";
    [table addColumnInfo:column3];
    
    KO2Generator* target = [KO2Generator generatorWith:entity andTemplateFileName:@"TemplateStore.h" andOutputDirectory:directoryMock];
    // test target
    [target generateWithTable:table];
    [self assertEqualFile:@"Expected_Store.h_Integer" actualFile:@"INTTableNameRepository.h"];

    target = [KO2Generator generatorWith:entity andTemplateFileName:@"TemplateStore.m" andOutputDirectory:directoryMock];
    // test target
    [target generateWithTable:table];
    [self assertEqualFile:@"Expected_Store.m_Integer" actualFile:@"INTTableNameRepository.m"];
    
    target = [KO2Generator generatorWith:entity andTemplateFileName:@"TemplateEntity.h" andOutputDirectory:directoryMock];
    // test target
    [target generateWithTable:table];
    [self assertEqualFile:@"Expected_Entity.h_Integer" actualFile:@"INTTableNameEntity.h"];
    
    target = [KO2Generator generatorWith:entity andTemplateFileName:@"TemplateEntity.m" andOutputDirectory:directoryMock];
    // test target
    [target generateWithTable:table];
    [self assertEqualFile:@"Expected_Entity.m_Integer" actualFile:@"INTTableNameEntity.m"];
    
}

- (void)testGenerate_Varchar
{
    KO2Generator* entity = [[KO2Generator alloc]init];
    entity.sqlFilePath = @"sqlFilePath";
    entity.classPrefix = @"VAR";
    entity.storeClassSuffix = @"repository";
    entity.entityClassSuffix = @"entity";
    KO2TableInfo* table = [KO2TableInfo tableInfoWithTableName:@"table_name"];
    
    KO2ColumnInfo* column1 = [[KO2ColumnInfo alloc] initWithEntityName:table.entityClassName];
    column1.columnName = @"text1";
    column1.isPk = YES;
    column1.type = @"text";
    [table addColumnInfo:column1];
    
    KO2ColumnInfo* column2 = [[KO2ColumnInfo alloc] initWithEntityName:table.entityClassName];
    column2.columnName = @"text2";
    column2.isPk = YES;
    column2.type = @"varchar";
    [table addColumnInfo:column2];
    
    KO2ColumnInfo* column3 = [[KO2ColumnInfo alloc] initWithEntityName:table.entityClassName];
    column3.columnName = @"text3";
    column3.isPk = NO;
    column3.isNotNull = YES;
    column3.type = @"text";
    [table addColumnInfo:column3];

    KO2ColumnInfo* column4 = [[KO2ColumnInfo alloc] initWithEntityName:table.entityClassName];
    column4.columnName = @"text4";
    column4.isPk = NO;
    column4.isNotNull = NO;
    column4.type = @"text";
    [table addColumnInfo:column4];

    KO2ColumnInfo* column5 = [[KO2ColumnInfo alloc] initWithEntityName:table.entityClassName];
    column5.columnName = @"text5";
    column5.isPk = NO;
    column5.isNotNull = YES;
    column5.type = @"varchar";
    [table addColumnInfo:column5];
    
    KO2ColumnInfo* column6 = [[KO2ColumnInfo alloc] initWithEntityName:table.entityClassName];
    column6.columnName = @"text6";
    column6.isPk = NO;
    column6.isNotNull = NO;
    column6.type = @"varchar";
    [table addColumnInfo:column6];

    KO2Generator* target = [KO2Generator generatorWith:entity andTemplateFileName:@"TemplateStore.h" andOutputDirectory:directoryMock];
    // test target
    [target generateWithTable:table];
    [self assertEqualFile:@"Expected_Store.h_Varchar" actualFile:@"VARTableNameRepository.h"];
    
    target = [KO2Generator generatorWith:entity andTemplateFileName:@"TemplateStore.m" andOutputDirectory:directoryMock];
    // test target
    [target generateWithTable:table];
    [self assertEqualFile:@"Expected_Store.m_Varchar" actualFile:@"VARTableNameRepository.m"];
    
    target = [KO2Generator generatorWith:entity andTemplateFileName:@"TemplateEntity.h" andOutputDirectory:directoryMock];
    // test target
    [target generateWithTable:table];
    [self assertEqualFile:@"Expected_Entity.h_Varchar" actualFile:@"VARTableNameEntity.h"];
    
    target = [KO2Generator generatorWith:entity andTemplateFileName:@"TemplateEntity.m" andOutputDirectory:directoryMock];
    // test target
    [target generateWithTable:table];
    [self assertEqualFile:@"Expected_Entity.m_Varchar" actualFile:@"VARTableNameEntity.m"];
}

- (void)testGenerateStoreM_Datetime
{
    KO2Generator* entity = [[KO2Generator alloc]init];
    entity.sqlFilePath = @"sqlFilePath";
    entity.classPrefix = @"DAT";
    entity.storeClassSuffix = @"repository";
    entity.entityClassSuffix = @"entity";
    KO2TableInfo* table = [KO2TableInfo tableInfoWithTableName:@"table_name"];
    
    KO2ColumnInfo* column1 = [[KO2ColumnInfo alloc] initWithEntityName:table.entityClassName];
    column1.columnName = @"a_datetime";
    column1.isPk = YES;
    column1.type = @"text";
    [table addColumnInfo:column1];
    
    KO2ColumnInfo* column2 = [[KO2ColumnInfo alloc] initWithEntityName:table.entityClassName];
    column2.columnName = @"b_datetime";
    column2.isPk = YES;
    column2.type = @"varchar";
    [table addColumnInfo:column2];
    
    KO2ColumnInfo* column3 = [[KO2ColumnInfo alloc] initWithEntityName:table.entityClassName];
    column3.columnName = @"c_DateTime";
    column3.isPk = NO;
    column3.isNotNull = YES;
    column3.type = @"text";
    [table addColumnInfo:column3];
    
    KO2ColumnInfo* column4 = [[KO2ColumnInfo alloc] initWithEntityName:table.entityClassName];
    column4.columnName = @"d_dateTime";
    column4.isPk = NO;
    column4.isNotNull = NO;
    column4.type = @"text";
    [table addColumnInfo:column4];
    
    KO2ColumnInfo* column5 = [[KO2ColumnInfo alloc] initWithEntityName:table.entityClassName];
    column5.columnName = @"e_Datetime";
    column5.isPk = NO;
    column5.isNotNull = YES;
    column5.type = @"varchar";
    [table addColumnInfo:column5];
    
    KO2ColumnInfo* column6 = [[KO2ColumnInfo alloc] initWithEntityName:table.entityClassName];
    column6.columnName = @"f_DateTime";
    column6.isPk = NO;
    column6.isNotNull = NO;
    column6.type = @"varchar";
    [table addColumnInfo:column6];
  
    KO2Generator* target = [KO2Generator generatorWith:entity andTemplateFileName:@"TemplateStore.h" andOutputDirectory:directoryMock];
    // test target
    [target generateWithTable:table];
    [self assertEqualFile:@"Expected_Store.h_Datetime" actualFile:@"DATTableNameRepository.h"];
    
    target = [KO2Generator generatorWith:entity andTemplateFileName:@"TemplateStore.m" andOutputDirectory:directoryMock];
    // test target
    [target generateWithTable:table];
    [self assertEqualFile:@"Expected_Store.m_Datetime" actualFile:@"DATTableNameRepository.m"];
    
    target = [KO2Generator generatorWith:entity andTemplateFileName:@"TemplateEntity.h" andOutputDirectory:directoryMock];
    // test target
    [target generateWithTable:table];
    [self assertEqualFile:@"Expected_Entity.h_Datetime" actualFile:@"DATTableNameEntity.h"];
    
    target = [KO2Generator generatorWith:entity andTemplateFileName:@"TemplateEntity.m" andOutputDirectory:directoryMock];
    // test target
    [target generateWithTable:table];
    [self assertEqualFile:@"Expected_Entity.m_Datetime" actualFile:@"DATTableNameEntity.m"];
    
}

- (void)testGenerateStoreM_Flag
{
    KO2Generator* entity = [[KO2Generator alloc]init];
    entity.sqlFilePath = @"sqlFilePath";
    entity.classPrefix = @"FLG";
    entity.storeClassSuffix = @"repository";
    entity.entityClassSuffix = @"entity";
    KO2TableInfo* table = [KO2TableInfo tableInfoWithTableName:@"table_name"];
    
    KO2ColumnInfo* column1 = [[KO2ColumnInfo alloc] initWithEntityName:table.entityClassName];
    column1.columnName = @"a_flag";
    column1.isPk = YES;
    column1.type = @"text";
    [table addColumnInfo:column1];
    
    KO2ColumnInfo* column2 = [[KO2ColumnInfo alloc] initWithEntityName:table.entityClassName];
    column2.columnName = @"b_Flag";
    column2.isPk = YES;
    column2.type = @"varchar";
    [table addColumnInfo:column2];
    
    KO2ColumnInfo* column3 = [[KO2ColumnInfo alloc] initWithEntityName:table.entityClassName];
    column3.columnName = @"c_FLAG";
    column3.isPk = NO;
    column3.isNotNull = YES;
    column3.type = @"text";
    [table addColumnInfo:column3];
    
    KO2ColumnInfo* column4 = [[KO2ColumnInfo alloc] initWithEntityName:table.entityClassName];
    column4.columnName = @"d_flag";
    column4.isPk = NO;
    column4.isNotNull = NO;
    column4.type = @"integer";
    [table addColumnInfo:column4];
    
    KO2ColumnInfo* column5 = [[KO2ColumnInfo alloc] initWithEntityName:table.entityClassName];
    column5.columnName = @"e_flag";
    column5.isPk = NO;
    column5.isNotNull = YES;
    column5.type = @"varchar";
    [table addColumnInfo:column5];
    
    KO2ColumnInfo* column6 = [[KO2ColumnInfo alloc] initWithEntityName:table.entityClassName];
    column6.columnName = @"f_flag";
    column6.isPk = NO;
    column6.isNotNull = NO;
    column6.type = @"varchar";
    [table addColumnInfo:column6];

    KO2Generator* target = [KO2Generator generatorWith:entity andTemplateFileName:@"TemplateStore.h" andOutputDirectory:directoryMock];
    // test target
    [target generateWithTable:table];
    [self assertEqualFile:@"Expected_Store.h_Flag" actualFile:@"FLGTableNameRepository.h"];
    
    target = [KO2Generator generatorWith:entity andTemplateFileName:@"TemplateStore.m" andOutputDirectory:directoryMock];
    // test target
    [target generateWithTable:table];
    [self assertEqualFile:@"Expected_Store.m_Flag" actualFile:@"FLGTableNameRepository.m"];
    
    target = [KO2Generator generatorWith:entity andTemplateFileName:@"TemplateEntity.h" andOutputDirectory:directoryMock];
    // test target
    [target generateWithTable:table];
    [self assertEqualFile:@"Expected_Entity.h_Flag" actualFile:@"FLGTableNameEntity.h"];
    
    target = [KO2Generator generatorWith:entity andTemplateFileName:@"TemplateEntity.m" andOutputDirectory:directoryMock];
    // test target
    [target generateWithTable:table];
    [self assertEqualFile:@"Expected_Entity.m_Flag" actualFile:@"FLGTableNameEntity.m"];
    
}

- (void)testGenerateStoreM_Real
{
    KO2Generator* entity = [[KO2Generator alloc]init];
    entity.sqlFilePath = @"sqlFilePath";
    entity.classPrefix = @"REA";
    entity.storeClassSuffix = @"repository";
    entity.entityClassSuffix = @"entity";
    KO2TableInfo* table = [KO2TableInfo tableInfoWithTableName:@"table_name"];
    
    KO2ColumnInfo* column1 = [[KO2ColumnInfo alloc] initWithEntityName:table.entityClassName];
    column1.columnName = @"id";
    column1.isPk = YES;
    column1.type = @"real";
    [table addColumnInfo:column1];
    
    KO2ColumnInfo* column2 = [[KO2ColumnInfo alloc] initWithEntityName:table.entityClassName];
    column2.columnName = @"real2";
    column2.isPk = NO;
    column2.isNotNull = NO;
    column2.type = @"real";
    [table addColumnInfo:column2];
    
    KO2ColumnInfo* column3 = [[KO2ColumnInfo alloc] initWithEntityName:table.entityClassName];
    column3.columnName = @"real3";
    column3.isPk = NO;
    column3.isNotNull = NO;
    column3.type = @"real";
    [table addColumnInfo:column3];
    
    KO2Generator* target = [KO2Generator generatorWith:entity andTemplateFileName:@"TemplateStore.h" andOutputDirectory:directoryMock];
    // test target
    [target generateWithTable:table];
    [self assertEqualFile:@"Expected_Store.h_Real" actualFile:@"REATableNameRepository.h"];

    target = [KO2Generator generatorWith:entity andTemplateFileName:@"TemplateStore.m" andOutputDirectory:directoryMock];
    // test target
    [target generateWithTable:table];
    [self assertEqualFile:@"Expected_Store.m_Real" actualFile:@"REATableNameRepository.m"];
    
    target = [KO2Generator generatorWith:entity andTemplateFileName:@"TemplateEntity.h" andOutputDirectory:directoryMock];
    // test target
    [target generateWithTable:table];
    [self assertEqualFile:@"Expected_Entity.h_Real" actualFile:@"REATableNameEntity.h"];
    
    target = [KO2Generator generatorWith:entity andTemplateFileName:@"TemplateEntity.m" andOutputDirectory:directoryMock];
    // test target
    [target generateWithTable:table];
    [self assertEqualFile:@"Expected_Entity.m_Real" actualFile:@"REATableNameEntity.m"];
    
}

#pragma mark - Private Method

- (void) assertEqualFile:(NSString*)expectedFile actualFile:(NSString*)actualFile {
    NSError *error = nil;
    NSString *filePath = [[NSBundle bundleForClass:[self class]]pathForResource:expectedFile ofType:@"txt"];
    NSString *expected = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:&error];
    XCTAssertNotNil(expected);
    
    NSString* actualPath = [NSString stringWithFormat:@"%@/%@",tempPath, actualFile];
    
    NSFileHandle *fileHandle = [NSFileHandle fileHandleForReadingAtPath:actualPath];
    if (!fileHandle) {
        XCTFail(@"File not found. %@", actualPath);
    }
    
    NSData *data = [fileHandle readDataToEndOfFile];
    NSString *actual = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    XCTAssertEqualObjects(expected, actual);
}

@end
