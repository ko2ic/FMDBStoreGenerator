//
//  NSFileManager+NSFileManager_DirectoryManager.m
//  FMDBStoreGenerator
//
//  Created by 石井 幸次 on 2013/10/11.
//  Copyright (c) 2013年 ArsNova. All rights reserved.
//

#import "NSFileManager+NSFileManager_DirectoryManager.h"

@implementation NSFileManager (NSFileManager_DirectoryManager)

-(BOOL)createDirectorysAtPath:(NSString *) directoryPath{
    
    [self changeCurrentDirectoryPath:@"/"];
    
    for(NSString* dir in [directoryPath pathComponents]){
        if ( [ self fileExistsAtPath:dir]){
            [ self changeCurrentDirectoryPath:dir];
        }else{
            NSDictionary* dirInfoDic = @{NSFileModificationDate:[NSDate date],
                                         NSFileOwnerAccountName:@"owner",
                                         NSFileGroupOwnerAccountName:@"group",
                                         NSFilePosixPermissions:[NSNumber numberWithShort:0766] ,
                                         NSFileExtensionHidden : [NSNumber numberWithBool:YES]};
            
            self createDirectoryAtURL:(NSURL *) withIntermediateDirectories:<#(BOOL)#> attributes:<#(NSDictionary *)#> error:<#(NSError *__autoreleasing *)#>
            
            if ( [ self createDirectoryAtPath:dir attributes:dirInfoDic]){
                [ self changeCurrentDirectoryPath:dir];
            }else{
                return NO;
            }
        }
    }

    return YES;
}

@end
