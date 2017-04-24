//
//  NSTip.h
//  Dendrogram
//
//  Created by C on 17/4/22.
//  Copyright © 2017年 cxh. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface NSTip : NSObject

+(void)ShowTip:(NSString*)tip title:(NSString*)title;

+(void)ShowTip2:(NSString*)tip title:(NSString*)title handler:(void (^)())handler;
@end
