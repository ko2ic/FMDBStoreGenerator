//
//  FMDBStoreGenerator
//
//  Copyright (c) 2012 Kouji Ishii
//
//  This software is released under the MIT License.
//
//  http://opensource.org/licenses/mit-license.php
//

#import "KO2SqliteMasterStore.h"
#import "KO2TableInfo.h"

#import "FMDatabase.h"

@implementation KO2SqliteMasterStore{
    @private FMDatabase* db_;
}


# pragma mark - life cycle

+ (id) storeWithDatabase:(FMDatabase*) db{
    return [[self alloc ]initWithDatabase:db];
}

- (id) initWithDatabase:(FMDatabase*) db{
    self = [super init];
    if (self) {
        db_ = db;
    }
    return self;
}

- (id) init
{
    [self doesNotRecognizeSelector:_cmd];
    return nil;
}

- (void) close{
    if (db_ != nil) {
        [db_ close];
        db_ = nil;
    }
}

- (void)dealloc
{
    [self close];
}

#pragma mark - Public Method

- (NSArray*) findTableNames{
    
    NSMutableArray* array = [NSMutableArray array];
    FMResultSet* tableNameRs = [db_ executeQuery:@"SELECT name FROM sqlite_master WHERE type='table';"];
    if ([db_ hadError]) {
        NSLog(@"Err %d: %@", [db_ lastErrorCode], [db_ lastErrorMessage]);
    }
    while (tableNameRs.next) {
        NSString* tableName = [tableNameRs stringForColumnIndex:0];
        if(![@"sqlite_sequence" isEqualToString:tableName]){
            [array addObject:tableName];
        }
    }
    [tableNameRs close];
    
    return array;
    
}

- (NSArray*) findTables:(NSArray*)tableNames {

    NSMutableArray* array = [NSMutableArray array];
    
    for (NSString* tableName in tableNames) {
        NSString* sql = [NSMutableString stringWithFormat:@"PRAGMA table_info(%@);",tableName ];
        FMResultSet* rs = [db_ executeQuery:sql];
        if ([db_ hadError]) {
            NSLog(@"Err %d: %@", [db_ lastErrorCode], [db_ lastErrorMessage]);
        }
        KO2TableInfo* table = [KO2TableInfo tableInfoWithTableName:tableName];
        
        while (rs.next) {
            NSString* columnName = [rs stringForColumnIndex:1];
            NSString* typeName = [rs stringForColumnIndex:2];
            BOOL isNotNull = [rs boolForColumnIndex:3];
            BOOL isPk = [rs boolForColumnIndex:5];
            
            KO2ColumnInfo* column = [[KO2ColumnInfo alloc]initWithEntityName:table.entityClassName];
            column.columnName = columnName;
            column.type = typeName;
            column.isNotNull = isNotNull;
            column.isPk = isPk;
            [table addColumnInfo:column];
        }
        [array addObject:table];
        [rs close];
    }
    return array;
}

@end
