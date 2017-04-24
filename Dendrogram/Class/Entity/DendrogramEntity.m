//
//  DendrogramEntity.m
//  Dendrogram
//
//  Created by cxh on 17/4/19.
//  Copyright © 2017年 cxh. All rights reserved.
//

#import "DendrogramEntity.h"
#import "Macro.h"
#import "InfoEntity.h"

@implementation DendrogramEntity
-(instancetype)init{
    if (self = [super init]) {
        _data = [[NSMutableDictionary alloc] init];
        _children = [[NSMutableArray alloc] init];
    }
    return self;
}
-(instancetype)initWithSourceData:(NSMutableDictionary*)sourceData{
    if (self = [super init]) {
        _data = [[NSMutableDictionary alloc] init];
        _children = [[NSMutableArray alloc] init];
        [self copydata:sourceData mydata:_data];
    }
    return self;
}

-(void)copydata:(NSDictionary*)indata mydata:(NSMutableDictionary*)mydata{
    for (NSString* key in indata) {
        if ([[indata objectForKey:key] isKindOfClass:[NSMutableDictionary class]]) {
            [mydata setObject:[[NSMutableDictionary alloc] init] forKey:key];
            [self copydata:[indata objectForKey:key] mydata:[mydata objectForKey:key]];
        }else if([[indata objectForKey:key] isKindOfClass:[NSNumber class]]){
            switch ([[indata objectForKey:key] integerValue]) {
                case DataTypeNumber:
                    [mydata setObject:@0 forKey:key];
                    break;
                case DataTypeString:
                    [mydata setObject:@"" forKey:key];
                    break;
                case DataTypeNumBerArr:
                    [mydata setObject:[[NSMutableArray alloc] init] forKey:key];
                    break;
                case DataTypeStringArr:
                    [mydata setObject:[[NSMutableArray alloc] init] forKey:key];
                    break;
                default:
                    break;
            }
        }
    }
}

-(instancetype)initWithDic:(NSDictionary*)maindic{
    if (self = [super init]) {
        if(maindic == NULL)return NULL;
        
        _data = [[NSMutableDictionary alloc] initWithDictionary:maindic];
        
        _title = [maindic objectForKey:TitleKey];
        if (_title == NULL) return NULL;
        [_data removeObjectForKey:TitleKey];
        NSLog(@"title:%@",_title);
        
        NSArray<NSMutableDictionary*> *savechildren= [_data objectForKey:ChildrenKey];
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
    [maindic setObject:_title forKey:TitleKey];
    for (NSString* key in _data) {
        [maindic setObject:[_data objectForKey:key] forKey:key];
    }
    NSMutableArray<NSMutableDictionary *>* savechildren = [[NSMutableArray alloc] init];
    for (int i =0;i < _children.count;i++) {
        [savechildren addObject:[_children[i] getSaveDic]];
    }
    [maindic setObject:savechildren forKey:ChildrenKey];
    return maindic;
}
@end
