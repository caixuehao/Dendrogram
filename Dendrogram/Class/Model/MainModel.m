//
//  MainModel.m
//  Dendrogram
//
//  Created by cxh on 17/4/19.
//  Copyright © 2017年 cxh. All rights reserved.
//

#import "MainModel.h"
#import "Macro.h"
#import "NSTip.h"

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
-(NSArray<NSString*>*)dicKeyArr{
    return _infoEntity.dicKeyArr;
}
-(NSArray<NSString*>*)allKeyArr{
    return _infoEntity.allKeyArr;
}
//添加父节点数据
-(void)addParentCellData:(DendrogramEntity*)entity{
    for (int i = 0;i < entity.children.count;i++) {
        entity.children[i].parentCell = entity;
        [self addParentCellData:entity.children[i]];
    }
}
//添加节点
-(DendrogramEntity*)addNullCell:(DendrogramEntity*)entity{
    if (entity) {
        DendrogramEntity* de = [[DendrogramEntity alloc] initWithSourceData:_infoEntity.sourceData];
        de.title = [NSString stringWithFormat:@"children%lu",entity.children.count];
        [entity.children addObject:de];
        de.parentCell = entity;
        SendNotification(UpdateContenView, nil);
        return de;
    }
    return nil;
}
//移除节点
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


//遍历树
-(void)traversalDendrogramEntity:(DendrogramEntity*)entity handler:(void (^)(DendrogramEntity* entity))handler{
    if (handler)  handler(entity);
    for (int i =0; i < entity.children.count; i++) {
        [self traversalDendrogramEntity:entity.children[i] handler:handler];
    }
}

//添加一个空节点
-(void)addkey:(NSString*)key  dataType:(NSInteger)dataType rootDic:(NSString*)rootDic{
    if ([key isEqualToString:TitleKey]||[key isEqualToString:ChildrenKey]) {
        [NSTip ShowTip:@"与保留字段冲突" title:@"重复添加"];
        return;
    }
    if (key.length == 0) {
        return;
    }
    
    NSArray* keyarr = [rootDic componentsSeparatedByString:ComponentsSeparatedByString];
    NSMutableDictionary* tmpDic = _infoEntity.sourceData;
    for (int i = 1; i < keyarr.count; i++) {
        tmpDic = [tmpDic objectForKey:keyarr[i]];
    }
    if ([tmpDic objectForKey:key] == NULL) {
        if (dataType == DataTypeDictionary) {
            [tmpDic setObject:[[NSMutableDictionary alloc] init] forKey:key];
        }else{
            [tmpDic setObject:@(dataType) forKey:key];
        }
        [_infoEntity updata];
        SendNotification(UpdateMainView, nil);
    }else{
        [NSTip ShowTip:@"已经有该字段了" title:@"重复添加"];
        return;
    }
    
    
    //子节点
    [self traversalDendrogramEntity:self.rootDendrogram handler:^(DendrogramEntity *entity) {
        NSMutableDictionary* datadic = entity.data;
        NSArray* dickeyarr = [rootDic componentsSeparatedByString:ComponentsSeparatedByString];
        for (int i = 1; i < dickeyarr.count; i++) {
            if ([datadic objectForKey:dickeyarr[i]]) {
                datadic = [datadic objectForKey:dickeyarr[i]];
            }else{
                NSLog(@"%@:数据不匹配",entity.title);return;
            }
        }
        switch (dataType) {
            case DataTypeNumber:
                [datadic setObject:@0 forKey:key];
                break;
            case DataTypeString:
                [datadic setObject:@"" forKey:key];
                break;
            case DataTypeNumBerArr:
                [datadic setObject:[[NSMutableArray alloc] init] forKey:key];
                break;
            case DataTypeStringArr:
                 [datadic setObject:[[NSMutableArray alloc] init] forKey:key];
                break;
            case DataTypeDictionary:
                [datadic setObject:[[NSMutableDictionary alloc] init] forKey:key];
                break;
        }
    }];
    SendNotification(SelectedCellChange, nil);
}
//删除一个节点
-(void)delkey:(NSString *)key{
    if (key.length<@"root".length) return;
    
    
    [NSTip ShowTip2:@"删除字段" title:@"删除不可恢复" handler:^{
        NSArray* keyarr = [key componentsSeparatedByString:ComponentsSeparatedByString];
        NSMutableDictionary* tmpDic = _infoEntity.sourceData;
        for (int i = 1; i < keyarr.count-1; i++) {
            tmpDic = [tmpDic objectForKey:keyarr[i]];
        }
        [tmpDic removeObjectForKey:[keyarr lastObject]];
        [_infoEntity updata];
        SendNotification(UpdateMainView, nil);
        
        //子节点
        [self traversalDendrogramEntity:self.rootDendrogram handler:^(DendrogramEntity *entity) {
            NSMutableDictionary* datadic = entity.data;
            NSArray* keyarr = [key componentsSeparatedByString:ComponentsSeparatedByString];
            for (int i = 1; i < keyarr.count-1; i++) {
                if ([datadic objectForKey:keyarr[i]]) {
                    datadic = [datadic objectForKey:keyarr[i]];
                }else{
                    NSLog(@"%@:数据不匹配",entity.title);return;
                }
            }
            [datadic removeObjectForKey:[keyarr lastObject]];
        }];
        SendNotification(SelectedCellChange, nil);
    }];
    
}

