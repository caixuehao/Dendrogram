//
//  MainModel.h
//  Dendrogram
//
//  Created by cxh on 17/4/19.
//  Copyright © 2017年 cxh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "InfoEntity.h"

@interface MainModel : NSObject

//当前编辑的文件路径
@property(nonatomic,strong)NSString* filePath;

@property(nonatomic,strong)InfoEntity* infoEntity;

@property(nonatomic,weak,readonly)DendrogramEntity* rootDendrogram;

+(MainModel*)share;

//添加一个空节点
-(DendrogramEntity*)addNullCell:(DendrogramEntity*)entity;
//删除一个节点
-(void)removeCell:(DendrogramEntity*)entity;

-(void)saveFile;
@end
