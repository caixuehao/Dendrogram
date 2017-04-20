//
//  DendrogramEntity.m
//  Dendrogram
//
//  Created by cxh on 17/4/19.
//  Copyright © 2017年 cxh. All rights reserved.
//

#import "DendrogramEntity.h"

@implementation DendrogramEntity
-(instancetype)init{
    if (self = [super init]) {
        _data = [[NSMutableDictionary alloc] init];
        _children = [[NSMutableArray alloc] init];
    }
    return self;
}
@end
