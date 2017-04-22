//
//  Macro.h
//  Dendrogram
//
//  Created by cxh on 17/4/19.
//  Copyright © 2017年 cxh. All rights reserved.
//

#ifndef Macro_h
#define Macro_h

#define FileTypeName @"json"

#define SSize   [NSScreen mainScreen].frame.size

#define DefaultWidth 1000
#define DefaultHeight 618
#define MinWidth 530
#define MinHeight 618



#pragma mark - Color

#define CColor(r,g,b,a) [NSColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
#define CColorRGB [NSColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0]


#pragma Notification

#define SendNotification(name,userinfo)  [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:name object:nil userInfo:userinfo]]

#define KeyUpEvent @"KeyUpEvent"
#define UpdateContenView @"UpdateContenView"
#define UpdateMainView @"UpdateMainView"
#define SelectedCellChange @"SelectedCellChange"


#endif /* Macro_h */
