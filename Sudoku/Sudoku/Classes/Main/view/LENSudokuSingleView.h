//
//  LENSudokuSingleView.h
//  Sudoku
//
//  Created by 林南水 on 2020/1/6.
//  Copyright © 2020 ledon. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^TapBlock)(NSInteger section, NSInteger row);

@interface LENSudokuSingleView : UIView

@property (nonatomic, copy) TapBlock tapBlock;

/// 初始化
/// @param frame frame description
/// @param model model description
/// @param style style description
- (instancetype)initWithFrame:(CGRect)frame model:(LENSudokuSingleModel *)model style:(LENSudokuStyle)style;

/// 高亮显示
- (void)highLightShow;

/// 高亮隐藏
- (void)heighLightHidden;

/// 修改格子里的marks
/// @param marks marks description
- (void)markUpdateWithMarks:(NSMutableArray *)marks;

/// status更改
/// @param status status description
- (void)statusUpdateWithStatus:(LENSudokuSingleStatus)status;

@end

NS_ASSUME_NONNULL_END
