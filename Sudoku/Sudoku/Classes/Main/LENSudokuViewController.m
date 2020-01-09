//
//  LENSudokuViewController.m
//  Sudoku
//
//  Created by 林南水 on 2020/1/6.
//  Copyright © 2020 ledon. All rights reserved.
//

#import "LENSudokuViewController.h"
#import "LENSudokuView.h"

@interface LENSudokuViewController ()

@property (nonatomic, strong) LENSudokuView *sudokuView;

@end

@implementation LENSudokuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self configureUI];
}

- (void)configureUI{
    [self sudokuCreate];
}

# pragma mark -- sudoku create
- (void)sudokuCreate{
    CGFloat margin = 10;
    CGFloat width = kFullScreenWidth - margin * 2;
    self.sudokuView = [[LENSudokuView alloc] initWithFrame:CGRectMake(margin, margin, width, width) sudoku:self.model];
    [self.contentView addSubview:self.sudokuView];
    [self.sudokuView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView.mas_top).offset(margin);
        make.left.mas_equalTo(self.contentView.mas_left).offset(margin);
        make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-margin);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-margin);
    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
