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
+(void)ShowTip2:(NSString*)tip title:(NSString*)title handler:(void (^)())handler{
     [[NSTip share] ShowTip2:tip title:title window:[NSApplication sharedApplication].keyWindow handler:^{
         if (handler) handler();
     }];
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
-(void)ShowTip2:(NSString*)tip title:(NSString*)title window:(NSWindow*)window handler:(void (^)())handler{
    NSAlert *alert = [[NSAlert alloc] init];
    [alert addButtonWithTitle:@"确定"];
    [alert addButtonWithTitle:@"取消"];
    [alert setMessageText:title];
    [alert setInformativeText:tip];
    [alert setAlertStyle:NSWarningAlertStyle];
    [alert beginSheetModalForWindow:window completionHandler:^(NSModalResponse returnCode) {
        if (returnCode == 1000) {
            handler();
        }
    }];
}
@end
