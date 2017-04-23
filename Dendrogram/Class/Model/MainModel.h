//
//  MainModel.h
//  Dendrogram
//
//  Created by cxh on 17/4/19.
//  Copyright © 2017年 cxh. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "InfoEntity.h"
#import "ContentController.h"

@interface MainModel : NSObject

//当前编辑的文件路径
@property(nonatomic,strong)NSString* filePath;

@property(nonatomic,strong)InfoEntity* infoEntity;

@property(nonatomic,weak,readonly)DendrogramEntity* rootDendrogram;

@property(nonatomic,weak)ContentController* contentController;

@property(nonatomic,weak,readonly)DendrogramEntity* selectedEntity;
//数据类型数组
@property(nonatomic,strong,readonly)NSArray<NSString*>* dataTypeNameArr;
//源数据中的字典数组
@property(nonatomic,strong,readonly)NSArray<NSString*>* dicKeyArr;

+(MainModel*)share;

//添加一个空节点
-(DendrogramEntity*)addNullCell:(DendrogramEntity*)entity;
//删除一个节点
-(void)removeCell:(DendrogramEntity*)entity;

//存取文件
-(void)saveFile;
-(void)readFile:(NSString*)path;

//添加字段
-(void)addkey:(NSString*)key  dataType:(NSInteger)dataType rootDic:(NSString*)rootDic;


@end
