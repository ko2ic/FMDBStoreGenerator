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

- (NSString*) sqlFileName{
    return [self.sqlFilePath lastPathComponent];
}

+ (id)generatorWith:(KO2Generator*) entity andTemplateFileName:(NSString*) filename  andOutputFilePath:(NSString*) outputFilePath;{
    
    return [[self alloc]initWithSelf:entity andTemplateFileName:filename andOutputFilePath:outputFilePath];
}

- (id)initWithSelf:(KO2Generator*) entity andTemplateFileName:(NSString*) filename  andOutputFilePath:(NSString*) outputFilePath;{

    self = [super init];
    if (self && entity) {
        self.sqlFilePath = entity.sqlFilePath;
        self.classPrefix = entity.classPrefix;
        self.storeClassSuffix = entity.storeClassSuffix;
        self.entityClassSuffix = entity.entityClassSuffix;
        self.outputFilePath = outputFilePath;
        
        NSMutableDictionary* placeholder = [NSMutableDictionary dictionary];
        [placeholder setObject:entity.classPrefix forKey:@"prefix"];
        [placeholder setObject:entity.entityClassSuffix forKey:@"entitySuffix"];
        [placeholder setObject:entity.storeClassSuffix forKey:@"storeSuffix"];
        [placeholder setObject:[PositionFilter new] forKey:@"withPosition"];        
        placeholder_ = placeholder;
        
        template_ = [GRMustacheTemplate templateFromResource:filename bundle:[NSBundle mainBundle] error:NULL];
        
        if ([filename rangeOfString:@"Store"].location != NSNotFound) {
            classSuffix_ = entity.storeClassSuffix;
        }else         if ([filename rangeOfString:@"Entity"].location != NSNotFound) {
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
    
    NSString *filePath = [NSString stringWithFormat:@"%@/%@%@%@.%@",_outputFilePath,_classPrefix ,table.entityClassName,classSuffix_ ,extention_];
    if([manager createFileAtPath:filePath contents:data attributes:nil]){
        NSLog(@"成功:%@",filePath);
    }else{
        NSLog(@"失敗:%@",filePath);
    }
}

- (void) generateCoreClass:(NSString*) classFileName {
    [placeholder_ setObject:self.sqlFileName forKey:@"sqlFileName"];
    
    NSString *rendering = [template_ renderObject:placeholder_ error:NULL];
    NSData *data = [rendering dataUsingEncoding:NSUTF8StringEncoding];
    
    NSFileManager* manager = [NSFileManager defaultManager];
    
    NSString *filePath = [NSString stringWithFormat:@"%@/%@%@",_outputFilePath,_classPrefix,classFileName];
    if([manager createFileAtPath:filePath contents:data attributes:nil]){
        NSLog(@"成功:%@",filePath);
    }else{
        NSLog(@"失敗:%@",filePath);
    }
}

@end
