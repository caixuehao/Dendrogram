//
//  NSScrTextView.h
//  Dendrogram
//
//  Created by cxh on 17/4/24.
//  Copyright © 2017年 cxh. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface NSScrTextView : NSScrollView

@property(nonatomic,strong)NSTextView* textView;

@property(nonatomic,weak)NSString* string;

@end
