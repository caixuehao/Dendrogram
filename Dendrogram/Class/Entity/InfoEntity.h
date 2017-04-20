//
//  InfoEntity.h
//  Dendrogram
//
//  Created by cxh on 17/4/19.
//  Copyright © 2017年 cxh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DendrogramEntity.h"
@interface InfoEntity : NSObject


@property(nonatomic,strong)DendrogramEntity* rootDendrogram;

@property(nonatomic,strong)NSMutableDictionary* sourceData;

-(void)save:(NSString*)path;

@end
