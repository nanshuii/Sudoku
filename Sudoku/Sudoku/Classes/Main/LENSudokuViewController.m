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
#import "LENSudokuFinishViewController.h"

@interface LENSudokuViewController ()

@property (nonatomic, assign) LENSudokuStatus status;

@property (nonatomic, strong) LENSudokuView *sudokuView;

@property (nonatomic, strong) LENSudokuNumberView *numbersView;

@property (nonatomic, strong) LENSudokuStyleModel *styleModel;

@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, assign) NSInteger time;

@property (nonatomic, assign) NSInteger errorTimes;

@property (nonatomic, strong) CABasicAnimation *errorAnimation;

@property (nonatomic, assign) BOOL numbersViewEditing;

@end

@implementation LENSudokuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.time = self.model.time;
    self.errorTimes = self.model.errorTimes;
    self.styleModel = [LENHandle styleModelWithStyle:[LENHandle defaultConfigureRead].style];
    self.status = LENSudokuStatusNone;
    [self notifications];
    [self configureUI];
    [self timerCreate];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
}

# pragma mark -- notifications
- (void)notifications{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didBecomeActive) name:LENNotificationNameDidBecomeActive object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willResignActive) name:LENNotificationNameWillResignActive object:nil];
}

# pragma mark -- configureUI
- (void)configureUI{
    self.top.constant = kStatusBarHeight + 16;
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.timeLabel.text = [self timeString];
    self.errorLabel.text = [self errorString];
    self.timeLabel.textColor = self.styleModel.timesTextColor;
    self.errorLabel.textColor = self.styleModel.errorTimesTextColor;
    [self sudokuCreate];
    [self numbersViewCreate];
    BOOL hidden = [LENHandle defaultConfigureRead].timerHidden;
    self.timeLabel.hidden = hidden;
    [self bottomButtonsCreate];
}

