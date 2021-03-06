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
+ (LENSudokuModel *)sudoKuCreateWithType:(LENSudokuType)type;

/// 当前sudoku存储
/// @param model model description
+ (void)currentSudokuSave:(nullable LENSudokuModel *)model;

/// 当前sudoku读取
+ (LENSudokuModel *)currentSudokuRead;

/// 存入一个新的sudoku进sudokus
/// @param sudoku sudoku description
/// @param status status description
+ (void)sudokuInsertToSudokusWithSudoku:(LENSudokuModel *)sudoku status:(int)status;

/// sudokus读取，返回一个Dictionary NSArray
+ (NSArray *)sudokusRead;

# pragma mark -- sudokus read
/// sudokuModels读取，返回一个LENSudokuModel NSMutableArray
+ (NSMutableArray *)sudokuModelsRead;

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

/// sudoku根据section和row返回index
/// @param section section description
/// @param row row description
+ (NSInteger)indexWithSection:(NSInteger)section row:(NSInteger)row;

/// 难度string
/// @param type type description
+ (NSString *)typeStringWithType:(LENSudokuType)type;

/// timestamp to YMDHS
/// @param timestamp timestamp description
+ (NSString *)YMDHMSStringWithTimestamp:(NSInteger)timestamp;

/// yyyy-MM-dd HH:mm:ss to [yyyy-MM-dd, HH:mm:ss, yyyy-MM, d]
/// @param dateString dateString description
+ (NSMutableArray *)dateArrayWithDateString:(NSString *)dateString;

@end

NS_ASSUME_NONNULL_END
