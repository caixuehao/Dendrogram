//
//  CellMenuView.m
//  Dendrogram
//
//  Created by cxh on 17/4/19.
//  Copyright © 2017年 cxh. All rights reserved.
//

#import "CellMenuView.h"
#import <Masonry.h>
#import "NSView+Frame.h"
#import "MainModel.h"
#import "Macro.h"
#import "NSScrTextView.h"
#import "NSTip.h"

@implementation CellMenuView{
    NSTextField* titleTF;
    NSScrTextView* scrTextView;
    NSScrTextView* logScrTextView;
    NSButton* okbtn;
}
-(instancetype)init{
    if (self = [super init]) {
        [self loadSubViews];
         [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateView) name:SelectedCellChange object:nil];
    }
    return self;
}
-(void)updateView{
    self.entity = [MainModel share].selectedEntity;
    okbtn.target = self;
    [okbtn setAction:@selector(saveModify)];
}

-(void)saveModify{
    if(_entity == NULL)return;
    
    NSData* jsondata = [scrTextView.textView.string dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    NSDictionary* indic = [NSJSONSerialization JSONObjectWithData:jsondata options:NSJSONReadingMutableLeaves error:&error];
    //判断格式
    if (error) {
        NSLog(@"Error:%@",[error localizedDescription]);
        [NSTip ShowTip:[error localizedDescription] title:@"输入格式错误"];
        return;
    }
    
    logScrTextView.string = @"";
    //判断数据类型
   [self comparedDictionary:indic sourcedic:[MainModel share].infoEntity.sourceData];
    if(logScrTextView.string.length>0){
        [NSTip ShowTip:@"" title:@"请检查错误"];
        return;
    }
    //复制字典将全该成可变的
    NSMutableDictionary* outdic = [[NSMutableDictionary alloc] init];
    [self traversalCopyDictionary:indic outdic:outdic];
    //给缺少的赋空值
    [self traversalCopyNUll:outdic sourcedic:[MainModel share].infoEntity.sourceData];
    
    
    
    _entity.data = outdic;
    if ([_entity.title isEqualToString:titleTF.stringValue] == NO) {
        _entity.title = titleTF.stringValue;
        SendNotification(UpdateContenView, nil);
    }

}
//判断数据类型
-(void)comparedDictionary:(NSDictionary*)indic sourcedic:(NSMutableDictionary*)sourcedic{
    for (NSString* key in indic) {
        id value = [indic objectForKey:key];
        if ([value isKindOfClass:[NSDictionary class]]||[value isKindOfClass:[NSMutableDictionary class]]) {
            if([sourcedic objectForKey:key]){
                if ([[sourcedic objectForKey:key] isKindOfClass:[NSMutableDictionary class]]) {
                    [self comparedDictionary:[indic objectForKey:key] sourcedic:[sourcedic objectForKey:key]];
                }else{
                     logScrTextView.string = [NSString stringWithFormat:@"%@%@字段应为字典类型。\n",logScrTextView.string,key];
                }
            }else{
                logScrTextView.string = [NSString stringWithFormat:@"%@多余字典：%@\n",logScrTextView.string,key];
            }
        }else{
            if([sourcedic objectForKey:key]){
                switch ([[sourcedic objectForKey:key] integerValue]) {
                    case DataTypeNumber:
                        if ([value isKindOfClass:[NSNumber class]] == NO) {
                            logScrTextView.string = [NSString stringWithFormat:@"%@%@字段应为数字。\n",logScrTextView.string,key];
                        }
                        break;
                    case DataTypeString:
                        if([value isKindOfClass:[NSString class]] == NO){
                            logScrTextView.string = [NSString stringWithFormat:@"%@%@字段应为字符串。\n",logScrTextView.string,key];
                        }
                        break;
                    case DataTypeNumBerArr:
                        if(([value isKindOfClass:[NSArray class]]||[value isKindOfClass:[NSMutableArray class]])==NO){
                            logScrTextView.string = [NSString stringWithFormat:@"%@%@字段应为数组。\n",logScrTextView.string,key];
                        }else{
                            NSArray* arr = value;
                            if (arr.count>0&&[[arr firstObject] isKindOfClass:[NSNumber class]]==NO) {
                                logScrTextView.string = [NSString stringWithFormat:@"%@%@字段应为数字数组。\n",logScrTextView.string,key];
                            }
                        }
                        break;
                    case DataTypeStringArr:
                        if(([value isKindOfClass:[NSArray class]]||[value isKindOfClass:[NSMutableArray class]])==NO){
                            logScrTextView.string = [NSString stringWithFormat:@"%@%@字段应为数组。\n",logScrTextView.string,key];
                        }else{
                            NSArray* arr = value;
                            if (arr.count>0&&[[arr firstObject] isKindOfClass:[NSString class]]==NO) {
                                logScrTextView.string = [NSString stringWithFormat:@"%@%@字段应为字符串数组。\n",logScrTextView.string,key];
                            }
                        }
                        break;
                }
                
            }else{
                logScrTextView.string = [NSString stringWithFormat:@"%@多余字段：%@\n",logScrTextView.string,key];
            }
        
        }
    }
   
}

//遍历复制字典
-(void)traversalCopyDictionary:(NSDictionary*)indic outdic:(NSMutableDictionary*)outdic{
    for (NSString* key in indic) {
        if ([[indic objectForKey:key] isKindOfClass:[NSDictionary class]]||[[indic objectForKey:key] isKindOfClass:[NSMutableDictionary class]]) {
            [outdic setObject:[[NSMutableDictionary alloc] init] forKey:key];
            [self traversalCopyDictionary:[indic objectForKey:key] outdic:[outdic objectForKey:key]];
        }else{
            [outdic setValue:[indic objectForKey:key] forKey:key];
        }
    }
}

//给缺少的赋空值
-(void)traversalCopyNUll:(NSMutableDictionary*)outdic sourcedic:(NSMutableDictionary*)sourcedic{
    for (NSString* key in sourcedic) {
        if ([[sourcedic objectForKey:key] isKindOfClass:[NSMutableDictionary class]]) {
            if ([outdic objectForKey:key] == NULL) {
                [outdic setValue:[[NSMutableDictionary alloc] init] forKey:key];
            }
            [self traversalCopyNUll:[outdic objectForKey:key] sourcedic:[sourcedic objectForKey:key]];
        }else{
            if ([outdic objectForKey:key] == NULL) {
                switch ([[sourcedic objectForKey:key] integerValue]) {
                    case DataTypeNumber:
                        [outdic setObject:@0 forKey:key];
                        break;
                    case DataTypeString:
                        [outdic setObject:@"" forKey:key];
                        break;
                    case DataTypeNumBerArr:
                        [outdic setObject:[[NSMutableArray alloc] init] forKey:key];
                        break;
                    case DataTypeStringArr:
                        [outdic setObject:[[NSMutableArray alloc] init] forKey:key];
                        break;
                }
            }
        }
    }
}



-(void)setEntity:(DendrogramEntity *)entity{
    _entity = entity;
    if (entity) {
        titleTF.stringValue = entity.title;
        NSData* jsondata = [NSJSONSerialization dataWithJSONObject:_entity.data options:NSJSONWritingPrettyPrinted error:nil];
        scrTextView.textView.string = [[NSString alloc] initWithData:jsondata encoding:NSUTF8StringEncoding];
    }
}
-(void)loadSubViews{
    titleTF = ({
        NSTextField* tf = [[NSTextField alloc] init];
        [self addSubview:tf];
        tf;
    });
    
    scrTextView =({
        NSScrTextView* st = [[NSScrTextView alloc] init];
        [self addSubview:st];
        st;
    });
    logScrTextView =({
        NSScrTextView* st = [[NSScrTextView alloc] init];
        st.textView.editable = NO;
        [self addSubview:st];
        st;
    });
    okbtn = ({
        NSButton* btn = [[NSButton alloc] init];
        [btn setTitle:@"保存修改"];
        [self addSubview:btn];
        btn;
    });
    
    [titleTF mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(10);
        make.left.right.equalTo(self);
        make.height.equalTo(@25);
    }];
    
    [scrTextView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleTF.mas_bottom).offset(10);
        make.left.right.equalTo(self);
        make.bottom.equalTo(self).offset(-170);
    }];
    [logScrTextView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(scrTextView.mas_bottom).offset(10);
        make.left.right.equalTo(self);
        make.height.equalTo(@110);
    }];
    [okbtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.centerX.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(200, 40));
    }];
}
@end
