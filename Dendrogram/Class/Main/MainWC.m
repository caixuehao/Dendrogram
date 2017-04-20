//
//  MainWC.m
//  Dendrogram
//
//  Created by cxh on 17/4/19.
//  Copyright © 2017年 cxh. All rights reserved.
//

#import "MainWC.h"
#import "Macro.h"
#import "MainVC.h"

static MainWC* mainWCShare;
@interface MainWC ()

@end

@implementation MainWC

+(MainWC*)share{
    return mainWCShare;
}

- (nullable instancetype)initWithCoder:(NSCoder *)coder{
    if (self = [super initWithCoder:coder]) {
        mainWCShare = self;
    }
    return self;
}

#pragma keyboard
- (void)keyDown:(NSEvent *)theEvent{
    NSLog(@"%d",theEvent.keyCode);
    SendNotification(KeyUpEvent, @{@"keyCode":@(theEvent.keyCode)});
}


- (void)windowDidLoad {
    [super windowDidLoad];
    [self.window setContentViewController:[[MainVC alloc] initWithNibName:@"MainVC" bundle:[NSBundle mainBundle]]];
    
    [self.window setReleasedWhenClosed:NO];//设置关闭时不释放
     self.window.minSize = NSMakeSize(MinWidth, MinHeight);
    //显示之后才会调用
    [self performSelector:@selector(setMainWindow) withObject:nil afterDelay:0.2f];
}


-(void)setMainWindow{
    [self.window setContentSize:NSMakeSize(DefaultWidth, DefaultHeight)];
    [self.window center];
    
    NSPoint point = self.window.frame.origin;
    point.y -= 100;
    [self.window setFrameOrigin:point];
}
@end
