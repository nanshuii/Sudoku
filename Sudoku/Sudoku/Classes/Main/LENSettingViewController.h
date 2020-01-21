//
//  LENSettingViewController.h
//  Sudoku
//
//  Created by 戴十三 on 2020/1/21.
//  Copyright © 2020 ledon. All rights reserved.
//

#import "LENBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface LENSettingViewController : LENBaseViewController

@property (weak, nonatomic) IBOutlet UISlider *volumeSlider;

@property (weak, nonatomic) IBOutlet UISwitch *timerHiddenSwitch;

@property (weak, nonatomic) IBOutlet UISwitch *supposeMarkHiddenSwitch;


@end

NS_ASSUME_NONNULL_END
