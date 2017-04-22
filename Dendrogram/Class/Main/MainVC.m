//
//  MainVC.m
//  Dendrogram
//
//  Created by cxh on 17/4/19.
//  Copyright © 2017年 cxh. All rights reserved.
//

#import "MainVC.h"

#import <Masonry.h>
#import "Macro.h"

#import "MainMenuView.h"
#import "ContentView.h"
#import "CellMenuView.h"

@interface MainVC ()

@end

@implementation MainVC{
    NSView* mainMenuView;
    NSView* contentView;
    NSView* cellMenuView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadSubViews];
}




-(void)loadSubViews{
    self.view.wantsLayer = YES;
    
    mainMenuView = ({
        MainMenuView* view = [[MainMenuView alloc] init];
        view.view.wantsLayer = YES;
        view.view.layer.backgroundColor = CColor(255,255,200,1).CGColor;
        [self.view addSubview:view];
        view;
    });
    contentView = ({
        ContentView* view = [[ContentView alloc] init];
//        view.view.wantsLayer = YES;
//        view.view.layer.backgroundColor = CColor(255,200,255,1).CGColor;
        [self.view addSubview:view];
        view;
    });
    cellMenuView = ({
        CellMenuView* view = [[CellMenuView alloc] init];
        view.wantsLayer = YES;
        view.layer.backgroundColor = CColor(200,255,255,1).CGColor;
        [self.view addSubview:view];
        view;
    });
    
    //layout
    [mainMenuView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(self.view);
        make.width.equalTo(@250);
    }];
    
    [contentView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(mainMenuView.mas_right);
        make.top.bottom.equalTo(self.view);
        make.right.equalTo(cellMenuView.mas_left);
    }];
    
    [cellMenuView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.top.bottom.equalTo(self.view);
        make.width.equalTo(@250);
    }];
    

    
}

@end
