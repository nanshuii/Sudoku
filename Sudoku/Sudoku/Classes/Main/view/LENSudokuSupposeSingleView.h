//
//  LENSudokuSupposeSingleView.h
//  Sudoku
//
//  Created by 戴十三 on 2020/1/19.
//  Copyright © 2020 ledon. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^TapBlock)(NSInteger section, NSInteger row);

@interface LENSudokuSupposeSingleView : UIView

@property (nonatomic, copy) TapBlock tapBlock;

/// 初始化
/// @param frame frame description
/// @param model model description
- (instancetype)initWithFrame:(CGRect)frame single:(LENSudokuSingleModel *)model;

/// 高亮显示
- (void)highLightShow;

/// 高亮隐藏
- (void)heighLightHidden;

/// status更改
/// @param status status description
- (void)statusUpdateWithStatus:(LENSudokuSingleStatus)status;

@end

NS_ASSUME_NONNULL_END
