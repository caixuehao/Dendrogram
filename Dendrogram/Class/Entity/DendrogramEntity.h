//
//  DendrogramEntity.h
//  Dendrogram
//
//  Created by cxh on 17/4/19.
//  Copyright © 2017年 cxh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DendrogramEntity : NSObject

@property(nonatomic,strong)NSString* name;

@property(nonatomic,strong)NSMutableDictionary* data;

@property(nonatomic,strong)NSMutableArray<DendrogramEntity *>* children;

@property(nonatomic,weak)DendrogramEntity * parentCell;

@end
