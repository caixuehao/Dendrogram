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

-(instancetype)initWithDic:(NSDictionary*)maindic{
    if (self = [super init]) {
        if(maindic == NULL)return NULL;
        
        _data = [[NSMutableDictionary alloc] initWithDictionary:maindic];
        
        _title = [maindic objectForKey:@"title"];
        if (_title == NULL) return NULL;
        [_data removeObjectForKey:@"title"];
        NSLog(@"title:%@",_title);
        
        NSArray<NSMutableDictionary*> *savechildren= [_data objectForKey:@"children"];
        if (savechildren == NULL) return NULL;
         _children = [[NSMutableArray alloc] init];
        for (int i = 0; i < savechildren.count; i++) {
            DendrogramEntity* subEntity = [[DendrogramEntity alloc] initWithDic:savechildren[i]];
            if (subEntity == NULL) return NULL;
            [_children addObject:subEntity];
        }
            
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
