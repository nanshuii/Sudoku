//
//  LENHandle.h
//  Sudoku
//
//  Created by 林南水 on 2020/1/6.
//  Copyright © 2020 ledon. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


@interface LENHandle : NSObject

# pragma mark -- sudoku创建
/// sudoku创建
/// @param type type description
/// @param style style description
+ (LENSudokuModel *)sudoKuCreateWithType:(LENSudokuType)type style:(LENSudokuStyle)style;

/// 当前sudoku存储
/// @param model model description
+ (void)currentSudokuSave:(LENSudokuModel *)model;

/// 当前sudoku读取
+ (LENSudokuModel *)currentSudokuRead;

# pragma mark -- 获取soduku numbers中数量为9的数字
+ (NSMutableArray *)sodukuFillInNumberAllWithNumbers:(NSMutableArray *)numbers;

@end

NS_ASSUME_NONNULL_END
