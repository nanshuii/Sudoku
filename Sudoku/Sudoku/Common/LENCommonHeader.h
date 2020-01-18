//
//  LENCommonHeader.h
//  Sudoku
//
//  Created by 林南水 on 2020/1/6.
//  Copyright © 2020 ledon. All rights reserved.
//

#ifndef LENCommonHeader_h
#define LENCommonHeader_h

# pragma mark -- 屏幕高宽
#define kFullScreenWidth           ([UIScreen mainScreen].bounds.size.width)
#define kFullScreenHeight          ([UIScreen mainScreen].bounds.size.height)

# pragma mark -- 引用
#define WEAKSELF(weakSelf)  __weak __typeof(&*self)weakSelf = self;

# pragma mark -- 自定义打印，在debug时打印，发布时不打印
#ifdef DEBUG
#define SSLog(fmt, ...) NSLog((@"[函数名:%s] " " [行号:%d] " fmt), __FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#define SSLog(fmt, ...)
#endif

# pragma mark -- color
//色码转RGB UIColor
#undef UIColorFromHex
#define UIColorFromHex(hexValue) ([UIColor colorWithRed:((float)((hexValue & 0xFF0000) >> 16))/255.0 green:((float)((hexValue & 0x00FF00) >> 8))/255.0 blue:((float)(hexValue & 0x0000FF))/255.0 alpha:1.0])
//附带透明度
#undef UIColorFromHexA
#define UIColorFromHexA(hexValue,a) ([UIColor colorWithRed:((float)((hexValue & 0xFF0000) >> 16))/255.0 green:((float)((hexValue & 0x00FF00) >> 8))/255.0 blue:((float)(hexValue & 0x0000FF))/255.0 alpha:(a)])

# pragma mark -- 字体
#undef FONTWITHNAME
#define FONTWITHNAME(fontName,fontSize)    ([UIFont fontWithName:fontName size:fontSize])
//系统默认字体   设置字体的大小
#undef FONTDEFAULT
#define FONTDEFAULT(fontSize)            ([UIFont systemFontOfSize:fontSize])
//系统加粗字体   设置字体的大小
#undef FONTBOLD
#define FONTBOLD(fontSize)            ([UIFont boldSystemFontOfSize:fontSize])
#define NORMALFONTNAME              @"PingFangSC-Regular"
#define SEMIBOLDFONTNAME            @"PingFangSC-Semibold"

# pragma mark -- default key
#define LENCurrentSudokuKey @"LENCurrentSudokuKey"
#define LENDefaultConfigureKey @"LENDefaultConfigureKey"

# pragma mark -- notification name
#define LENNotificationNameDidBecomeActive @"LENNotificationNameDidBecomeActive"
#define LENNotificationNameWillResignActive @"LENNotificationNameWillResignActive"


#endif /* LENCommonHeader_h */
