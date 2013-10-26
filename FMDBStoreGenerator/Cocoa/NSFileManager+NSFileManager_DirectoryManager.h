//
//  NSFileManager+NSFileManager_DirectoryManager.h
//  FMDBStoreGenerator
//
//  Created by 石井 幸次 on 2013/10/11.
//  Copyright (c) 2013年 ArsNova. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSFileManager (NSFileManager_DirectoryManager)

-(BOOL)createDirectorysAtPath:(NSString *)path;

@end
