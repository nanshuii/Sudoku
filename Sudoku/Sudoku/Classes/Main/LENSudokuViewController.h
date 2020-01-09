//
//  LENSudokuViewController.h
//  Sudoku
//
//  Created by 林南水 on 2020/1/6.
//  Copyright © 2020 ledon. All rights reserved.
//

#import "LENBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface LENSudokuViewController : LENBaseViewController

@property (nonatomic, strong) LENSudokuModel *model;

@property (weak, nonatomic) IBOutlet UIView *contentView;


@end

NS_ASSUME_NONNULL_END
