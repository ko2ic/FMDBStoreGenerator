//
//  FMDBStoreGenerator
//
//  Copyright (c) 2012 Kouji Ishii
//
//  This software is released under the MIT License.
//
//  http://opensource.org/licenses/mit-license.php
//

#import <Cocoa/Cocoa.h>


@interface KO2AppDelegate : NSObject <NSApplicationDelegate,NSTextFieldDelegate>

@property (assign) IBOutlet NSWindow *window;

@property (weak) IBOutlet NSTextField *sqlFilePath;

@property (weak) IBOutlet NSTextField *outputDirectory;

@property (weak) IBOutlet NSTextField *classPrefix;

@property (weak) IBOutlet NSTextField *storeClassSuffix;

@property (weak) IBOutlet NSTextField *entityClassSuffix;

@property (weak) IBOutlet NSButton *overwriteCoreClass;

@property (weak) IBOutlet NSButton *overwriteStoreAndEntityClass;

@end
