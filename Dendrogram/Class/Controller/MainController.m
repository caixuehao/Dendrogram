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
        if([MainModel share].filePath.length < 1){
            //打开文件选择器
        }else{
            
        }
    }
    
}
@end
