//
//  LLPluginController.h
//  Lablib
//
//  Created by John Maunsell on 12/31/05.
//  Copyright 2005. All rights reserved.
//

#define    kUseLLDataDevices

#ifdef kUseLLDataDevices
#define kLLPluginVersion    4200
#else
#define kLLPluginVersion    4201
#endif

@interface LLPluginController : NSWindowController {
   
    NSUserDefaults            *defaults;
    NSMutableArray            *enabled;
    NSMutableArray            *loadedPlugins;
    NSMutableArray            *validTaskPlugins;

    IBOutlet NSTableView    *pluginTable;
}

@property (NS_NONATOMIC_IOSONLY, readonly, copy) NSArray *loadedPlugins;
@property (NS_NONATOMIC_IOSONLY, readonly) long numberOfValidPlugins;

- (instancetype)initWithDefaults:(NSUserDefaults *)theDefaults;
- (void)loadPlugins;
- (void)loadPluginsForApplication:(NSString *)appName;
- (void)loadOrUnloadPlugins;
- (void)runDialog;
- (IBAction)dialogDone:(id)sender;

@end
