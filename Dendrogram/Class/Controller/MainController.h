//
//  MainController.h
//  Dendrogram
//
//  Created by cxh on 17/4/20.
//  Copyright © 2017年 cxh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MainController : NSObject

-(void)selectSavePath:(void (^)(NSString* path))handler;

@end
