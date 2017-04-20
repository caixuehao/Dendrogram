//
//  CellView.h
//  Dendrogram
//
//  Created by cxh on 17/4/20.
//  Copyright © 2017年 cxh. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "DendrogramEntity.h"

@interface CellView : NSButton

@property(nonatomic,strong)DendrogramEntity* entity;

@property(nonatomic,assign)BOOL isselected;

-(instancetype)initWithEntity:(DendrogramEntity*)entity;

@end
