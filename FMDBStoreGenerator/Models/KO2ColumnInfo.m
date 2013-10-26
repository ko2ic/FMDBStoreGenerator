//
//  FMDBStoreGenerator
//
//  Copyright (c) 2012 Kouji Ishii
//
//  This software is released under the MIT License.
//
//  http://opensource.org/licenses/mit-license.php
//

#import "KO2ColumnInfo.h"

@implementation KO2ColumnInfo{
    @private
    NSString* entityClassName_;
}

#pragma mark - Propeties

@synthesize columnName;
@synthesize type;
@synthesize isNotNull;
@synthesize isPk;

- (NSString*) columnNameUpperCase
{
    return [self.columnName uppercaseString];
}

- (NSString*) propertyName
{
    NSString* str = nil;
    if ([columnName isEqualToString:@"id"] || [columnName isEqualToString:@"ID"]) {
       str = [NSString stringWithFormat:@"%@Id",entityClassName_ ];
    }else{
       str = [[self.columnName capitalizedString] stringByReplacingOccurrencesOfString:@"_" withString:@""];
    }
    NSString* firstStr = [[str substringToIndex:1] lowercaseString];
    NSString* restStr = [str substringFromIndex:1];
    return [NSString stringWithFormat:@"%@%@",firstStr,restStr];
}

- (BOOL) isDate
{
    if ([self.propertyName rangeOfString:@"datetime" options:NSCaseInsensitiveSearch].location == NSNotFound) {
        return NO;
    }
    return YES;
}

- (BOOL) isBool
{
    if ([self.propertyName rangeOfString:@"flag" options:NSCaseInsensitiveSearch].location == NSNotFound) {
        return NO;
    }
    return YES;
}

- (BOOL) isReal
{
    return [self.type caseInsensitiveCompare:@"REAL"] == NSOrderedSame;
}

- (BOOL) isInteger
{
    return [self.type caseInsensitiveCompare:@"INTEGER"] == NSOrderedSame && !self.isBool;
}

- (BOOL) isVarchar
{
    return ([self.type caseInsensitiveCompare:@"VARCHAR"] == NSOrderedSame || [self.type caseInsensitiveCompare:@"TEXT"] == NSOrderedSame) && !self.isDate && !self.isBool;
}



- (BOOL) isNSNumber
{
    if (self.isReal) {
        return YES;
    }
    if (self.isInteger && !self.isNotNull && !self.isPk) {
        return YES;
    }
    return NO;
}

- (BOOL) isNSInteger
{
    if (self.isInteger && (self.isNotNull || self.isPk)) {
        return YES;
    }
    return NO;
}

#pragma mark - Life Cycle

- (id) initWithEntityName:(NSString* )entityClassName
{
    self = [super init];
    if(self){
        entityClassName_ = entityClassName;
    }
    return self;
}

- (void)dealloc
{
    entityClassName_ = nil;
}

@end
