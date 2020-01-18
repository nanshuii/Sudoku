//
//  LENMainViewController.m
//  Sudoku
//
//  Created by 林南水 on 2020/1/6.
//  Copyright © 2020 ledon. All rights reserved.
//

#import "LENMainViewController.h"
#import "LENSudokuViewController.h"

@interface LENMainViewController ()

@end

@implementation LENMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    LENSudokuModel *model = [LENHandle currentSudokuRead];
    if (model) {
        self.continueButton.hidden = NO;
    } else {
        self.continueButton.hidden = YES;
    }
}


- (IBAction)jump:(id)sender {
    NSLog(@"jump");
    LENSudokuModel *model = [LENHandle sudoKuCreateWithType:(LENSudokuTypeHard) style:(LENSudokuStyleNone)];
    LENSudokuViewController *vc = [LENSudokuViewController new];
    vc.model = model;
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (IBAction)continueButtonAction:(id)sender {
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
