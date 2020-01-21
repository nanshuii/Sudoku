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
    LENSudokuTypeOne,
    LENSudokuTypeTwo,
    LENSudokuTypeThree,
    LENSudokuTypeFour,
    LENSudokuTypeFive,
    LENSudokuTypeSix,
    LENSudokuTypeSeven,
    LENSudokuTypeEight,
    LENSudokuTypeNine,
    LENSudokuTypeTen,
};

// controller status
typedef NS_ENUM(NSUInteger, LENSudokuStatus) {
    LENSudokuStatusNone, // 初始状态 填入模式
    LENSudokuStatusMark,
    LENSudokuStatusSuppose,
};

// 单个格子的状态
typedef NS_ENUM(NSUInteger, LENSudokuSingleStatus) {
    LENSudokuSingleStatusNone, // 空白
    LENSudokuSingleStatusFillIn, // 已经填入数字
    LENSudokuSingleStatusmark, // 标记
    LENSudokuSingleStatusSupposeFillIn, // 假设的填入数字
    LENSudokuSingleStatusSupposeFillInError, // 假设的填入数字错误
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

// 数字栏格子状态
typedef NS_ENUM(NSUInteger, LENSudokuNumberStatus) {
    LENSudokuNumberStatusNormal, // 正常
    LENSudokuNumberStatusNormalHidden, // 正常的隐藏状态
    LENSudokuNumberStatusNormalEnable, // 正常的不可点击状态
    LENSudokuNumberStatusMark, // mark
    LENSudokuNumberStatusMarkSelected, // mark被选中状态
    LENSudokuNumberStatusMarkEnable, // mark不可选中状态
};


#endif /* LENEnumHeader_h */
