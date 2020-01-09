//
//  LENSudokuView.h
//  Sudoku
//
//  Created by 林南水 on 2020/1/6.
//  Copyright © 2020 ledon. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LENSudokuView : UIView

- (instancetype)initWithFrame:(CGRect)frame sudoku:(LENSudokuModel *)sudoku;

@end

NS_ASSUME_NONNULL_END
