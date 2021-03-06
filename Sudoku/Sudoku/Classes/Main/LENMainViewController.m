//
//  LENMainViewController.m
//  Sudoku
//
//  Created by 林南水 on 2020/1/6.
//  Copyright © 2020 ledon. All rights reserved.
//

#import "LENMainViewController.h"
#import "LENSudokuViewController.h"
#import "LENSettingViewController.h"
#import "LENRecordsViewController.h"

@interface LENMainViewController ()

@end

@implementation LENMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self configureUI];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    LENSudokuModel *model = [LENHandle currentSudokuRead];
    if (model) {
        self.gamaContinueButton.hidden = NO;
    } else {
        self.gamaContinueButton.hidden = YES;
    }
}

# pragma mark -- configureUI
- (void)configureUI{
//    self.view.backgroundColor = UIColorFromHex(0xF9F9F9);
    self.gameNewButton.layer.cornerRadius = 22;
    self.gameNewButton.layer.borderColor = Color_1296DB.CGColor;
    self.gameNewButton.layer.borderWidth = 1;
    self.gamaContinueButton.layer.cornerRadius = 22;
}

# pragma mark -- setting
- (IBAction)toSetting:(id)sender {
    LENSettingViewController *vc = [LENSettingViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}

# pragma mark -- record
- (IBAction)toRecord:(id)sender {
    LENRecordsViewController *vc = [LENRecordsViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}


# pragma mark -- new game
- (IBAction)gameNew:(UIButton *)sender {
    LENSudokuModel *model = [LENHandle currentSudokuRead];
    if (model) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"当前有游戏未完成，创建新游戏则丢失上次游戏进入" preferredStyle:(UIAlertControllerStyleAlert)];
        [alert addAction:[UIAlertAction actionWithTitle:@"创建新游戏" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
            [LENHandle sudokuInsertToSudokusWithSudoku:model status:1];
            [LENHandle currentSudokuSave:nil];
            self.gamaContinueButton.hidden = YES;
            [self gameNewAlert];
        }]];
        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        [self presentViewController:alert animated:YES completion:nil];
    } else {
        [self gameNewAlert];
    }
}

- (void)gameNewAlert{
    NSArray *titles = @[@"难度一", @"难度二", @"难度三", @"难度四", @"难度五", @"难度六", @"难度七"];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:(UIAlertControllerStyleActionSheet)];
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

# pragma mark -- continue game
- (IBAction)continueGame:(UIButton *)sender {
    LENSudokuModel *model = [LENHandle currentSudokuRead];
    LENSudokuViewController *vc = [LENSudokuViewController new];
    vc.model = model;
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
