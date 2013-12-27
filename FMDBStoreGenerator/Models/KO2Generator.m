//
//  FMDBStoreGenerator
//
//  Copyright (c) 2012 Kouji Ishii
//
//  This software is released under the MIT License.
//
//  http://opensource.org/licenses/mit-license.php
//

#import "KO2Generator.h"

#import "GRMustacheTemplate.h"
#import "PositionFilter.h"

@implementation KO2Generator{
    @private GRMustacheTemplate* template_;
    @private NSMutableDictionary* placeholder_;
    @private NSString* extention_;
    @private NSString* classSuffix_;
}

#pragma mark - Properties

- (NSString*) sqlFileName{
    return [self.sqlFilePath lastPathComponent];
}

- (NSString*) storeClassSuffix{
    return [_storeClassSuffix capitalizedString];
}

- (NSString*) entityClassSuffix{
    return [_entityClassSuffix capitalizedString];
}

#pragma mark - Life Cycle

+ (id)generatorWith:(KO2Generator*) entity andTemplateFileName:(NSString*) filename  andOutputDirectory:(KO2Directory*) outputDirectory{
    
    return [[self alloc]initWithSelf:entity andTemplateFileName:filename andOutputDirectory:outputDirectory];
}

- (id)initWithSelf:(KO2Generator*) entity andTemplateFileName:(NSString*) filename  andOutputDirectory:(KO2Directory*) outputDirectory{

    self = [super init];
    if (self && entity) {
        self.sqlFilePath = entity.sqlFilePath;
        self.classPrefix = entity.classPrefix;
        self.storeClassSuffix = entity.storeClassSuffix;
        self.entityClassSuffix = entity.entityClassSuffix;
        self.outputDirectory = outputDirectory;
        self.overwriteCoreClass = entity.overwriteCoreClass;
        self.overwriteStoreAndEntityClass = entity.overwriteStoreAndEntityClass;
        
        NSMutableDictionary* placeholder = [NSMutableDictionary dictionary];
        [placeholder setObject:entity.classPrefix forKey:@"prefix"];
        [placeholder setObject:entity.entityClassSuffix forKey:@"entitySuffix"];
        [placeholder setObject:entity.storeClassSuffix forKey:@"storeSuffix"];
        [placeholder setObject:[PositionFilter new] forKey:@"withPosition"];        
        placeholder_ = placeholder;
        
        template_ = [GRMustacheTemplate templateFromResource:filename bundle:[NSBundle mainBundle] error:NULL];
        
        if ([filename rangeOfString:@"Store"].location != NSNotFound) {
            classSuffix_ = entity.storeClassSuffix;
        }else if ([filename rangeOfString:@"Entity"].location != NSNotFound) {
            classSuffix_ = entity.entityClassSuffix;
        }
        extention_ = [filename pathExtension];
        
        entity = nil;
    }
    return self;
}

- (void) generateWithTable:(KO2TableInfo*) table {
    [placeholder_ setObject:table.entityClassName forKey:@"entityClassName"];
    [placeholder_ setObject:table.tableName forKey:@"tableName"];
    [placeholder_ setObject:table.columnInfos forKey:@"columnInfos"];
    [placeholder_ setObject:table.notPrimaryKeyInfo forKey:@"notPrimaryKeyInfo"];
    [placeholder_ setObject:table.primaryKeyInfo forKey:@"primaryKeyInfo"];
    
    NSString *rendering = [template_ renderObject:placeholder_ error:NULL];
    NSData *data = [rendering dataUsingEncoding:NSUTF8StringEncoding];
    
    NSFileManager* manager = [NSFileManager defaultManager];
    
    NSString *filePath = [NSString stringWithFormat:@"%@/%@%@%@.%@",self.outputDirectory.string,_classPrefix ,table.entityClassName,classSuffix_ ,extention_];
    
    if ([self isGenerationStoreAndEntityClass:filePath]) {
        if([manager createFileAtPath:filePath contents:data attributes:nil]){
            NSLog(@"Success : %@",filePath);
        }else{
            NSLog(@"Failure : %@",filePath);
        }
    }
}

- (void) generateCoreClass:(NSString*) classFileName {
    [placeholder_ setObject:self.sqlFileName forKey:@"sqlFileName"];
    
    NSString *rendering = [template_ renderObject:placeholder_ error:NULL];
    NSData *data = [rendering dataUsingEncoding:NSUTF8StringEncoding];
    
    NSFileManager* manager = [NSFileManager defaultManager];
    
    NSString *filePath = [NSString stringWithFormat:@"%@/%@%@",self.outputDirectory.string,_classPrefix,classFileName];
    if ([self isGenerationCoreClass:filePath]) {
        if([manager createFileAtPath:filePath contents:data attributes:nil]){
            NSLog(@"Success : %@",filePath);
        }else{
            NSLog(@"Failure : %@",filePath);
        }
    }
}

#pragma mark - Private Method
- (BOOL) isGenerationCoreClass:(NSString*) path
{
    NSFileManager* manager = [NSFileManager defaultManager];
    if (_overwriteCoreClass || (!_overwriteCoreClass && ![manager fileExistsAtPath:path isDirectory:NO])) {
        return YES;
    }
    return NO;
    
}

- (BOOL) isGenerationStoreAndEntityClass:(NSString*) path
{
    NSFileManager* manager = [NSFileManager defaultManager];
    if (_overwriteStoreAndEntityClass || (!_overwriteStoreAndEntityClass && ![manager fileExistsAtPath:path isDirectory:NO])) {
        return YES;
    }
    return NO;
    
}

@end
