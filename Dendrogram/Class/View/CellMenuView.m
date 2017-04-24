//
//  CellMenuView.m
//  Dendrogram
//
//  Created by cxh on 17/4/19.
//  Copyright © 2017年 cxh. All rights reserved.
//

#import "CellMenuView.h"
#import <Masonry.h>
#import "NSView+Frame.h"
#import "MainModel.h"
#import "Macro.h"
#import "NSScrTextView.h"

@implementation CellMenuView{
    NSScrTextView* scrTextView;
    NSButton* okbtn;
}
-(instancetype)init{
    if (self = [super init]) {
        [self loadSubViews];
         [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateView) name:SelectedCellChange object:nil];
    }
    return self;
}
-(void)updateView{
    self.entity = [MainModel share].selectedEntity;
}

-(void)setEntity:(DendrogramEntity *)entity{
    _entity = entity;
    if (entity) {
        NSData* jsondata = [NSJSONSerialization dataWithJSONObject:_entity.data options:NSJSONWritingPrettyPrinted error:nil];
        scrTextView.textView.string = [[NSString alloc] initWithData:jsondata encoding:NSUTF8StringEncoding];
    }
}
-(void)loadSubViews{
    scrTextView =({
        NSScrTextView* st = [[NSScrTextView alloc] init];
        [self addSubview:st];
        st;
    });
    
    okbtn = ({
        NSButton* btn = [[NSButton alloc] init];
        [btn setTitle:@"保存修改"];
        [self addSubview:btn];
        btn;
    });
    
    [scrTextView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self);
        make.bottom.equalTo(self).offset(-100);
    }];
    [okbtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.centerX.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(200, 80));
    }];
}
@end
