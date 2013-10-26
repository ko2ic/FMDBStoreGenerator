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

#import "KO2TableInfo.h"

@interface KO2Generator : NSObject

@property(nonatomic,strong) NSString* sqlFilePath;
@property(nonatomic,strong) NSString* outputFilePath;
@property(nonatomic,strong) NSString* classPrefix;
@property(nonatomic,strong) NSString* storeClassSuffix;
@property(nonatomic,strong) NSString* entityClassSuffix;

- (NSString*) sqlFileName;

/**
 * convenience method, for generating with table.
 */
+ (id)generatorWith:(KO2Generator*) entity andTemplateFileName:(NSString*) filename andOutputFilePath:(NSString*) outputFilePath;

/**
 * generates objective-c program file.
 * they are *.h and *.m of entity or store.
 */
- (void) generateWithTable:(KO2TableInfo*) table;

- (void) generateCoreClass:(NSString*) className;

@end