- (void)sudokuCreate{
    WEAKSELF(weakSelf);
    CGFloat margin = 10;
    CGFloat width = kFullScreenWidth - margin * 2;
    self.sudokuView = [[LENSudokuView alloc] initWithFrame:CGRectMake(margin, margin, width, width) sudoku:self.model];
    [self.sudokuView setTapBlock:^(LENSudokuViewStatus status, LENSudokuSingleModel * _Nullable currentSingle) {
        [weakSelf.numbersView beEditing:weakSelf.numbersViewEditing sudokuViewStatus:status sudokuSingle:currentSingle];
    }];
    [self.sudokuView setFinishBlock:^(BOOL finish) {
        [weakSelf finish];
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
    self.numbersView = [[LENSudokuNumberView alloc] initWithFrame:CGRectMake(0, 0, kFullScreenWidth, 44) style:[LENHandle defaultConfigureRead].style normalHiddens:numbers];
    [self.numbersView setTapNumberBlock:^(int number, BOOL isEditing) {
        SSLog(@"number = %i isEditing = %i", number, isEditing);
        [weakSelf tapNumber:number isEditing:isEditing];
    }];
    [self.numberView addSubview:self.numbersView];
}

# pragma mark -- back
- (IBAction)back:(id)sender {
//    [self.navigationController popViewControllerAnimated:YES];
    self.sudokuView.sudoku.time = self.time;
    [LENHandle currentSudokuSave:self.sudokuView.sudoku];
    [self timerClose];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

# pragma mark -- 点击数字
- (void)tapNumber:(int)number isEditing:(BOOL)isEditing{
    if (self.status == LENSudokuStatusNone || self.status == LENSudokuStatusMark) {
        [self.sudokuView intoNumber:number mark:self.numbersView.isEditing callback:^(BOOL error, NSMutableArray * _Nullable numbers, BOOL mark, int markNumber, BOOL markAdd) {
            if (mark) {
                [self.numbersView markAdd:markAdd number:markNumber];
            } else {
                if (error) {
                    [self errorAnimationStart];
                    self.errorTimes += 1;
                    self.errorLabel.text = [self errorString];
                } else {
                    // hiddenNumbers获取
                    NSMutableArray *nums = [LENHandle sodukuFillInNumberAllWithNumbers:numbers];
                    [self.numbersView normalHiddensUpdate:nums];
                    // 因为填入正确所以变为了部分高亮，normal下的numbersView变为不可点击的模式
                    [self.numbersView normalEnableAll];
                }
            }
        }];;
    }
    else if (self.status == LENSudokuStatusSuppose) {
        [self.sudokuView supposeIntoNumber:number];
    }
}

# pragma mark -- 前台和后台
- (void)didBecomeActive{
    self.model = [LENHandle currentSudokuRead];
    self.time = self.model.time;
    self.timeLabel.text = [self timeString];
    self.errorTimes = self.model.errorTimes;
    self.errorLabel.text = [self errorString];
    [self timerCreate];
    [self.sudokuView singleAnimationStart];
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
    [self statusChangeWithStatus:(LENSudokuStatusNone)];
    [self.numbersView recovery];
}

# pragma mark -- error animation
- (void)errorAnimationStart{
    [self.errorLabel.layer removeAllAnimations];
    if (!_errorAnimation) {
        _errorAnimation = [CABasicAnimation animation];
        _errorAnimation.keyPath = @"transform.scale";
        _errorAnimation.toValue = @0.5;
        _errorAnimation.repeatCount = 1;
        _errorAnimation.duration = 0.5;
        _errorAnimation.autoreverses = YES;
    }
    [self.errorLabel.layer addAnimation:_errorAnimation forKey:nil];
}

# pragma mark -- bottom buttons
- (void)bottomButtonsCreate{
    [self clearButtonWithStatus:-1];
    [self noticeButtonWithStatus:0];
    [self supposeButtonWithStatus:0];
    [self markButtonWithStatus:1];
}

// clear button -1 0
- (void)clearButtonWithStatus:(int)status{
    if (status == -1) {
        self.bottom_image1.image = [UIImage imageNamed:@"clearEnable"];
        self.bottom_label1.text = @"清除全部";
        self.bottom_label1.textColor = Color_CDCDCD;
    } else if (status == 0) {
        self.bottom_image1.image = [UIImage imageNamed:@"clear"];
        self.bottom_label1.text = @"清除全部";
        self.bottom_label1.textColor = Color_1296DB;
    }
}

// notice button -1 0
- (void)noticeButtonWithStatus:(int)status{
    if (status == -1) {
        self.bottom_image2.image = [UIImage imageNamed:@"noticeEnable"];
        self.bottom_label2.text = @"提示";
        self.bottom_label2.textColor = Color_CDCDCD;
    } else if (status == 0) {
        self.bottom_image2.image = [UIImage imageNamed:@"notice"];
        self.bottom_label2.text = @"提示";
        self.bottom_label2.textColor = Color_1296DB;
    }
}

// suppose button -1 0
- (void)supposeButtonWithStatus:(int)status{
    if (status == -1) {
        self.bottom_image3.image = [UIImage imageNamed:@"supposeEnable"];
        self.bottom_label3.text = @"预设";
        self.bottom_label3.textColor = Color_CDCDCD;
    } else if (status == 0) {
        self.bottom_image3.image = [UIImage imageNamed:@"suppose"];
        self.bottom_label3.text = @"开启预设";
        self.bottom_label3.textColor = Color_1296DB;
    } else if (status == 1) {
        self.bottom_image3.image = [UIImage imageNamed:@"suppose"];
        self.bottom_label3.text = @"关闭预设";
        self.bottom_label3.textColor = Color_1296DB;
    }
}

// mark button -1 0 1
- (void)markButtonWithStatus:(int)status{
    if (status == -1) {
        self.bottom_image4.image = [UIImage imageNamed:@"intoEnable"];
        self.bottom_label4.text = @"填入";
        self.bottom_label4.textColor = Color_CDCDCD;
    } else if (status == -2) {
        self.bottom_image4.image = [UIImage imageNamed:@"markEnable"];
        self.bottom_label4.text = @"笔记";
        self.bottom_label4.textColor = Color_CDCDCD;
    } else if (status == 0) {
        self.bottom_image4.image = [UIImage imageNamed:@"mark"];
        self.bottom_label4.text = @"开启填入";
        self.bottom_label4.textColor = Color_1296DB;
    } else if (status == 1) {
        self.bottom_image4.image = [UIImage imageNamed:@"into"];
        self.bottom_label4.text = @"开启笔记";
        self.bottom_label4.textColor = Color_1296DB;
    }
}

# pragma mark -- bottom tap
- (IBAction)bottomTap1:(id)sender {
    if (self.bottom_image1.image == [UIImage imageNamed:@"clear"]) {
        // suppose clear
        [self.sudokuView supposeClear];
    }
}

- (IBAction)bottomTap2:(id)sender {
    if (self.bottom_image2.image == [UIImage imageNamed:@"notice"]) {
        // notice
        SSLog(@"notice");
    }
}

- (IBAction)bottomTap3:(id)sender {
    if (self.bottom_image3.image == [UIImage imageNamed:@"suppose"]) {
        if ([self.bottom_label3.text isEqualToString:@"开启预设"]) {
            // suppose open
            [self statusChangeWithStatus:(LENSudokuStatusSuppose)];
        } else if ([self.bottom_label3.text isEqualToString:@"关闭预设"]) {
            // suppose close
            [self statusChangeWithStatus:(LENSudokuStatusNone)];
        }
    }
}

- (IBAction)bottomTap4:(id)sender {
    if (self.bottom_image4.image == [UIImage imageNamed:@"mark"]) {
        // to into
        [self statusChangeWithStatus:(LENSudokuStatusNone)];
    } else if (self.bottom_image4.image == [UIImage imageNamed:@"into"]) {
        // to mark
        [self statusChangeWithStatus:(LENSudokuStatusMark)];
    }
}

# pragma mark -- status change
- (void)statusChangeWithStatus:(LENSudokuStatus)status{
    
    if (self.status == LENSudokuStatusNone) {
        if (status == LENSudokuStatusSuppose) {
            // none -> suppose
            [self clearButtonWithStatus:0];
            [self noticeButtonWithStatus:-1];
            [self supposeButtonWithStatus:1];
            [self markButtonWithStatus:-1];
            [self.sudokuView supposeShow:YES];
            [self.numbersView normalEnableAll];
        }
        else if (status == LENSudokuStatusMark) {
            // none -> mark
            [self markButtonWithStatus:0];
            self.numbersViewEditing = YES;
            [self.numbersView beEditing:self.numbersViewEditing sudokuViewStatus:self.sudokuView.status sudokuSingle:self.sudokuView.currentSingle];
        }
    }
    else if (self.status == LENSudokuStatusMark) {
        if (status == LENSudokuStatusSuppose) {
            // mark -> suppose
            [self clearButtonWithStatus:0];
            [self noticeButtonWithStatus:-1];
            [self supposeButtonWithStatus:1];
            [self markButtonWithStatus:-1];
            [self.sudokuView supposeShow:YES];
            [self.numbersView normalEnableAll];
        }
        else if (status == LENSudokuStatusNone) {
            // mark -> none
            [self markButtonWithStatus:1];
            self.numbersViewEditing = NO;
            [self.numbersView beEditing:self.numbersViewEditing sudokuViewStatus:self.sudokuView.status sudokuSingle:self.sudokuView.currentSingle];
        }
    }
    else if (self.status == LENSudokuStatusSuppose) {
        if (status == LENSudokuStatusNone) {
            // suppose -> none
            [self clearButtonWithStatus:-1];
            [self noticeButtonWithStatus:0];
            [self supposeButtonWithStatus:0];
            [self markButtonWithStatus:1];
            [self.sudokuView supposeShow:NO];
            [self.numbersView recovery];
        }
    }
    self.status = status;
}

# pragma mark -- 完成
- (void)finish{
    self.sudokuView.sudoku.time = self.time;
    [LENHandle sudokuInsertToSudokusWithSudoku:self.sudokuView.sudoku status:2];
    [LENHandle currentSudokuSave:nil];
    [self timerClose];
    LENSudokuFinishViewController *vc = [LENSudokuFinishViewController new];
    vc.sudoku = self.sudokuView.sudoku;
    [self.navigationController pushViewController:vc animated:YES];
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
