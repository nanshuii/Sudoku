//
//  LENSudokuViewController.m
//  Sudoku
//
//  Created by 林南水 on 2020/1/6.
//  Copyright © 2020 ledon. All rights reserved.
//

#import "LENSudokuViewController.h"
#import "LENSudokuView.h"
#import "LENSudokuNumberView.h"

@interface LENSudokuViewController ()

@property (nonatomic, strong) LENSudokuView *sudokuView;

@property (nonatomic, strong) LENSudokuNumberView *numbersView;

@end

@implementation LENSudokuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self configureUI];
}

- (void)configureUI{
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self sudokuCreate];
}

# pragma mark -- sudoku create
- (void)sudokuCreate{
    WEAKSELF(weakSelf);
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
    self.numbersView = [[LENSudokuNumberView alloc] initWithFrame:CGRectMake(0, 0, kFullScreenWidth, 44) style:self.model.style];
    [self.numbersView setTapNumberBlock:^(int number, BOOL isEditing) {
        [weakSelf tapNumber:number isEditing:isEditing];
    }];
    [self.numberView addSubview:self.numbersView];
}

# pragma mark -- 编辑模式
- (IBAction)panEdit:(UIButton *)sender {
    sender.selected = !sender.selected;
    [self.numbersView beEditing:sender.selected];
}

# pragma mark -- 点击数字
- (void)tapNumber:(int)number isEditing:(BOOL)isEditing{
    [self.sudokuView intoNumber:number mark:self.numbersView.isEditing];
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
