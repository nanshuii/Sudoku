//
//  LENSudokuView.h
//  Sudoku
//
//  Created by 林南水 on 2020/1/6.
//  Copyright © 2020 ledon. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^InToBlock)(BOOL error);

@interface LENSudokuView : UIView

@property (nonatomic, strong) LENSudokuModel *sudoku;

@property (nonatomic, copy) InToBlock inToBlock;

- (instancetype)initWithFrame:(CGRect)frame sudoku:(LENSudokuModel *)sudoku;

- (void)intoNumber:(int)number mark:(BOOL)mark callback:(InToBlock)callback;



@end

NS_ASSUME_NONNULL_END
