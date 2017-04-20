//
//  CellView.m
//  Dendrogram
//
//  Created by cxh on 17/4/20.
//  Copyright © 2017年 cxh. All rights reserved.
//

#import "CellView.h"
#import "Macro.h"

@implementation CellView
-(instancetype)initWithEntity:(DendrogramEntity*)entity{
    if (self = [super init]) {
        self.wantsLayer = YES;
        
        self.isselected = NO;
        self.entity = entity;
    }
    return self;
}

-(void)setIsselected:(BOOL)isselected{
    if (isselected) {
        ((NSButtonCell*)self.cell).backgroundColor = CColor(255, 200, 255, 1);
    }else{
        ((NSButtonCell*)self.cell).backgroundColor = CColor(200, 200, 255, 1);
    }
    _isselected = isselected;
    
}

-(void)setEntity:(DendrogramEntity *)entity{
    _entity = entity;
    [self setTitle:entity.title];
    
}


@end
