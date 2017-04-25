//
//  NSScrTextView.m
//  Dendrogram
//
//  Created by cxh on 17/4/24.
//  Copyright © 2017年 cxh. All rights reserved.
//

#import "NSScrTextView.h"

@implementation NSScrTextView
-(instancetype)init{
    if (self = [super init]) {
        [self setHasVerticalScroller:YES];
//        [self setHasHorizontalScroller:YES];
      
        NSClipView* clipView = [[NSClipView alloc] init];
        [self addSubview:clipView];
        [self setContentView:clipView];
        
        _textView = [[NSTextView alloc] init];
        [self addSubview:_textView];
        [self setDocumentView:_textView];
    }
    return self;
}
-(void)setFrame:(NSRect)frame{
    [super setFrame:frame];
    frame.size.width-=20;
    if (_textView.frame.size.height>frame.size.height) {
        frame.size.height = _textView.frame.size.height;
    }
//    [self setHasVerticalScroller:YES];
    _textView.frame = frame;
    
}

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}
-(void)setString:(NSString *)string{
    _textView.string = string;
}
-(NSString*)string{
    return _textView.string;
}
@end
