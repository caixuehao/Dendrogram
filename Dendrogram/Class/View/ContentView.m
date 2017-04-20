//
//  ContentView.m
//  Dendrogram
//
//  Created by cxh on 17/4/19.
//  Copyright © 2017年 cxh. All rights reserved.
//

#import "ContentView.h"

#import "Macro.h"
#import <Masonry.h>
#import "DendrogramEntity.h"
#import "MainModel.h"
#import "NSView+Frame.h"

#import "CellView.h"
#import "ContentController.h"
//http://www.maccocoa.com/forum/showthread.php?t=291
@implementation ContentView{
    float cellYSpace;
    float cellXSpace;
    float cellWidth;
    float cellHeight;
    
    float lineWidth;
    
    CGColorRef cellBackground;
    CGColorRef lineColor;
    ContentController* controller;
    
}

-(instancetype)init{
    if (self = [super init]) {
        cellYSpace = 30;
        cellXSpace = 60;
        cellWidth = 80;
        cellHeight = 50;
        
        lineWidth = 2;
        
        cellBackground = CColor(255,200,255,1).CGColor;
        lineColor = CColor(0, 0, 0, 1).CGColor;
        
        controller = [[ContentController alloc] init];
        
        [self loadSubViews];
        [self updateView];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateView) name:UpdateContenView object:nil];
    }
    return self;
}

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}




-(void)updateView{
    
    [[_view subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    //计算宽高
    float height =[self getHeight:[MainModel share].infoEntity.rootDendrogram];
    NSLog(@"高:%f,%f",height,height/(cellHeight + cellYSpace));
    float maxwidth = [self getWidth:[MainModel share].infoEntity.rootDendrogram width:1];
    NSLog(@"宽:%f,%f",maxwidth,maxwidth/(cellWidth+cellXSpace));
    
    if(height>_view.height){
        _view.height = height;
    }
    if (maxwidth>_view.width) {
        _view.width = maxwidth;
    }
    
    [self addCell:[MainModel share].infoEntity.rootDendrogram x:20 y:0];
    
}
/**
 *  添加单元格
 *
 *  @param entity 当前树状图
 *  @param x      左边坐标
 *  @param y      上边坐标
 @  @reture       返回中点Y坐标
 */
-(float)addCell:(DendrogramEntity *)entity x:(float)x y:(float)y{
    
    float height =[self getHeight:entity];
    float celly =_view.height-cellHeight - ((height-cellHeight)/2.0+y);//nsview的原点是左上所以y转了一下
    CellView* cell = [[CellView alloc] initWithEntity:entity];
    cell.frame = NSMakeRect(cellXSpace/2.0+x,celly, cellWidth, cellHeight);
    [_view addSubview:cell];
    [controller addCell:cell];
    //左边的线
    NSView* leftHorizontalLine = [[NSView alloc] initWithFrame:NSMakeRect(x, celly+cellHeight/2.0, cellXSpace/2.0, lineWidth)];
    leftHorizontalLine.wantsLayer = YES;
    leftHorizontalLine.layer.backgroundColor = lineColor;
    [_view addSubview:leftHorizontalLine];
    
    //添加子元素
    float sh = y;
    float topY = 0.0,bottomY = 0.0;
    for (int i= 0 ; i < entity.children.count ; i++) {
        float subcellY = [self addCell:entity.children[i] x:(x+cellXSpace+cellWidth) y:sh];
        if (i == 0) {
            topY = subcellY;
        }else if(i == entity.children.count-1){
            bottomY = subcellY;
        }
        
        sh+=[self getHeight:entity.children[i]];
    }
    
    //右边的线
    if (entity.children.count>0) {
        NSView* rightHorizontalLine = [[NSView alloc] initWithFrame:NSMakeRect(x+cellWidth+cellXSpace/2.0, celly+cellHeight/2.0, cellXSpace/2.0, lineWidth)];
        rightHorizontalLine.wantsLayer = YES;
        rightHorizontalLine.layer.backgroundColor = lineColor;
        [_view addSubview:rightHorizontalLine];
        
        if (entity.children.count>1) {
            NSView* rightVerticallLine = [[NSView alloc] initWithFrame:NSMakeRect(x+cellWidth+cellXSpace,bottomY, lineWidth, topY-bottomY)];
            rightVerticallLine.wantsLayer = YES;
            rightVerticallLine.layer.backgroundColor = lineColor;
            [_view addSubview:rightVerticallLine];
        }

    }
    //用来算连接线坐标
    return celly+cellHeight*0.5;
}





/**
 *  计算最大高度
 *
 *  @param entity 当前树状图
 *
 *  @return 最高处的高度
 */
-(float)getHeight:(DendrogramEntity *)entity{
    int height = 0;
    for (int i= 0 ; i < entity.children.count ; i++) {
        height+=[self getHeight:entity.children[i]];
    }
    return height?height:(cellHeight + cellYSpace);
}
/**
 *  获取深度
 *
 *  @param entity 当前树状图
 *  @param v      当前节点深度 1开始
 *
 *  @return 最深的深度
 */
-(float)getWidth:(DendrogramEntity *)entity width:(int)v{
    int maxwidth = v*(cellWidth+cellXSpace);
    for (int i= 0 ; i < entity.children.count ; i++) {
        float mw = [self getWidth:entity.children[i] width:v+1];
        if (mw>maxwidth) {
            maxwidth = mw;
        }
    }
    return maxwidth?maxwidth:(cellWidth+cellXSpace);
}

-(void)loadSubViews{
    NSScrollView* mainScrView = [[NSScrollView alloc] init];
    [mainScrView setHasVerticalScroller:YES];
    [mainScrView setHasHorizontalScroller:YES];
    [self addSubview:mainScrView];
    
    NSClipView* clipView = [[NSClipView alloc] init];
    [mainScrView addSubview:clipView];
    [mainScrView setContentView:clipView];

    _view = [[NSView alloc]initWithFrame:NSMakeRect(0, 0, DefaultWidth - MinWidth, DefaultHeight-20)];
    [mainScrView addSubview:_view];
    [mainScrView setDocumentView:_view];
    
//    NSImageView* backgroundImage = [[NSImageView alloc] initWithFrame:_view.bounds];
//    [_view addSubview:backgroundImage];
//    backgroundImage.imageAlignment = NSImageAlignTopLeft;
//    backgroundImage.image =  [NSImage imageNamed:@"backgroundImage.jpg"];
    
    //layout
    [mainScrView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}

@end
