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

-(NSMutableDictionary*)getSaveDic{
    NSMutableDictionary* maindic = [[NSMutableDictionary alloc] init];
    [maindic setObject:_title forKey:@"title"];
    for (NSString* key in _data) {
        [maindic setObject:[_data objectForKey:key] forKey:key];
    }
    NSMutableArray<NSMutableDictionary *>* savechildren = [[NSMutableArray alloc] init];
    for (int i =0;i < _children.count;i++) {
        [savechildren addObject:[_children[i] getSaveDic]];
    }
    [maindic setObject:savechildren forKey:@"children"];
    return maindic;
}
@end
