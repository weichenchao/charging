//
//  CPMacro.h
//  chargingPile
//  宏定义
//  Created by weichenchao on 16/1/8.
//  Copyright © 2016年 private. All rights reserved.
//

#import <Foundation/Foundation.h>

//----------------------获取屏幕 高度 宽度---------------------------
#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)


//----------------------颜色类---------------------------
// rgb颜色转换（16进制->10进制）
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
//带有RGBA的颜色设置
#define COLOR(R, G, B, A) [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:A]
// 获取RGB颜色
#define RGBA(r,g,b,a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
#define RGB(r,g,b) RGBA(r,g,b,1.0f)
//背景色
#define BACKGROUND_COLOR [UIColor colorWithRed:242.0/255.0 green:236.0/255.0 blue:231.0/255.0 alpha:1.0]
//清除背景色
#define CLEARCOLOR [UIColor clearColor]

//日志开关
#ifdef DEBUG
#define CPLog(...) NSLog(__VA_ARGS__)
#else
#define CPLog(...)
#endif
//通知（controller之间的变化通知）
#define CPNotificationCenter [NSNotificationCenter defaultCenter]


