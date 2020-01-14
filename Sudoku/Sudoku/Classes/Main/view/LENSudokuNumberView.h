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

- (instancetype)initWithFrame:(CGRect)frame style:(LENSudokuStyle)style;

- (void)beEditing:(BOOL)editing;

@end

NS_ASSUME_NONNULL_END
