//
//  MainModel.m
//  Dendrogram
//
//  Created by cxh on 17/4/19.
//  Copyright © 2017年 cxh. All rights reserved.
//

#import "MainModel.h"
#import "Macro.h"
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
      [self addParentCellData:self.rootDendrogram];
        _filePath = @"";
        
    }
    
    return self;
}

-(DendrogramEntity*)rootDendrogram{
    return _infoEntity.rootDendrogram;
}
-(DendrogramEntity*)selectedEntity{
    return _contentController.selectedEntity;
}
-(void)setFilePath:(NSString *)filePath{
    _filePath = filePath;
    SendNotification(UpdateMainView, nil);
}
-(NSArray<NSString*>*)dataTypeNameArr{
  return  _infoEntity.dataTypeNameArr;
}
-(NSArray<NSString*>*)sourceDataDicArr{
    return _infoEntity.sourceDataDicArr;
}
//添加父节点数据
-(void)addParentCellData:(DendrogramEntity*)entity{
    for (int i = 0;i < entity.children.count;i++) {
        entity.children[i].parentCell = entity;
        [self addParentCellData:entity.children[i]];
    }
}
//添加移除节点
-(DendrogramEntity*)addNullCell:(DendrogramEntity*)entity{
    if (entity) {
        DendrogramEntity* de = [[DendrogramEntity alloc] init];
        de.title = [NSString stringWithFormat:@"children%lu",entity.children.count];
        [entity.children addObject:de];
        de.parentCell = entity;
        SendNotification(UpdateContenView, nil);
        return de;
    }
    return nil;
}
-(void)removeCell:(DendrogramEntity*)entity{
    if(entity.parentCell){
        [entity.parentCell.children removeObject:entity];
        SendNotification(UpdateContenView, nil);
        SendNotification(UpdateMainView, nil);
    }
}

//保存文件
-(void)saveFile{
    [_infoEntity save:_filePath];
}
//读取文件
-(void)readFile:(NSString*)path{
    InfoEntity* entity = [[InfoEntity alloc] initWithFile:path];
    if (entity) {
        _infoEntity = entity;
        _filePath = path;
        [self addParentCellData:self.rootDendrogram];
        SendNotification(UpdateContenView, nil);
        SendNotification(UpdateMainView, nil);
    }else{
        NSLog(@"文件不对");
    }
}


//数据模版


@end
