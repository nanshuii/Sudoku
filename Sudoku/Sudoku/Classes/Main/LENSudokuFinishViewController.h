//
//  LENSudokuFinishViewController.h
//  Sudoku
//
//  Created by 戴十三 on 2020/1/23.
//  Copyright © 2020 ledon. All rights reserved.
//

#import "LENBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface LENSudokuFinishViewController : LENBaseViewController

@property (nonatomic, strong) LENSudokuModel *sudoku;

@property (weak, nonatomic) IBOutlet UILabel *recordLabel;

@property (weak, nonatomic) IBOutlet UILabel *typeLabel;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UILabel *errorLabel;

@property (weak, nonatomic) IBOutlet UIButton *gameNewButton;

@property (weak, nonatomic) IBOutlet UIButton *homeButton;

@end

NS_ASSUME_NONNULL_END
