//
//  MainController.m
//  Dendrogram
//
//  Created by cxh on 17/4/20.
//  Copyright © 2017年 cxh. All rights reserved.
//

#import "MainController.h"
#import "Macro.h"
#import "MainModel.h"
#import <AppKit/AppKit.h>

@implementation MainController
-(instancetype)init{
    if (self = [super init]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyUp:) name:KeyUpEvent object:nil];
    }
    return self;
}

-(void)keyUp:(NSNotification *)notifiction{
    NSInteger keyCode =[[notifiction.userInfo objectForKey:@"keyCode"] integerValue];
    //保存（alt＋s or ctrl＋s）
    if (keyCode == 1) {
        if([MainModel share].filePath.length == 0){
            //打开文件选择器 http://www.cnblogs.com/onecodego/p/3685864.html
            NSSavePanel*    panel = [NSSavePanel savePanel];
            [panel setNameFieldStringValue:@"Untitle"];
            [panel setMessage:@"保存树状图"];
            [panel setAllowsOtherFileTypes:YES];
            [panel setAllowedFileTypes:@[FileTypeName]];
            [panel setExtensionHidden:YES];
            [panel setCanCreateDirectories:YES];
            [panel beginSheetModalForWindow:[NSApplication sharedApplication].keyWindow completionHandler:^(NSInteger result){
                if (result == NSFileHandlingPanelOKButton)
                {
                    NSString *path = [[panel URL] path];
                    [MainModel share].filePath = path;
                    [[MainModel share] saveFile];
                }
            }];
            
        }else{
            [[MainModel share] saveFile];
        }
    }
    
}
@end
