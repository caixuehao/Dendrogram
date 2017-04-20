//
//  AppDelegate.m
//  Dendrogram
//
//  Created by cxh on 17/4/17.
//  Copyright © 2017年 cxh. All rights reserved.
//

#import "AppDelegate.h"
#import "MainWC.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

//点击Dock重新打开主窗口
- (BOOL)applicationShouldHandleReopen:(NSApplication *)theApplication
                    hasVisibleWindows:(BOOL)flag{
 
    [[MainWC share].window makeKeyAndOrderFront:self];
    return YES;
}

@end
