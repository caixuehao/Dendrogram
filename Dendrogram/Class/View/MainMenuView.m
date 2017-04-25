//
//  MainMenuView.m
//  Dendrogram
//
//  Created by cxh on 17/4/19.
//  Copyright © 2017年 cxh. All rights reserved.
//

#import "MainMenuView.h"
#import "MainController.h"

#import "NSScrTextView.h"
#import "NSLabel.h"
#import <Masonry.h>
#import "NSView+Frame.h"
#import "MainModel.h"
#import "Macro.h"
@implementation MainMenuView{
    MainController* mainController;
    NSMutableDictionary* sourceData;//用来显示的数据模版
    
    NSScrollView* mainScrView;
    NSTextField* pathTF;
    NSButton* selectPathBtn;
    NSButton* addCellBtn;
    NSButton* delCellBtn;
    NSButton* saveFileBtn;
    NSScrTextView* sourceDataSTV;
    
    NSTextField* addkeyTF;
    NSButton* addkeyBtn;
    NSPopUpButton* addkey_dataPathPUB;
    NSPopUpButton* addkey_dataTypePUB;
    
    NSPopUpButton* delkey_AllkeyPUB;
    NSButton* delkeyBtn;
    
    NSPopUpButton* modify_AllkeyPUB;
    NSButton* modifyBtn;
    NSPopUpButton* modify_dataPathPUB;
    NSTextField* modifyTF;
}

-(instancetype)init{
    if (self = [super init]) {
        mainController = [[MainController alloc] init];
        [self loadSubViews];
        [self loadActions];
        [self updateViewData];
//        addkeyTF.editable = NO;
//        modifyTF.editable = NO;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateViewData) name:UpdateMainView object:nil];
    }
    return self;
}


-(void)updateViewData{
    pathTF.stringValue = [MainModel share].filePath;
    
    sourceData = [[NSMutableDictionary alloc] init];
    [self replaceTypeName:[MainModel share].infoEntity.sourceData outdic:sourceData];
    NSData* jsondata = [NSJSONSerialization dataWithJSONObject:sourceData options:NSJSONWritingPrettyPrinted error:nil];
    NSString* str =[[NSString alloc] initWithData:jsondata encoding:NSUTF8StringEncoding];
    sourceDataSTV.string =str?str:@"";
    
    [addkey_dataPathPUB removeAllItems];
    [addkey_dataPathPUB addItemsWithTitles:[MainModel share].dicKeyArr];
    [delkey_AllkeyPUB removeAllItems];
    [delkey_AllkeyPUB addItemsWithTitles:[MainModel share].allKeyArr];
    [modify_AllkeyPUB removeAllItems];
    [modify_AllkeyPUB addItemsWithTitles:[MainModel share].allKeyArr];
    [modify_dataPathPUB removeAllItems];
    [modify_dataPathPUB addItemsWithTitles:[MainModel share].dicKeyArr];
}

-(void)replaceTypeName:(NSMutableDictionary*)indic outdic:(NSMutableDictionary*)outdic{
    for (NSString* key in indic) {
        if ([[indic objectForKey:key] isKindOfClass:[NSMutableDictionary class]]||[[indic objectForKey:key] isKindOfClass:[NSDictionary class]]) {
            NSMutableDictionary* dic = [[NSMutableDictionary alloc] init];
            [outdic setObject:dic forKey:key];
            [self replaceTypeName:[indic objectForKey:key] outdic:dic];
        }else{
            NSInteger type = [[indic objectForKey:key] integerValue];
            [outdic setObject:[MainModel share].dataTypeNameArr[type] forKey:key];
        }
    }
}

-(void)loadActions{
    selectPathBtn.target = self;
    addCellBtn.target = self;
    delCellBtn.target = self;
    saveFileBtn.target = self;
    addkeyBtn.target = self;
    delkeyBtn.target = self;
    modifyBtn.target = self;
    [selectPathBtn setAction:@selector(selectPath)];
    [addCellBtn setAction:@selector(addCell)];
    [delCellBtn setAction:@selector(delCell)];
    [saveFileBtn setAction:@selector(saveFile)];
    [addkeyBtn setAction:@selector(addkey)];
    [delkeyBtn setAction:@selector(delkey)];
    [modifyBtn setAction:@selector(modify)];
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
    [[MainModel share] addkey:addkeyTF.stringValue dataType:addkey_dataTypePUB.indexOfSelectedItem rootDic:addkey_dataPathPUB.title];
}
-(void)delkey{
    [[MainModel share] delkey:delkey_AllkeyPUB.title];
}
-(void)modify{
    [[MainModel share] modify:modify_AllkeyPUB.title newkey:modifyTF.stringValue rootDic:modify_dataPathPUB.title];
}



