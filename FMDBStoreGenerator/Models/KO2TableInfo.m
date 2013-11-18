//
//  FMDBStoreGenerator
//
//  Copyright (c) 2012 Kouji Ishii
//
//  This software is released under the MIT License.
//
//  http://opensource.org/licenses/mit-license.php
//

#import "KO2TableInfo.h"

@implementation KO2TableInfo{
    @private NSMutableArray* array_;
}

# pragma mark - life cycle

+ (id) tableInfoWithTableName:(NSString*) tableName{
    return [[self alloc ]initWithTableName:tableName];
}

- (id) initWithTableName:(NSString*) tableName{
    self = [super init];
    if (self) {
        _tableName = tableName;
    }
    return self;
}

- (id) init
{
    [self doesNotRecognizeSelector:_cmd];
    return nil;
}

- (void)dealloc
{
    if (array_ != nil) {
        [array_ removeAllObjects];
        array_ = nil;
    }
}

# pragma mark - Accessor method

- (NSString*) entityClassName
{
    NSMutableString* str = [NSMutableString stringWithString:self.tableName];

    if([str hasPrefix:@"m_"] || [str hasPrefix:@"M_"]){
        [str deleteCharactersInRange:NSMakeRange(0,2)];
        [str appendString:@"_master"];
    }else if([str hasPrefix:@"t_"] || [str hasPrefix:@"T_"]){
        [str deleteCharactersInRange:NSMakeRange(0,2)];
    }
    return [[str capitalizedString] stringByReplacingOccurrencesOfString:@"_" withString:@""];
}

- (NSArray*) primaryKeyInfo
{
    NSMutableArray* array = [NSMutableArray array];
    for (KO2ColumnInfo* column in array_) {
        if (column.isPk) {
            [array addObject:column];
        }
    }
    return array;
}

- (NSArray*) notPrimaryKeyInfo
{
    NSMutableArray* array = [NSMutableArray array];
    for (KO2ColumnInfo* column in array_) {
        if (!column.isPk) {
            [array addObject:column];
        }
    }
    return array;
}


# pragma mark - Public method

- (void) addColumnInfo:(KO2ColumnInfo*) info
{
    if (array_ == nil) {
        array_ = [NSMutableArray array];
    }
    [array_ addObject:info];
    self.columnInfos = array_;
}


@end
