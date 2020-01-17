//
//  LENSudokuNumberSingleView.h
//  Sudoku
//
//  Created by 戴十三 on 2020/1/13.
//  Copyright © 2020 ledon. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^TapBlock)(int number);

@interface LENSudokuNumberSingleView : UIView

@property (nonatomic, copy) TapBlock tapBlock;

@property (nonatomic, assign) LENSudokuNumberStatus status;

- (instancetype)initWithFrame:(CGRect)frame style:(LENSudokuStyle)style number:(int)number status:(LENSudokuNumberStatus)status;

/// 编辑模式开启和关闭
/// @param editing editing description
- (void)beEditing:(BOOL)editing;

/// 复原
- (void)recovery;

/// 状态变更
/// @param status status description
/// @param editing editing description
- (void)statusUpdateWithStatus:(LENSudokuNumberStatus)status editing:(BOOL)editing;


@end

NS_ASSUME_NONNULL_END
