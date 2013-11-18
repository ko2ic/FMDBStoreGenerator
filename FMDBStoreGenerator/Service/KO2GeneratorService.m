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
#import "KO2Directory.h"

@implementation KO2GeneratorService


#pragma mark - Public Method

- (void) generate:(KO2Generator*) entity{

    KO2Directory* modelDir = [KO2Directory new];
    if (![modelDir createModelDirectory:entity]) {
        return;
    };
    
    KO2Directory* storeDir = [KO2Directory new];
    if (![storeDir createStoreDirectory:entity]) {
        return;
    };

    KO2Directory* fmdbCoreDir = [KO2Directory new];
    if (![fmdbCoreDir createFMDBCoreDirectory:entity]) {
        return;
    };
    
    FMDatabase *db = [FMDatabase databaseWithPath:entity.sqlFilePath];
    
    if (![db open]) {
        NSLog(@"Could not open db.");
        return;
    }
    
    KO2SqliteMasterStore* sqliteStore = [KO2SqliteMasterStore storeWithDatabase:db];
    NSArray* tableNames = [sqliteStore findTableNames];
    NSArray* tables = [sqliteStore findTables:tableNames];
    [sqliteStore close];
    
    KO2Generator* templateStoreH = [KO2Generator generatorWith:entity andTemplateFileName:@"TemplateStore.h" andOutputDirectory:storeDir];
    KO2Generator* templateStoreM = [KO2Generator generatorWith:entity andTemplateFileName:@"TemplateStore.m" andOutputDirectory:storeDir];
    KO2Generator* templateEntityH = [KO2Generator generatorWith:entity andTemplateFileName:@"TemplateEntity.h" andOutputDirectory:modelDir];
    KO2Generator* templateEntityM = [KO2Generator generatorWith:entity andTemplateFileName:@"TemplateEntity.m" andOutputDirectory:modelDir];
    
    for (KO2TableInfo* table in tables) {
        
        [templateStoreH generateWithTable:table];
        [templateStoreM generateWithTable:table];
        [templateEntityH generateWithTable:table];
        [templateEntityM generateWithTable:table];
        
        [self store:entity];
    }
    
    KO2Generator* templateManagerH = [KO2Generator generatorWith:entity andTemplateFileName:@"TemplateDatabaseManager.h" andOutputDirectory:fmdbCoreDir];
    KO2Generator* templateManagerM = [KO2Generator generatorWith:entity andTemplateFileName:@"TemplateDatabaseManager.m" andOutputDirectory:fmdbCoreDir];
    KO2Generator* templateFmdbBaseH = [KO2Generator generatorWith:entity andTemplateFileName:@"TemplateStoreFmdbBase.h" andOutputDirectory:fmdbCoreDir];
    KO2Generator* templateFmdbBaseM = [KO2Generator generatorWith:entity andTemplateFileName:@"TemplateStoreFmdbBase.m" andOutputDirectory:fmdbCoreDir];
    KO2Generator* templatetransactionH = [KO2Generator generatorWith:entity andTemplateFileName:@"TemplateTransactionService.h" andOutputDirectory:fmdbCoreDir];
    KO2Generator* templatetransactionM = [KO2Generator generatorWith:entity andTemplateFileName:@"TemplateTransactionService.m" andOutputDirectory:fmdbCoreDir];
    
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
        config.outputDirectory = [KO2Directory directoryWithOutputPath:[NSHomeDirectory() stringByAppendingString:@"/Desktop"]];
    }
    return config;
}

#pragma mark - Private Method

- (BOOL) store:(KO2Generator*) entity{
    KO2GeneratorStore* store = [KO2GeneratorStore new];
    return [store store:entity];
}

@end
