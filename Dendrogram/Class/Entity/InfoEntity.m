//
//  InfoEntity.m
//  Dendrogram
//
//  Created by cxh on 17/4/19.
//  Copyright © 2017年 cxh. All rights reserved.
//

#import "InfoEntity.h"
#import "Macro.h"

@implementation InfoEntity
-(instancetype)init{
    if (self = [super init]) {
        _rootDendrogram = [[DendrogramEntity alloc] init];
        _rootDendrogram.title = @"root";
        _sourceData = [[NSMutableDictionary alloc] init];
        _dataTypeNameArr = @[@"数字",@"字符串",@"数字数组",@"字符串数组",@"字典"];
        [self updata];
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
        [self updata];
    }
    return self;
}

-(void)updata{
    _dicKeyArr = [[NSMutableArray alloc] initWithArray:@[@"root"]];
    [_dicKeyArr addObjectsFromArray:[self getDicArr:_sourceData rootKey:@"root"]];
    _allKeyArr = [[NSMutableArray alloc] init];
    [_allKeyArr addObjectsFromArray:[self getAllKeyArr:_sourceData rootkey:@"root"]];
}

-(NSArray<NSString*>*)getAllKeyArr:(NSDictionary*)dic rootkey:(NSString*)rootkey{
     NSMutableArray<NSString *>* keyArr = [[NSMutableArray alloc] init];
    for (NSString* key in dic) {
        NSString* str =[NSString stringWithFormat:@"%@%@%@",rootkey,ComponentsSeparatedByString,key];
        [keyArr addObject:str];
        if ([[dic objectForKey:key] isKindOfClass:[NSDictionary class]]||[[dic objectForKey:key] isKindOfClass:[NSMutableDictionary class]]) {
            [keyArr addObjectsFromArray:[self getAllKeyArr:[dic objectForKey:key] rootkey:str]];
        }
    }
    return keyArr;
}

-(NSArray<NSString*>*)getDicArr:(NSDictionary*)dic rootKey:(NSString*)rootkey{
    NSMutableArray<NSString *>* dicKeyArr = [[NSMutableArray alloc] init];
    for (NSString* key in dic) {
        if ([[dic objectForKey:key] isKindOfClass:[NSDictionary class]]||[[dic objectForKey:key] isKindOfClass:[NSMutableDictionary class]]) {
            NSString* str =[NSString stringWithFormat:@"%@%@%@",rootkey,ComponentsSeparatedByString,key];
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
