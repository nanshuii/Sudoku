//
//  LENSudokuView.h
//  Sudoku
//
//  Created by 林南水 on 2020/1/6.
//  Copyright © 2020 ledon. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^InToBlock)(BOOL error, int fillInNumber);

@interface LENSudokuView : UIView

@property (nonatomic, strong) LENSudokuModel *sudoku;

@property (nonatomic, assign) LENSudokuViewStatus status;

@property (nonatomic, strong, nullable) LENSudokuSingleModel *currentSingle;

@property (nonatomic, copy) InToBlock inToBlock;

/// 初始化
/// @param frame frame description
/// @param sudoku sudoku description
- (instancetype)initWithFrame:(CGRect)frame sudoku:(LENSudokuModel *)sudoku;

/// 输入数字
/// @param number number description
/// @param mark 是否标记模式
/// @param callback error:是否错误 fillInNumber:如果是填入正确，那么返回填入的这个数字，默认-1
- (void)intoNumber:(int)number mark:(BOOL)mark callback:(InToBlock)callback;

/// 复原
- (void)recovery;

@end

NS_ASSUME_NONNULL_END
