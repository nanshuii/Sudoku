//
//  LENEnumHeader.h
//  Sudoku
//
//  Created by 林南水 on 2020/1/6.
//  Copyright © 2020 ledon. All rights reserved.
//

#ifndef LENEnumHeader_h
#define LENEnumHeader_h

// 难度等级
typedef NS_ENUM(NSUInteger, LENSudokuType) {
    LENSudokuTypeEasy,
    LENSudokuTypeMiddle,
    LENSudokuTypeHard,
};

// 单个格子的状态
typedef NS_ENUM(NSUInteger, LENSudokuSingleStatus) {
    LENSudokuSingleStatusNone, // 空白
    LENSudokuSingleStatusFillIn, // 已经填入数字
    LENSudokuSingleStatusmark, // 标记
};

// 样式
typedef NS_ENUM(NSUInteger, LENSudokuStyle) {
    LENSudokuStyleNone, // 默认状态
};

// 表状态
typedef NS_ENUM(NSUInteger, LENSudokuViewStatus) {
    LENSudokuViewStatusNone, // 初始状态
    LENSudokuViewStatusPrepareFillInOrMask, // 准备填入数字或者准备做标记的状态
    LENSudokuViewStatusHighLightPart, // 相同数字部分高亮
};



#endif /* LENEnumHeader_h */
