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

#import "KO2Generator.h"

@interface KO2GeneratorService : NSObject

- (void) generate:(KO2Generator*) entity;
- (KO2Generator*) find;

@end
