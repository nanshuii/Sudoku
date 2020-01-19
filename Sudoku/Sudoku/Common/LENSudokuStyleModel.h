//
//  LENSudokuStyleModel.h
//  Sudoku
//
//  Created by 戴十三 on 2020/1/18.
//  Copyright © 2020 ledon. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LENSudokuStyleModel : NSObject

# pragma mark -- sudokuView
@property (nonatomic, strong) UIColor *sudokuViewBoardColor; // 棋盘外边框颜色

@property (nonatomic, strong) UIColor *sudokuViewLineBigColor; // 棋盘粗线条颜色

@property (nonatomic, strong) UIColor *sudokuViewLineColor; // 棋盘细线条颜色

@property (nonatomic, strong) UIColor *sudokuViewSingleBackgroundColor; // 棋盘格子背景色
 
@property (nonatomic, strong) UIColor *sudokuViewSingleHighLightBackgroundColor; // 棋盘格子高亮背景色

@property (nonatomic, strong) UIColor *sudokuViewSingleMarkBackgroundColor; // 棋盘格子标记背景色

@property (nonatomic, strong) UIColor *sudokuViewSingleFillInTextColor; // 棋盘格子填入数字颜色

@property (nonatomic, strong) UIColor *sudokuViewSingleMarkTextColor; // 棋盘格子标记数字颜色

# pragma mark -- sudokuSupposeView
@property (nonatomic, strong) UIColor *sudokuSupposeBackgroundColor; // 假设背景色

@property (nonatomic, strong) UIColor *sudokuSupposeSingleBackgroundColor; // 假设格子背景色

@property (nonatomic, strong) UIColor *sudokuSupposeSingleFillInTextColor; // 假设格子填入数字颜色

@property (nonatomic, strong) UIColor *sudokuSupposeSingleFillInErrorTextColor; // 假设格子填入错误颜色

@property (nonatomic, strong) UIColor *sudokuSupposeSingleHighLightBackgroundColor; // 假设格子高亮背景色

# pragma mark -- numbersView normal
@property (nonatomic, strong) UIColor *numbersViewNormalBackgroundColor; // 数字栏正常背景色

@property (nonatomic, strong) UIColor *numbersViewNormalEnableBackgroundColor; // 数字栏正常不可点击背景色

@property (nonatomic, strong) UIColor *numbersViewNormalTextColor; // 数字栏正常数字颜色

@property (nonatomic, strong) UIColor *numbersViewNormalEnableTextColor; // 数字栏正常不可点击数字颜色

# pragma mark -- numberView mark
@property (nonatomic, strong) UIColor *numbersViewMarkBackgroundColor; // 数字栏标记背景色

@property (nonatomic, strong) UIColor *numbersViewMarkSelectedBackgroundColor; // 数字栏标记选中背景色

@property (nonatomic, strong) UIColor *numbersViewMarkEnableBackgroundColor; // 数字栏标记不可点击背景色

@property (nonatomic, strong) UIColor *numbersViewMarkTextColor; // 数字栏标记数字颜色

@property (nonatomic, strong) UIColor *numbersViewMarkSelectedTextColor; // 数字栏标记选中数字颜色

@property (nonatomic, strong) UIColor *numbersViewMarkEnableTextColor; // 数字栏标记不可点击数字颜色

# pragma mark -- other
@property (nonatomic, strong) UIColor *errorTimesTextColor; // 错误栏字体颜色

@property (nonatomic, strong) UIColor *timesTextColor; // 时间字体颜色





@end

NS_ASSUME_NONNULL_END
