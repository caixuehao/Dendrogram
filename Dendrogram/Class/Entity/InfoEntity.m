//
//  InfoEntity.m
//  Dendrogram
//
//  Created by cxh on 17/4/19.
//  Copyright © 2017年 cxh. All rights reserved.
//

#import "InfoEntity.h"

@implementation InfoEntity
-(instancetype)init{
    if (self = [super init]) {
        _rootDendrogram = [[DendrogramEntity alloc] init];
        _rootDendrogram.name = @"root";
    }
    return self;
}

@end
