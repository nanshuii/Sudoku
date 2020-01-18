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
+ (LENSudokuModel *)sudoKuCreateWithType:(LENSudokuType)type;

/// 当前sudoku存储
/// @param model model description
+ (void)currentSudokuSave:(LENSudokuModel *)model;

/// 当前sudoku读取
+ (LENSudokuModel *)currentSudokuRead;

/// 默认配置保存
/// @param model model description
+ (void)defaultConfigureSave:(LENDefaultConfigModel *)model;

/// 默认配置读取
+ (LENDefaultConfigModel *)defaultConfigureRead;

/// 获取soduku numbers中数量为9的数字
/// @param numbers numbers description
+ (NSMutableArray *)sodukuFillInNumberAllWithNumbers:(NSMutableArray *)numbers;

/// 根据style返回model
/// @param style style description
+ (LENSudokuStyleModel *)styleModelWithStyle:(LENSudokuStyle)style;

@end

NS_ASSUME_NONNULL_END
