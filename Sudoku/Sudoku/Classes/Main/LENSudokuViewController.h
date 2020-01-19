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

@property (weak, nonatomic) IBOutlet UIButton *clearButton;

@property (weak, nonatomic) IBOutlet UIButton *supposeButton;

@property (weak, nonatomic) IBOutlet UIView *contentView;

@property (weak, nonatomic) IBOutlet UIView *bottomView;

@property (weak, nonatomic) IBOutlet UILabel *errorLabel;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UIButton *panButton;

@property (weak, nonatomic) IBOutlet UIView *numberView;


@end

NS_ASSUME_NONNULL_END
