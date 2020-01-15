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
- (instancetype)initWithFrame:(CGRect)frame style:(LENSudokuStyle)style;

/// 编辑状态切换
/// @param editing editing description
- (void)beEditing:(BOOL)editing;

/// 复原
- (void)recovery;

@end

NS_ASSUME_NONNULL_END