//修改字段
-(void)modify:(NSString*)oldkey newkey:(NSString*)newkey rootDic:(NSString*)rootDic{
    if (newkey.length == 0||oldkey.length == 0)return;
    if ([newkey isEqualToString:TitleKey]||[newkey isEqualToString:ChildrenKey]) {
        [NSTip ShowTip:@"与保留字段冲突" title:@"不能修改"];
        return;
    }
    
    NSArray<NSString*>* oldkeyarr = [oldkey componentsSeparatedByString:ComponentsSeparatedByString];
    NSMutableDictionary* oldTmpDic = _infoEntity.sourceData;
    for (int i = 1; i < oldkeyarr.count-1; i++) {
        oldTmpDic = [oldTmpDic objectForKey:oldkeyarr[i]];
    }
   
    //添加
    NSArray* newkeyarr = [rootDic componentsSeparatedByString:ComponentsSeparatedByString];
    //判断是否移动了字典的位置
    if([[oldTmpDic objectForKey:[oldkeyarr lastObject]] isKindOfClass:[NSMutableDictionary class]]){
        NSString* oldrootDic =[oldkey substringToIndex:oldkey.length-[oldkeyarr lastObject].length-1];
        NSLog(@"%@",oldrootDic);
        if ([oldrootDic isEqualToString:rootDic] == NO) {
            [NSTip ShowTip:@"不能修改字典的位置" title:@"不能修改"];
            return;
        }
    }
    
    NSMutableDictionary* newTmpDic = _infoEntity.sourceData;
    for (int i = 1; i < newkeyarr.count; i++) {
        newTmpDic = [newTmpDic objectForKey:newkeyarr[i]];
    }
    if ([newTmpDic objectForKey:newkey] == NULL) {
        [newTmpDic setObject:[oldTmpDic objectForKey:[oldkeyarr lastObject]] forKey:newkey];
        [_infoEntity updata];
        SendNotification(UpdateMainView, nil);
    }else{
        [NSTip ShowTip:@"已经有该字段了" title:@"不能修改"];
        return;
    }
    //删除
    [oldTmpDic removeObjectForKey:[oldkeyarr lastObject]];
    
    [_infoEntity updata];
    SendNotification(UpdateMainView, nil);
    
    
    
    //子节点
    [self traversalDendrogramEntity:self.rootDendrogram handler:^(DendrogramEntity *entity) {
        NSMutableDictionary* olddic =  entity.data;
        for (int i = 1; i < oldkeyarr.count-1; i++) {
            olddic = [olddic objectForKey:oldkeyarr[i]];
        }

        NSMutableDictionary* newdic =  entity.data;
        for (int i = 1; i < newkeyarr.count; i++) {
            newdic = [newdic objectForKey:newkeyarr[i]];
        }
        [newdic setObject:[olddic objectForKey:[oldkeyarr lastObject]] forKey:newkey];
        [olddic removeObjectForKey:[oldkeyarr lastObject]];
        
    }];
    SendNotification(SelectedCellChange, nil);

}

@end
