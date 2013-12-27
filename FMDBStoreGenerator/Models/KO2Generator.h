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
#import "KO2Directory.h"

@interface KO2Generator : NSObject

@property(nonatomic,strong) NSString* sqlFilePath;
@property(nonatomic,strong) KO2Directory* outputDirectory;
@property(nonatomic,strong) NSString* classPrefix;
@property(nonatomic,strong) NSString* storeClassSuffix;
@property(nonatomic,strong) NSString* entityClassSuffix;
@property(nonatomic) BOOL overwriteCoreClass;
@property(nonatomic) BOOL overwriteStoreAndEntityClass;

- (NSString*) sqlFileName;

/**
 * convenience method, for generating with table.
 */
+ (id)generatorWith:(KO2Generator*) entity andTemplateFileName:(NSString*) filename andOutputDirectory:(KO2Directory*) outputDirectory;

/**
 * generates objective-c program file.
 * they are *.h and *.m of entity or store.
 */
- (void) generateWithTable:(KO2TableInfo*) table;

/**
 * generates objective-c program file.
 * they are core class for fmdb.
 */
- (void) generateCoreClass:(NSString*) className;

@end
