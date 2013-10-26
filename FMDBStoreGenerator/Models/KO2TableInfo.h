//
//  FMDBStoreGenerator
//
//  Copyright (c) 2012 Kouji Ishii
//
//  This software is released under the MIT License.
//
//  http://opensource.org/licenses/mit-license.php
//

#import <Foundation/Foundation.h>
#import "KO2ColumnInfo.h"

@interface KO2TableInfo : NSObject

@property (nonatomic,strong,readonly) NSString* tableName;
@property (nonatomic,strong) NSArray* columnInfos;
@property (nonatomic,weak,readonly) NSArray* primaryKeyInfo;
@property (nonatomic,weak,readonly) NSArray* notPrimaryKeyInfo;
@property (nonatomic,weak,readonly) NSString* entityClassName;

+ (id) tableInfoWithTableName:(NSString*) tableName;

- (void) addColumnInfo:(KO2ColumnInfo*) info;

@end
