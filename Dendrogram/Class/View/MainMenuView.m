//
//  MainMenuView.m
//  Dendrogram
//
//  Created by cxh on 17/4/19.
//  Copyright © 2017年 cxh. All rights reserved.
//

#import "MainMenuView.h"
#import "MainController.h"

@implementation MainMenuView{
    MainController* mainController;
}

-(instancetype)init{
    if (self = [super init]) {
        mainController = [[MainController alloc] init];
    }
    return self;
}

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

@end
