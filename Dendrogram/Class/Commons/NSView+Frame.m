//
//  NSView+Frame.m
//  Dendrogram
//
//  Created by cxh on 17/4/20.
//  Copyright © 2017年 cxh. All rights reserved.
//

#import "NSView+Frame.h"

@implementation NSView(Frame)

#pragma mark point

- (CGFloat)x; {
    return self.origin.x;
}

- (void)setX:(CGFloat)x; {
    self.origin = CGPointMake(x, self.y);
}

- (CGFloat)y; {
    return self.origin.y;
}

- (void)setY:(CGFloat)y; {
    self.origin = CGPointMake(self.x, y);
}

- (CGFloat)maxX; {
    return self.x + self.width;
}

- (void)setMaxX:(CGFloat)maxX; {
    self.x = maxX - self.width;
}

- (CGFloat)maxY; {
    return self.y + self.height;
}

- (void)setMaxY:(CGFloat)maxY; {
    self.y = maxY - self.height;
}

- (CGPoint)origin; {
    return self.frame.origin;
}

- (void)setOrigin:(CGPoint)origin; {
    self.frame = CGRectMake(origin.x, origin.y, self.width, self.height);
}

#pragma mark size

- (CGFloat)width; {
    return self.size.width;
}

- (void)setWidth:(CGFloat)width; {
    self.size = CGSizeMake(width, self.height);
}

- (CGFloat)height; {
    return self.size.height;
}

- (void)setHeight:(CGFloat)height; {
    self.size = CGSizeMake(self.width, height);
}

- (CGSize)size; {
    return self.frame.size;
}

- (void)setSize:(CGSize)size; {
    self.frame = CGRectMake(self.origin.x, self.origin.y, size.width, size.height);
}


@end
