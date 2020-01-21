//
//  LENRecordsViewController.m
//  Sudoku
//
//  Created by 戴十三 on 2020/1/21.
//  Copyright © 2020 ledon. All rights reserved.
//

#import "LENRecordsViewController.h"

@interface LENRecordsViewController ()

@property (nonatomic, strong) NSMutableArray *records;

@end

@implementation LENRecordsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.records = [LENHandle sudokuModelsRead];
    SSLog(@"records = %@", self.records.description);
    [self configureUI];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)configureUI{
    self.navigationController.navigationBarHidden = NO;
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
