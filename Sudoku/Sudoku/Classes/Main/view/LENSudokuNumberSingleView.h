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

- (instancetype)initWithFrame:(CGRect)frame style:(LENSudokuStyle)style number:(int)number;

# pragma mark -- edit
- (void)beEditing:(BOOL)editing;

@end

NS_ASSUME_NONNULL_END
