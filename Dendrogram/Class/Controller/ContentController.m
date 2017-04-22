//
//  ContentController.m
//  Dendrogram
//
//  Created by cxh on 17/4/20.
//  Copyright © 2017年 cxh. All rights reserved.
//

#import "ContentController.h"
#import "Macro.h"
#import "MainModel.h"

@implementation ContentController

-(instancetype)init{
    if (self = [super init]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyUp:) name:KeyUpEvent object:nil];
    }
    return self;
}

-(void)addCell:(CellView*)cellView{
    cellView.target = self;
    if (cellView.entity == _selectedEntity) {
        [self OnClickCell:cellView];
    }
    [cellView setAction:@selector(OnClickCell:)];
}

-(void)OnClickCell:(CellView*)cell{
    if (_selectedCell != cell) {
        _selectedCell.isselected = NO;
        cell.isselected = YES;
        _selectedCell = cell;
        _selectedEntity = cell.entity;
        SendNotification(UpdateMainView, nil);
    }
    NSLog(@"%@",cell.entity.title);
}


-(void)keyUp:(NSNotification *)notifiction{
    NSInteger keyCode =[[notifiction.userInfo objectForKey:@"keyCode"] integerValue];
    //添加(空格键回车)
    if ((keyCode == 49||keyCode==36)&&_selectedCell) {
        [[MainModel share] addNullCell:_selectedCell.entity];
    }else
    //删除（删除键）
    if((keyCode == 51||keyCode==117)&&_selectedCell){
        [[MainModel share] removeCell:_selectedCell.entity];
        
    }
}

@end
