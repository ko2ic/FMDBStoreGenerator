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
#import "KO2Generator.h"

@interface KO2GeneratorStore : NSObject

- (KO2Generator*) find;
- (BOOL) store:(KO2Generator*) entity;

@end
