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

@implementation MainController{
    NSSavePanel*    savePanel;
}
-(instancetype)init{
    if (self = [super init]) {
        //打开文件选择器 http://www.cnblogs.com/onecodego/p/3685864.html
        savePanel = [NSSavePanel savePanel];
        [savePanel setNameFieldStringValue:@"Untitle"];
        [savePanel setMessage:@"保存树状图"];
        [savePanel setAllowsOtherFileTypes:YES];
        [savePanel setAllowedFileTypes:@[FileTypeName]];
        [savePanel setExtensionHidden:YES];
        [savePanel setCanCreateDirectories:YES];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyUp:) name:KeyUpEvent object:nil];
    }
    return self;
}

-(void)keyUp:(NSNotification *)notifiction{
    NSInteger keyCode =[[notifiction.userInfo objectForKey:@"keyCode"] integerValue];
    //保存（alt＋s or ctrl＋s）
    if (keyCode == 1) {
        if([MainModel share].filePath.length == 0){
            [self selectSavePath:^(NSString *path) {
                [[MainModel share] saveFile];
            }];
        }else{
            [[MainModel share] saveFile];
        }
    }
    
}

-(void)selectSavePath:(void (^)(NSString* path))handler{
    [savePanel beginSheetModalForWindow:[NSApplication sharedApplication].keyWindow completionHandler:^(NSInteger result){
        if (result == NSFileHandlingPanelOKButton)
        {
            [MainModel share].filePath = [[savePanel URL] path];
            if(handler)handler([[savePanel URL] path]);
        }
    }];
}
@end
