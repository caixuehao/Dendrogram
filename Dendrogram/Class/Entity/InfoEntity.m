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
        _rootDendrogram.title = @"root";
        _sourceData = [[NSMutableDictionary alloc] init];
        _dataTypeNameArr = @[@"数字",@"字符串",@"数字数组",@"字符串数组",@"字典"];
    }
    return self;
}

-(instancetype)initWithFile:(NSString*)path{
    if (self = [super init]) {
        NSDictionary* maindic = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:path] options:NSJSONReadingMutableLeaves error:nil];
        _sourceData = [maindic objectForKey:@"sourceData"];
        if (_sourceData == NULL) {
            return NULL;
        }
        _rootDendrogram = [[DendrogramEntity alloc] initWithDic:[maindic objectForKey:@"rootDendrogram"]];
        if (_rootDendrogram == NULL) {
            return NULL;
        }
    }
    return self;
}



-(void)updataDicArr{
    _dicKeyArr = [[NSMutableArray alloc] initWithArray:@[@"root"]];
    [_dicKeyArr addObjectsFromArray:[self getDicArr:_sourceData rootKey:@"root"]];
}

-(NSArray<NSString*>*)getDicArr:(NSDictionary*)dic rootKey:(NSString*)rootkey{
    NSMutableArray<NSString *>* dicKeyArr = [[NSMutableArray alloc] init];
    for (NSString* key in dic) {
        if ([dic isKindOfClass:[NSDictionary class]]) {
            NSString* str =[NSString stringWithFormat:@"%@.%@",rootkey,key];
            [dicKeyArr addObject:str];
            [dicKeyArr addObjectsFromArray:[self getDicArr:[dic objectForKey:key] rootKey:str]];
        }
    }
    return dicKeyArr;
}



-(void)save:(NSString*)path{
    NSMutableDictionary* maindic = [[NSMutableDictionary  alloc] init];
    [maindic setObject:_sourceData forKey:@"sourceData"];
    [maindic setObject:[_rootDendrogram getSaveDic] forKey:@"rootDendrogram"];
    NSLog(@"%@",maindic);
    NSData* jsondata = [NSJSONSerialization dataWithJSONObject:maindic options:NSJSONWritingPrettyPrinted error:nil];
    [jsondata writeToFile:path atomically:YES];
}
@end
