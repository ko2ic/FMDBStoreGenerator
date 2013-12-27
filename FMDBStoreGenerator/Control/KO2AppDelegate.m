//
//  FMDBStoreGenerator
//
//  Copyright (c) 2012 Kouji Ishii
//
//  This software is released under the MIT License.
//
//  http://opensource.org/licenses/mit-license.php
//

#import "KO2AppDelegate.h"
#import "KO2GeneratorService.h"
#import "KO2Generator.h"
#import "KO2Directory.h"

@implementation KO2AppDelegate{
    @private KO2Generator* entity_;
}

#pragma mark - Life Cycle
- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    _classPrefix.delegate = self;
    entity_ = [[KO2GeneratorService new] find];
    _outputDirectory.stringValue = entity_.outputDirectory.string;
    _sqlFilePath.stringValue = entity_.sqlFilePath;
    _classPrefix.stringValue = entity_.classPrefix;
    _storeClassSuffix.stringValue = entity_.storeClassSuffix;
    _entityClassSuffix.stringValue = entity_.entityClassSuffix;
    _overwriteCoreClass.stringValue = [NSString stringWithFormat:@"%d", entity_.overwriteCoreClass ];
    _overwriteStoreAndEntityClass.stringValue = [NSString stringWithFormat:@"%d", entity_.overwriteStoreAndEntityClass ];
}

- (void)dealloc {
 
}

#pragma mark - NSTextFieldDelegate
- (void)controlTextDidChange:(NSNotification *)aNotification{
    _classPrefix.stringValue = [_classPrefix.stringValue uppercaseString];
    if([_classPrefix.stringValue length] >= 4){
        _classPrefix.stringValue = [_classPrefix.stringValue substringToIndex:3];
    }
}


#pragma mark - Action
- (IBAction)selectSqlFile:(id)sender {
    NSOpenPanel* dlg =[NSOpenPanel openPanel];
    [dlg setCanChooseFiles:YES];
    [dlg setCanChooseDirectories:NO];
    NSInteger button = [dlg runModal];
    if (button == NSFileHandlingPanelOKButton)
    {
        NSURL *chosenURL = [[dlg URLs] objectAtIndex:0];
        _sqlFilePath.stringValue =  chosenURL.relativePath;
    }
}

- (IBAction)selectOutputDirectory:(id)sender {
    NSOpenPanel* dlg =[NSOpenPanel openPanel];
    [dlg setCanChooseFiles:NO];
    [dlg setCanChooseDirectories:YES];
    NSInteger button = [dlg runModal];
    if (button == NSFileHandlingPanelOKButton)
    {
        NSURL *chosenURL = [[dlg URLs] objectAtIndex:0];
        _outputDirectory.stringValue = chosenURL.relativePath;
    }
}

- (IBAction)generate:(id)sender {
    entity_.sqlFilePath = _sqlFilePath.stringValue;
        entity_.outputDirectory = [KO2Directory directoryWithOutputPath:_outputDirectory.stringValue];
    entity_.classPrefix = _classPrefix.stringValue;
    entity_.storeClassSuffix = _storeClassSuffix.stringValue;
    entity_.entityClassSuffix = _entityClassSuffix.stringValue;
    entity_.overwriteCoreClass = _overwriteCoreClass.stringValue.boolValue;
    entity_.overwriteStoreAndEntityClass = _overwriteStoreAndEntityClass.stringValue.boolValue;
    
    KO2GeneratorService* service = [KO2GeneratorService new];
    [service generate:entity_];
    
}


@end
