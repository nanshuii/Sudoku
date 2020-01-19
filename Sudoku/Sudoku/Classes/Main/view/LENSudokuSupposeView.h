//
//  LENSudokuSupposeView.h
//  Sudoku
//
//  Created by 戴十三 on 2020/1/19.
//  Copyright © 2020 ledon. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LENSudokuSupposeView : UIView

/// 初始化
/// @param frame frame description
/// @param singles singles description
/// @param singleViews singleViews description
- (instancetype)initWithFrame:(CGRect)frame singles:(NSMutableArray *)singles singleViews:(NSMutableArray *)singleViews;

/// 键入数字
/// @param number number description
- (void)intoNumber:(int)number;

/// 因为sudokuView键入的数字而发生的变化
/// @param number number description
/// @param index index description
- (void)updateSudokuViewIntoNumber:(int)number index:(NSInteger)index;

/// hidden
- (void)hiddenView;

/// 清除
- (void)clear;

@end

NS_ASSUME_NONNULL_END
