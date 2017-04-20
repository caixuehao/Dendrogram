//
//  ContentController.h
//  Dendrogram
//
//  Created by cxh on 17/4/20.
//  Copyright © 2017年 cxh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CellView.h"

@interface ContentController : NSObject

@property(nonatomic,weak)CellView* selectedCell;
@property(nonatomic,weak,readonly)DendrogramEntity* selectedEntity;


-(void)addCell:(CellView*)cellView;

@end
