//
//  LENSudokuFinishViewController.m
//  Sudoku
//
//  Created by 戴十三 on 2020/1/23.
//  Copyright © 2020 ledon. All rights reserved.
//

#import "LENSudokuFinishViewController.h"
#import "LENSudokuViewController.h"

@interface LENSudokuFinishViewController ()

@end

@implementation LENSudokuFinishViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self configureUI];
}

- (void)configureUI{
    self.gameNewButton.layer.cornerRadius = 22;
    self.homeButton.layer.cornerRadius = 22;
    self.typeLabel.text = [LENHandle typeStringWithType:self.sudoku.type];
     NSString *timerString = [self timerStringWithTime:self.sudoku.time];
       timerString = [NSString stringWithFormat:@"耗时:%@", timerString];
    self.timeLabel.text = timerString;
    NSInteger errorTimes = self.sudoku.errorTimes;
    if (errorTimes == 0) {
        self.errorLabel.text = @"完美";
    } else {
        self.errorLabel.text = [NSString stringWithFormat:@"错误 %li次", errorTimes];
    }
    [self performSelector:@selector(delay) withObject:nil afterDelay:1.0];
}

- (NSString *)timerStringWithTime:(NSInteger)time{
    NSInteger hour = time / 3600;
    NSInteger mins = time - hour * 3600;
    NSInteger min = mins / 60;
    NSInteger sec = mins - min * 60;
    NSString *string = [NSString stringWithFormat:@"%02ld分%02ld秒", (long)min, (long)sec];
    if (hour > 0) {
        string = [NSString stringWithFormat:@"%02ld时%@", (long)hour, string];
    }
    return string;
}

- (void)delay{
    self.recordLabel.text = @"（记录保存成功）";
}

# pragma mark -- 新游戏
- (IBAction)gameNewButtonAction:(id)sender {
    NSArray *titles = @[@"难度一", @"难度二", @"难度三", @"难度四", @"难度五", @"难度六", @"难度七"];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:(UIAlertControllerStyleActionSheet)];
    [alert addAction:[UIAlertAction actionWithTitle:@"上次难度" style:(UIAlertActionStyleDestructive) handler:^(UIAlertAction * _Nonnull action) {
        LENSudokuViewController *vc = [LENSudokuViewController new];
        LENSudokuModel *model = [LENHandle sudoKuCreateWithType:self.sudoku.type];
        vc.model = model;
        [self.navigationController pushViewController:vc animated:YES];
    }]];
    for (int i = 0; i < titles.count; i++) {
        UIAlertAction *action = [UIAlertAction actionWithTitle:titles[i] style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
            LENSudokuType type = LENSudokuTypeOne;
            switch (i) {
                case 0:
                    type = LENSudokuTypeOne;
                    break;
                case 1:
                    type = LENSudokuTypeTwo;
                    break;
                case 2:
                    type = LENSudokuTypeThree;
                    break;
                case 3:
                    type = LENSudokuTypeFour;
                    break;
                case 4:
                    type = LENSudokuTypeFive;
                    break;
                case 5:
                    type = LENSudokuTypeSix;
                    break;
                case 6:
                    type = LENSudokuTypeSeven;
                    break;
                default:
                    break;
            }
            LENSudokuViewController *vc = [LENSudokuViewController new];
            LENSudokuModel *model = [LENHandle sudoKuCreateWithType:type];
            vc.model = model;
            [self.navigationController pushViewController:vc animated:YES];
        }];
        [alert addAction:action];
    }
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alert addAction:action];
    [self presentViewController:alert animated:YES completion:nil];
}

# pragma mark -- home button
- (IBAction)homeButtonAction:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
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
