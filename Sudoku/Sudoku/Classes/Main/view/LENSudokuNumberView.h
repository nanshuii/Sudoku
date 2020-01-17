//
//  LENSudokuNumberView.h
//  Sudoku
//
//  Created by 戴十三 on 2020/1/13.
//  Copyright © 2020 ledon. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^TapNumberBlock)(int number, BOOL isEditing);

@interface LENSudokuNumberView : UIView

@property (nonatomic, assign) BOOL isEditing;

@property (nonatomic, copy) TapNumberBlock tapNumberBlock;

/// 初始化
/// @param frame frame description
/// @param style style description
/// @param normalHiddens 正常状态下需要隐藏的数字数组
- (instancetype)initWithFrame:(CGRect)frame style:(LENSudokuStyle)style normalHiddens:(NSMutableArray *)normalHiddens;

/// 编辑状态切换
/// @param editing editing description
/// @param sudokuViewStatus sudokuViewStatus description
/// @param sudokuSingle sudokuSingle description
- (void)beEditing:(BOOL)editing sudokuViewStatus:(LENSudokuViewStatus)sudokuViewStatus sudokuSingle:(LENSudokuSingleModel *)sudokuSingle;

/// 复原
- (void)recovery;

@end

NS_ASSUME_NONNULL_END
