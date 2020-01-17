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

# pragma mark -- default key
#define LENCurrentSudokuKey @"LENCurrentSudokuKey"

# pragma mark -- notification name
#define LENNotificationNameDidBecomeActive @"LENNotificationNameDidBecomeActive"
#define LENNotificationNameWillResignActive @"LENNotificationNameWillResignActive"


#endif /* LENCommonHeader_h */
