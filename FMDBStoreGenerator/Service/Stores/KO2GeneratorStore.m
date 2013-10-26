//
//  FMDBStoreGenerator
//
//  Copyright (c) 2012 Kouji Ishii
//
//  This software is released under the MIT License.
//
//  http://opensource.org/licenses/mit-license.php
//

#import "KO2GeneratorStore.h"

static NSString* const kSqlFilePath = @"generator.sqlFilePath";
static NSString* const kOutputDirectory = @"generator.outputDirectory";
static NSString* const kClassPrefix = @"generator.classPrefix";
static NSString* const kStoreClassSuffix = @"generator.storeClassSuffix";
static NSString* const kEntityClassSuffix = @"generator.entityClassSuffix";

@implementation KO2GeneratorStore

- (KO2Generator*) find{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    if(![defaults stringForKey:kSqlFilePath]){
        return nil;
    }
    
    KO2Generator *entity = [[KO2Generator alloc] init];
    
    entity.sqlFilePath = [defaults stringForKey:kSqlFilePath];
    entity.outputFilePath = [defaults stringForKey:kOutputDirectory];
    entity.classPrefix = [defaults stringForKey:kClassPrefix];
    entity.storeClassSuffix = [defaults stringForKey:kStoreClassSuffix];
    entity.entityClassSuffix = [defaults stringForKey:kEntityClassSuffix];
    
    return entity;
}

- (BOOL) store:(KO2Generator*) entity
{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:entity.sqlFilePath forKey:kSqlFilePath];
    [defaults setObject:entity.outputFilePath forKey:kOutputDirectory];
    [defaults setObject:entity.classPrefix forKey:kClassPrefix];
    [defaults setObject:entity.storeClassSuffix forKey:kStoreClassSuffix];
    [defaults setObject:entity.entityClassSuffix forKey:kEntityClassSuffix];
    
    return YES;
}

@end
