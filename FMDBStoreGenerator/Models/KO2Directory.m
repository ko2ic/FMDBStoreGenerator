//
//  KO2Directory.m
//  FMDBStoreGenerator
//
//  Created by 石井 幸次 on 2013/11/18.
//
//

#import "KO2Directory.h"
#import "KO2Generator.h"

@implementation KO2Directory{
@private NSString* outputPath_;
}

#pragma mark - Properties
-(NSString*) string{
    return outputPath_;
}

#pragma mark - Life Cycle

+ (id) directoryWithOutputPath:(NSString*) outputPath{
    return [[self alloc] initWithOutputPath:outputPath];
}

- (id) initWithOutputPath:(NSString*) outputPath{
    self = [super init];
    if (self) {
        outputPath_ = outputPath;
    }
    return self;
}

#pragma mark - Public Method

- (BOOL) createModelDirectory:(KO2Generator*) entity{
    NSString* modelDirPath = [entity.outputDirectory.string stringByAppendingString:@"/Models"];
    if (![self createDirectory:modelDirPath]) {
        return NO;
    }
    outputPath_ = modelDirPath;
    
    return YES;
}

- (BOOL) createStoreDirectory:(KO2Generator*) entity{
    NSString* storeClassSuffix = entity.storeClassSuffix;
    NSString* plural = @"s";
    if ([entity.storeClassSuffix hasSuffix:@"y"]) {
        storeClassSuffix = [storeClassSuffix substringToIndex:storeClassSuffix.length-1];
        plural = @"ies";
    }
    NSString* storeDirPath = [NSString stringWithFormat:@"%@/%@%@",entity.outputDirectory.string,storeClassSuffix,plural];
    
    if(![self createDirectory:storeDirPath]){
        return NO;
    }
    outputPath_ = storeDirPath;
    
    return YES;
}

- (BOOL) createFMDBCoreDirectory:(KO2Generator*) entity{
    NSString* fmdbDirPath = [entity.outputDirectory.string stringByAppendingString:@"/fmdb"];
    if(![self createDirectory:fmdbDirPath]){
        return NO;
    }
    outputPath_ = fmdbDirPath;
    return YES;
    
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
