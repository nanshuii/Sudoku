//
//  LENSettingViewController.m
//  Sudoku
//
//  Created by 戴十三 on 2020/1/21.
//  Copyright © 2020 ledon. All rights reserved.
//

#import "LENSettingViewController.h"

@interface LENSettingViewController ()

@property (nonatomic, strong) LENDefaultConfigModel *defaultConfigureModel;

@property (nonatomic, assign) CGFloat volume;

@end

@implementation LENSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.defaultConfigureModel = [LENHandle defaultConfigureRead];
    self.volume = self.defaultConfigureModel.volume;
    [self configureUI];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.defaultConfigureModel.volume = self.volume;
    [LENHandle defaultConfigureSave:self.defaultConfigureModel];
}

- (void)configureUI{
    self.view.backgroundColor = Color_F9F9F9;
    self.title = @"设置";
    [self defaultConfigureSetting];
}

- (void)defaultConfigureSetting{
    self.volumeSlider.value = self.defaultConfigureModel.volume;
    [self.timerHiddenSwitch setOn:self.defaultConfigureModel.timerHidden];
    [self.supposeMarkHiddenSwitch setOn:self.defaultConfigureModel.supposeCloseMark];
}

# pragma mark -- 音量调节
- (IBAction)volumeSliderChange:(UISlider *)sender {
    self.volume = sender.value;
}

# pragma mark -- 计时器隐藏
- (IBAction)timerHIddenSwitchChange:(UISwitch *)sender {
    SSLog(@"计时器隐藏");
    BOOL on = sender.on;
    self.defaultConfigureModel.timerHidden = on;
    [LENHandle defaultConfigureSave:self.defaultConfigureModel];
}

# pragma mark -- 预设下笔记隐藏
- (IBAction)supposeMarkHiddenSwitchChange:(UISwitch *)sender {
    SSLog(@"预设下笔记隐藏");
    BOOL on = sender.on;
    self.defaultConfigureModel.supposeCloseMark = on;
    [LENHandle defaultConfigureSave:self.defaultConfigureModel];
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
