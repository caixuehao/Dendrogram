//
//  MainModel.m
//  Dendrogram
//
//  Created by cxh on 17/4/19.
//  Copyright © 2017年 cxh. All rights reserved.
//

#import "MainModel.h"

static MainModel *mainModelShare;

@implementation MainModel

+(instancetype)share{
    if (mainModelShare == nil) {
        mainModelShare = [[MainModel alloc] init];
    }
    return mainModelShare;
}

-(instancetype)init{
    if (self = [super init]) {
        _infoEntity = [[InfoEntity alloc] init];
        for (int i = 0; i < 3; i++) {
            DendrogramEntity* de = [[DendrogramEntity alloc] init];
            de.name = [NSString stringWithFormat:@"children%d",i];
            [_infoEntity.rootDendrogram.children addObject:de];
        }
        [_infoEntity.rootDendrogram.children[0].children addObject:[[DendrogramEntity alloc] init]];
        [_infoEntity.rootDendrogram.children[0].children addObject:[[DendrogramEntity alloc] init]];
        [_infoEntity.rootDendrogram.children[1].children addObject:[[DendrogramEntity alloc] init]];
        [_infoEntity.rootDendrogram.children[1].children[0].children addObject:[[DendrogramEntity alloc] init]];
        
    }
    [self addParentCellData:self.rootDendrogram];
    return self;
}

-(DendrogramEntity*)rootDendrogram{
    return _infoEntity.rootDendrogram;
}
//添加父节点数据
-(void)addParentCellData:(DendrogramEntity*)entity{
    for (int i = 0;i < entity.children.count;i++) {
        entity.children[i].parentCell = entity;
        [self addParentCellData:entity.children[i]];
    }
}



-(DendrogramEntity*)addNullCell:(DendrogramEntity*)entity{
    DendrogramEntity* de = [[DendrogramEntity alloc] init];
    de.name = [NSString stringWithFormat:@"children%lu",entity.children.count];
    [entity.children addObject:de];
    de.parentCell = entity;
    return de;    
}

-(void)removeCell:(DendrogramEntity*)entity{
    [entity.parentCell.children removeObject:entity];
}

//保存文件
-(void)saveFile{

}
@end
