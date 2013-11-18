//
//  KO2Directory.h
//  FMDBStoreGenerator
//
//  Created by 石井 幸次 on 2013/11/18.
//
//

#import <Foundation/Foundation.h>

@class KO2Generator;

@interface KO2Directory : NSObject

@property(readonly) NSString* string;

+ (id) directoryWithOutputPath:(NSString*) outputPath;

- (BOOL) createModelDirectory:(KO2Generator*) entity;
- (BOOL) createStoreDirectory:(KO2Generator*) entity;
- (BOOL) createFMDBCoreDirectory:(KO2Generator*) entity;

@end
