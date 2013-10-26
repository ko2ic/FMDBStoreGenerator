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
#import "FMDatabase.h"


@interface KO2SqliteMasterStore : NSObject

+ (id) storeWithDatabase:(FMDatabase*) db;
- (void) close;

- (NSArray*) findTableNames;
- (NSArray*) findTables:(NSArray*)tableNames;

@end
