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
    }
    return self;
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
