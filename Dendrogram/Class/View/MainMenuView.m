//
//  MainMenuView.m
//  Dendrogram
//
//  Created by cxh on 17/4/19.
//  Copyright © 2017年 cxh. All rights reserved.
//

#import "MainMenuView.h"
#import "MainController.h"

#import "NSLabel.h"
#import <Masonry.h>
#import "NSView+Frame.h"
#import "MainModel.h"
#import "Macro.h"
@implementation MainMenuView{
    MainController* mainController;
    NSScrollView* mainScrView;
    NSTextField* pathTF;
    NSButton* selectPathBtn;
    NSButton* addCellBtn;
    NSButton* delCellBtn;
    NSButton* saveFileBtn;
    NSTextField* sourceDataTF;
    
    NSTextField* addkeyTF;
    NSButton* addkeyBtn;
    NSPopUpButton* addkeyDataPathPUB;
    NSPopUpButton* addkeyDataTypePUB;
    
    
}

-(instancetype)init{
    if (self = [super init]) {
        mainController = [[MainController alloc] init];
        [self loadSubViews];
        [self loadActions];
        [self updateViewData];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateViewData) name:UpdateMainView object:nil];
    }
    return self;
}


-(void)updateViewData{
    pathTF.stringValue = [MainModel share].filePath;
    sourceDataTF.stringValue = [NSString stringWithFormat:@"%@",[MainModel share].infoEntity.sourceData];
}

-(void)loadActions{
    selectPathBtn.target = self;
    addCellBtn.target = self;
    delCellBtn.target = self;
    saveFileBtn.target = self;
    addkeyBtn.target = self;
    [selectPathBtn setAction:@selector(selectPath)];
    [addCellBtn setAction:@selector(addCell)];
    [delCellBtn setAction:@selector(delCell)];
    [saveFileBtn setAction:@selector(saveFile)];
    [addkeyBtn setAction:@selector(addkey)];
}


-(void)selectPath{
    [mainController selectSavePath:nil];
}
-(void)addCell{
    [[MainModel share] addNullCell:[MainModel share].selectedEntity];
}
-(void)delCell{
    [[MainModel share] removeCell:[MainModel share].selectedEntity];
}
-(void)saveFile{
    [[MainModel share] saveFile];
}
-(void)addkey{
    [[MainModel share] addkey:addkeyTF.stringValue dataType:addkeyDataTypePUB.indexOfSelectedItem rootDic:addkeyDataPathPUB.title];
}





-(void)loadSubViews{
    mainScrView = ({
        NSScrollView* scrView = [[NSScrollView alloc] init];
        [scrView setHasVerticalScroller:YES];
        [scrView setHasHorizontalScroller:YES];
        [self addSubview:scrView];
        
        NSClipView* clipView = [[NSClipView alloc] init];
        [scrView addSubview:clipView];
        [scrView setContentView:clipView];
        scrView;
    });

    _view = ({
        NSView* view = [[NSView alloc] init];
        [mainScrView addSubview:view];
        [mainScrView setDocumentView:view];
        view;
    });
    
    
    NSBox* pathBox = ({
        NSBox* box = [[NSBox alloc] init];
        box.title = @"文件保存路径:";
        [_view addSubview:box];
        box;
    });
    pathTF = ({
        NSTextField* textfield = [[NSTextField alloc] init];
        [pathBox.contentView addSubview:textfield];
        textfield.maximumNumberOfLines = 0;
        textfield.enabled = NO;
        textfield;
    });
    selectPathBtn = ({
        NSButton* btn = [[NSButton alloc] init];
        [btn setTitle:@"选择文件保存路径"];
        [_view addSubview:btn];
        btn;
    });
    addCellBtn = ({
        NSButton* btn = [[NSButton alloc] init];
        [btn setTitle:@"添加子节点"];
        [_view addSubview:btn];
        btn;
    });
    delCellBtn = ({
        NSButton* btn = [[NSButton alloc] init];
        [btn setTitle:@"删除节点"];
        [_view addSubview:btn];
        btn;
    });
    saveFileBtn = ({
        NSButton* btn = [[NSButton alloc] init];
        [btn setTitle:@"保存文件"];
        [_view addSubview:btn];
        btn;
    });
    NSBox* dataBox = ({
        NSBox* box = [[NSBox alloc] init];
        box.title = @"数据模版:";
        [_view addSubview:box];
        box;
    });
    sourceDataTF = ({
        NSTextField* textfield = [[NSTextField alloc] init];
        textfield.enabled = NO;
        [dataBox.contentView addSubview:textfield];
        textfield;
    });
    NSBox* addkeyBox = ({
        NSBox* box = [[NSBox alloc] init];
        box.title = @"添加字段:(字段名字，按钮，位置，类型)";
        [_view addSubview:box];
        box;
    });
    addkeyTF =({
        NSTextField* textfield = [[NSTextField alloc] initWithFrame:NSMakeRect(0, 30, 120, 25)];
        [addkeyBox.contentView addSubview:textfield];
        textfield;
    });
    addkeyBtn = ({
        NSButton* btn = [[NSButton alloc] initWithFrame:NSMakeRect(130, 30, 90, 25)];
        [btn setTitle:@"添加字段"];
        [addkeyBox.contentView addSubview:btn];
        btn;
    });
    addkeyDataPathPUB = ({
        NSPopUpButton* pub = [[NSPopUpButton alloc] initWithFrame:NSMakeRect(0, 0, 120, 25)];
        [pub addItemsWithTitles:@[@"root"]];
        [addkeyBox.contentView addSubview:pub];
        pub;
    });
    addkeyDataTypePUB = ({
        NSPopUpButton* pub = [[NSPopUpButton alloc] initWithFrame:NSMakeRect(130, 0, 90, 25)];
        [pub addItemsWithTitles:[MainModel share].dataTypeNameArr];
        [addkeyBox.contentView addSubview:pub];
        pub;
    });
    
    
    //layout
    [mainScrView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    _view.frame = NSMakeRect(0, 0, 230, 600);
    [pathBox mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(_view);
        make.width.equalTo(_view);
        make.height.equalTo(@60);
    }];
    [pathTF mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(pathBox.contentView);
        make.width.equalTo(pathBox.contentView);
        make.height.equalTo(@40);
    }];
    [selectPathBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_view);
        make.right.equalTo(_view).offset(-10);
        make.width.equalTo(@120);
        make.height.equalTo(@13);
    }];
    [addCellBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(pathBox.mas_bottom).offset(10);
        make.left.equalTo(self).offset(5);
        make.size.mas_equalTo(CGSizeMake(70, 40));
    }];
    [delCellBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(pathBox.mas_bottom).offset(10);
        make.left.equalTo(addCellBtn.mas_right).offset(5);
        make.size.mas_equalTo(CGSizeMake(70, 40));
    }];
    [saveFileBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(pathBox.mas_bottom).offset(10);
        make.left.equalTo(delCellBtn.mas_right).offset(5);
        make.size.mas_equalTo(CGSizeMake(70, 40));
    }];
    [dataBox mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(saveFileBtn.mas_bottom).offset(10);
        make.left.right.equalTo(_view);
        make.height.equalTo(@200);
    }];
    [sourceDataTF mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(dataBox.contentView).offset(3);
        make.right.bottom.equalTo(dataBox.contentView).offset(-3);
    }];
    [addkeyBox mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(dataBox.mas_bottom).offset(10);
        make.left.right.equalTo(_view);
        make.height.equalTo(@80);
    }];
}
@end
