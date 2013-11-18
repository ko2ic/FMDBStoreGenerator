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

@interface KO2ColumnInfo : NSObject

@property (nonatomic ,strong) NSString* columnName;
@property (nonatomic ,weak, readonly) NSString* columnNameUpperCase;
@property (nonatomic ,strong) NSString* type;
@property (nonatomic) BOOL isNotNull;
@property (nonatomic) BOOL isPk;
@property (nonatomic ,weak ,readonly) NSString* propertyName;
@property (nonatomic ,readonly) BOOL isReal;
@property (nonatomic ,readonly) BOOL isInteger;
@property (nonatomic ,readonly) BOOL isVarchar;
@property (nonatomic ,readonly) BOOL isDate;
@property (nonatomic ,readonly) BOOL isBool;
@property (nonatomic ,readonly) BOOL isNSNumber;
@property (nonatomic ,readonly) BOOL isNSInteger;


- (id) initWithEntityName:(NSString* )entityClassName;

@end
