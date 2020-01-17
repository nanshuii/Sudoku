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

@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, assign) NSInteger time;

@property (nonatomic, assign) NSInteger errorTimes;

@end

@implementation LENSudokuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.time = self.model.time;
    self.errorTimes = self.model.errorTimes;
    [self notifications];
    [self configureUI];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.sudokuView.sudoku.time = self.time;
    [LENHandle currentSudokuSave:self.sudokuView.sudoku];
    [self timerClose];
}

# pragma mark -- notifications
- (void)notifications{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didBecomeActive) name:LENNotificationNameDidBecomeActive object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willResignActive) name:LENNotificationNameWillResignActive object:nil];
}

# pragma mark -- configureUI
- (void)configureUI{
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.timeLabel.text = [self timeString];
    self.errorLabel.text = [self errorString];
    [self sudokuCreate];
    [self numbersViewCreate];
}

- (void)sudokuCreate{
    WEAKSELF(weakSelf);
    CGFloat margin = 10;
    CGFloat width = kFullScreenWidth - margin * 2;
    self.sudokuView = [[LENSudokuView alloc] initWithFrame:CGRectMake(margin, margin, width, width) sudoku:self.model];
    [self.sudokuView setTapBlock:^(LENSudokuViewStatus status, LENSudokuSingleModel * _Nullable currentSingle) {
        [weakSelf.numbersView beEditing:weakSelf.panButton.selected sudokuViewStatus:status sudokuSingle:currentSingle];
    }];
    [self.contentView addSubview:self.sudokuView];
    [self.sudokuView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView.mas_top).offset(margin);
        make.left.mas_equalTo(self.contentView.mas_left).offset(margin);
        make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-margin);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-margin);
    }];
}

- (void)numbersViewCreate{
    WEAKSELF(weakSelf);
    NSMutableArray *numbers = [LENHandle sodukuFillInNumberAllWithNumbers:self.model.numbers];
    self.numbersView = [[LENSudokuNumberView alloc] initWithFrame:CGRectMake(0, 0, kFullScreenWidth, 44) style:self.model.style normalHiddens:numbers];
    [self.numbersView setTapNumberBlock:^(int number, BOOL isEditing) {
        [weakSelf tapNumber:number isEditing:isEditing];
    }];
    [self.numberView addSubview:self.numbersView];
}

# pragma mark -- 编辑模式
- (IBAction)panEdit:(UIButton *)sender {
    sender.selected = !sender.selected;
    // 需要获取当前sudoku view 的部分数据
    [self.numbersView beEditing:sender.selected sudokuViewStatus:self.sudokuView.status sudokuSingle:self.sudokuView.currentSingle];
}

# pragma mark -- 点击数字
- (void)tapNumber:(int)number isEditing:(BOOL)isEditing{
    [self.sudokuView intoNumber:number mark:self.numbersView.isEditing callback:^(BOOL error, NSMutableArray * _Nullable numbers, BOOL mark, int markNumber, BOOL markAdd) {
        if (mark) {
            [self.numbersView markAdd:markAdd number:markNumber];
        } else {
            if (error) {
                self.errorTimes += 1;
                self.errorLabel.text = [self errorString];
            } else {
                NSMutableArray *nums = [LENHandle sodukuFillInNumberAllWithNumbers:numbers];
                [self.numbersView normalHiddensUpdate:nums];
                // 因为填入正确所以变为了部分高亮，normal下的numbersView变为不可点击的模式
                [self.numbersView normalEnableAll];
            }
        }
    }];;
}

# pragma mark -- 前台和后台
- (void)didBecomeActive{
    self.model = [LENHandle currentSudokuRead];
    self.time = self.model.time;
    self.timeLabel.text = [self timeString];
    self.errorTimes = self.model.errorTimes;
    self.errorLabel.text = [self errorString];
    [self timerCreate];
}

- (void)willResignActive{
    self.sudokuView.sudoku.time = self.time;
    [LENHandle currentSudokuSave:self.sudokuView.sudoku];
    [self timerClose];
    [self bottomRecovery];
    [self.sudokuView recovery];
}

# pragma mark -- timer
- (void)timerCreate{
    if (!_timer) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerActive) userInfo:nil repeats:YES];
    }
}

- (void)timerActive{
    self.time += 1;
    self.timeLabel.text = [self timeString];
}

- (void)timerClose{
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
}

# pragma mark -- time string
- (NSString *)timeString{
    NSInteger hour = self.time / 3600;
    NSInteger mins = self.time - hour * 3600;
    NSInteger min = mins / 60;
    NSInteger sec = mins - min * 60;
    NSString *string = [NSString stringWithFormat:@"%02ld:%02ld", (long)min, (long)sec];
    if (hour > 0) {
        string = [NSString stringWithFormat:@"%02ld:%@", (long)hour, string];
    }
    return string;
}

# pragma mark -- error string
- (NSString *)errorString{
    NSString *string = @"";
    if (self.errorTimes > 0) {
        string = [NSString stringWithFormat:@"错误：%li次", self.errorTimes];
    }
    return string;
}

# pragma mark -- bottom view 复原
- (void)bottomRecovery{
    self.panButton.selected = NO;
    [self.numbersView recovery];
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