-(void)loadSubViews{
    mainScrView = ({
        NSScrollView* scrView = [[NSScrollView alloc] init];
        [scrView setHasVerticalScroller:YES];
//        [scrView setHasHorizontalScroller:YES];
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
    sourceDataSTV = ({
        NSScrTextView* stv = [[NSScrTextView alloc] init];
        stv.textView.editable = NO;
        [dataBox.contentView addSubview:stv];
        stv;
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
    addkey_dataPathPUB = ({
        NSPopUpButton* pub = [[NSPopUpButton alloc] initWithFrame:NSMakeRect(0, 0, 120, 25)];
        [pub addItemsWithTitles:@[@"root"]];
        [addkeyBox.contentView addSubview:pub];
        pub;
    });
    addkey_dataTypePUB = ({
        NSPopUpButton* pub = [[NSPopUpButton alloc] initWithFrame:NSMakeRect(130, 0, 90, 25)];
        [pub addItemsWithTitles:[MainModel share].dataTypeNameArr];
        [addkeyBox.contentView addSubview:pub];
        pub;
    });
    NSBox* delkeyBox = ({
        NSBox* box = [[NSBox alloc] init];
        box.title = @"删除字段:(字段名字，按钮)";
        [_view addSubview:box];
        box;
    });
    delkey_AllkeyPUB =({
        NSPopUpButton* pub = [[NSPopUpButton alloc] initWithFrame:NSMakeRect(0, 0, 125, 25)];
        [delkeyBox.contentView addSubview:pub];
        pub;
    });
    delkeyBtn = ({
        NSButton* btn = [[NSButton alloc] initWithFrame:NSMakeRect(130, 0, 90, 25)];
        [btn setTitle:@"删除字段"];
        [delkeyBox.contentView addSubview:btn];
        btn;
    });
    
    NSBox* modifyBox = ({
        NSBox* box = [[NSBox alloc] init];
        box.title = @"修改字段名字:(字段，按钮，位置，新名字)";
        [_view addSubview:box];
        box;
    });
    modify_AllkeyPUB =({
        NSPopUpButton* pub = [[NSPopUpButton alloc] initWithFrame:NSMakeRect(0, 30, 125, 25)];
        [modifyBox.contentView addSubview:pub];
        pub;
    });
    modifyBtn = ({
        NSButton* btn = [[NSButton alloc] initWithFrame:NSMakeRect(130, 30, 90, 25)];
        [btn setTitle:@"修改字段"];
        [modifyBox.contentView addSubview:btn];
        btn;
    });
    modify_dataPathPUB = ({
        NSPopUpButton* pub = [[NSPopUpButton alloc] initWithFrame:NSMakeRect(0, 0, 120, 25)];
        [pub addItemsWithTitles:@[@"root"]];
        [modifyBox.contentView addSubview:pub];
        pub;
    });
    modifyTF = ({
        NSTextField* textfield = [[NSTextField alloc] initWithFrame:NSMakeRect(130, 0, 120, 25)];
        [modifyBox.contentView addSubview:textfield];
        textfield;
    });
    
    //layout
    [mainScrView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    _view.frame = NSMakeRect(0, 0, 230, 600);
//    [_view mas_remakeConstraints:^(MASConstraintMaker *make) {
//        make.top.width.equalTo(mainScrView.contentView);
//        make.height.equalTo(@600);
//    }];
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
    [sourceDataSTV mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(dataBox.contentView).offset(3);
        make.right.bottom.equalTo(dataBox.contentView).offset(-3);
    }];
    [addkeyBox mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(dataBox.mas_bottom).offset(10);
        make.left.right.equalTo(_view);
        make.height.equalTo(@80);
    }];
    [delkeyBox mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(addkeyBox.mas_bottom).offset(30);
        make.left.right.equalTo(_view);
        make.height.equalTo(@45);
    }];
    [modifyBox mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(delkeyBox.mas_bottom).offset(30);
        make.left.right.equalTo(_view);
        make.height.equalTo(@80);
    }];
}

-(void)setFrame:(NSRect)frame{
    [super setFrame:frame];
}
@end
