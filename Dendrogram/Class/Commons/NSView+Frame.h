//
//  NSView+Frame.h
//  Dendrogram
//
//  Created by cxh on 17/4/20.
//  Copyright © 2017年 cxh. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface NSView(Frame)
#pragma mark point

@property (assign, nonatomic) CGFloat x;

@property (assign, nonatomic) CGFloat y;



@property (assign, nonatomic) CGFloat maxX;

@property (assign, nonatomic) CGFloat maxY;

@property (assign, nonatomic) CGPoint origin;

#pragma mark size

@property (assign, nonatomic) CGFloat width;

@property (assign, nonatomic) CGFloat height;

@property (assign, nonatomic) CGSize  size;

@end
