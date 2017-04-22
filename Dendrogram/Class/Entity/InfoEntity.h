//
//  InfoEntity.h
//  Dendrogram
//
//  Created by cxh on 17/4/19.
//  Copyright © 2017年 cxh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DendrogramEntity.h"

typedef NS_ENUM(NSInteger,DataType){
    DataTypeNumber = 0,
    DataTypeString = 1,
    DataTypeNumBerArr = 2,
    DataTypeStringArr = 3,
    DataTypeDictionary = 4
};

@interface InfoEntity : NSObject

@property(nonatomic,strong)DendrogramEntity* rootDendrogram;

@property(nonatomic,strong)NSMutableDictionary* sourceData;

@property(nonatomic,strong,readonly)NSArray<NSString*>* dataTypeNameArr;

@property(nonatomic,strong,readonly)NSMutableArray<NSString*>* dicKeyArr;

-(void)save:(NSString*)path;

-(instancetype)initWithFile:(NSString*)path;

-(void)updataSourceDataDicArr;

@end
