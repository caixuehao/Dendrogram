//
//  NSTip.m
//  Dendrogram
//
//  Created by C on 17/4/22.
//  Copyright © 2017年 cxh. All rights reserved.
//

#import "NSTip.h"
static NSTip *NSTipShare;
@implementation NSTip

+(instancetype)share{
    if (NSTipShare == nil) {
        NSTipShare = [[NSTip alloc] init];
    }
    return NSTipShare;
}
+(void)ShowTip:(NSString*)tip title:(NSString*)title{
    [[NSTip share] ShowTip:tip title:title window:[NSApplication sharedApplication].keyWindow];
}

-(void)ShowTip:(NSString*)tip title:(NSString*)title window:(NSWindow*)window{
    NSAlert *alert = [[NSAlert alloc] init];
    [alert addButtonWithTitle:@"我知道了"];
    [alert setMessageText:title];
    [alert setInformativeText:tip];
    [alert setAlertStyle:NSWarningAlertStyle];
    [alert beginSheetModalForWindow:window completionHandler:^(NSModalResponse returnCode) {
    }];
}

@end
