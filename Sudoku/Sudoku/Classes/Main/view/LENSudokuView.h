//
//  LENSudokuView.h
//  Sudoku
//
//  Created by 林南水 on 2020/1/6.
//  Copyright © 2020 ledon. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/// 键入数字之后的block；error是键入数字之后错误；numbers是键入正确之后，返回的numbers数组；mark是mark模式的标记；markNumber是mark模式键入的数字返回，markAdd表明是添加mark
typedef void(^InToBlock)(BOOL error,  NSMutableArray * _Nullable numbers, BOOL mark, int markNumber, BOOL markAdd);

typedef void(^TapSudokuViewBlock)(LENSudokuViewStatus status, LENSudokuSingleModel * _Nullable currentSingle);

typedef void(^FinishBlock)(BOOL finish);

@interface LENSudokuView : UIView

@property (nonatomic, strong) LENSudokuModel *sudoku;

@property (nonatomic, assign) LENSudokuViewStatus status;

@property (nonatomic, strong, nullable) LENSudokuSingleModel *currentSingle;

@property (nonatomic, copy) InToBlock inToBlock;

@property (nonatomic, copy) TapSudokuViewBlock tapBlock;

@property (nonatomic, copy) FinishBlock finishBlock;

/// 初始化
/// @param frame frame description
/// @param sudoku sudoku description
- (instancetype)initWithFrame:(CGRect)frame sudoku:(LENSudokuModel *)sudoku;

/// 输入数字
/// @param number number description
/// @param mark 是否标记模式
/// @param callback  callback
- (void)intoNumber:(int)number mark:(BOOL)mark callback:(InToBlock)callback;

/// 格子动画
- (void)singleAnimationStart;

/// 复原
- (void)recovery;

/// 开启假设页面
/// @param show show description
- (void)supposeShow:(BOOL)show;

/// 假设页面清理
- (void)supposeClear;

/// 假设输入数字
/// @param number number description
- (void)supposeIntoNumber:(int)number;

@end

NS_ASSUME_NONNULL_END
