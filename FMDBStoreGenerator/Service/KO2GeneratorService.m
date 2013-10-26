//
//  FMDBStoreGenerator
//
//  Copyright (c) 2012 Kouji Ishii
//
//  This software is released under the MIT License.
//
//  http://opensource.org/licenses/mit-license.php
//

#import "KO2GeneratorService.h"
#import "KO2GeneratorStore.h"
#import "KO2SqliteMasterStore.h"
#import "KO2TableInfo.h"
#import "KO2ColumnInfo.h"

@implementation KO2GeneratorService


#pragma mark - Public Method

- (void) generate:(KO2Generator*) entity{

    NSString* modelDirPath = [entity.outputFilePath stringByAppendingString:@"/Models"];
    NSString* storeClassSuffix = entity.storeClassSuffix;
    NSString* plural = @"s";
    if ([entity.storeClassSuffix hasSuffix:@"y"]) {
        storeClassSuffix = [storeClassSuffix substringToIndex:storeClassSuffix.length-1];
        plural = @"ies";
    }
    NSString* storeDirPath = [NSString stringWithFormat:@"%@/%@%@",entity.outputFilePath,storeClassSuffix,plural];
    NSString* fmdbDirPath = [entity.outputFilePath stringByAppendingString:@"/fmdb"];
    
    if(![self createDirectory:modelDirPath]){
        return;
    }
    if(![self createDirectory:storeDirPath]){
        return;
    }
    if(![self createDirectory:fmdbDirPath]){
        return;
    }
    
    FMDatabase *db = [FMDatabase databaseWithPath:entity.sqlFilePath];
    
    if (![db open]) {
        NSLog(@"Could not open db.");
        return;
    }
    
    KO2SqliteMasterStore* sqliteStore = [KO2SqliteMasterStore storeWithDatabase:db];
    NSArray* tableNames = [sqliteStore findTableNames];
    NSArray* tables = [sqliteStore findTables:tableNames];
    [sqliteStore close];
    
    KO2Generator* templateStoreH = [KO2Generator generatorWith:entity andTemplateFileName:@"TemplateStore.h" andOutputFilePath:storeDirPath];
    KO2Generator* templateStoreM = [KO2Generator generatorWith:entity andTemplateFileName:@"TemplateStore.m" andOutputFilePath:storeDirPath];
    KO2Generator* templateEntityH = [KO2Generator generatorWith:entity andTemplateFileName:@"TemplateEntity.h" andOutputFilePath:modelDirPath];
    KO2Generator* templateEntityM = [KO2Generator generatorWith:entity andTemplateFileName:@"TemplateEntity.m" andOutputFilePath:modelDirPath];
    
    for (KO2TableInfo* table in tables) {
        
        [templateStoreH generateWithTable:table];
        [templateStoreM generateWithTable:table];
        [templateEntityH generateWithTable:table];
        [templateEntityM generateWithTable:table];
        
        [self store:entity];
    }
    
    KO2Generator* templateManagerH = [KO2Generator generatorWith:entity andTemplateFileName:@"TemplateDatabaseManager.h" andOutputFilePath:fmdbDirPath];
    KO2Generator* templateManagerM = [KO2Generator generatorWith:entity andTemplateFileName:@"TemplateDatabaseManager.m" andOutputFilePath:fmdbDirPath];
    KO2Generator* templateFmdbBaseH = [KO2Generator generatorWith:entity andTemplateFileName:@"TemplateStoreFmdbBase.h" andOutputFilePath:fmdbDirPath];
    KO2Generator* templateFmdbBaseM = [KO2Generator generatorWith:entity andTemplateFileName:@"TemplateStoreFmdbBase.m" andOutputFilePath:fmdbDirPath];
    KO2Generator* templatetransactionH = [KO2Generator generatorWith:entity andTemplateFileName:@"TemplateTransactionService.h" andOutputFilePath:fmdbDirPath];
    KO2Generator* templatetransactionM = [KO2Generator generatorWith:entity andTemplateFileName:@"TemplateTransactionService.m" andOutputFilePath:fmdbDirPath];
    
    [templateManagerH generateCoreClass:@"DatabaseManager.h"];
    [templateManagerM generateCoreClass:@"DatabaseManager.m"];
    [templateFmdbBaseH generateCoreClass:[NSString stringWithFormat:@"%@FmdbBase.h",entity.storeClassSuffix]];
    [templateFmdbBaseM generateCoreClass:[NSString stringWithFormat:@"%@FmdbBase.m",entity.storeClassSuffix]];
    [templatetransactionH generateCoreClass:@"TransactionService.h"];
    [templatetransactionM generateCoreClass:@"TransactionService.m"];
    
    
}

- (KO2Generator*) find{
    
    KO2GeneratorStore* store = [KO2GeneratorStore new];
    KO2Generator* config = [store find];
    if (config == nil) {
        config = [KO2Generator new];
        config.outputFilePath =  [NSHomeDirectory() stringByAppendingString:@"/Desktop"];
    }
    return config;
}

#pragma mark - Private Method

- (BOOL) store:(KO2Generator*) entity{
    KO2GeneratorStore* store = [KO2GeneratorStore new];
    return [store store:entity];
}

- (BOOL) createDirectory:(NSString*) dirPath {
    NSError* error;
    if(![[NSFileManager defaultManager] createDirectoryAtURL:[NSURL fileURLWithPath:dirPath] withIntermediateDirectories:YES attributes:nil error:&error]){
        NSLog(@"error occured when has created directory: %@: %@", dirPath, error.localizedDescription);
        return NO;
    }
    return YES;
}
@end
