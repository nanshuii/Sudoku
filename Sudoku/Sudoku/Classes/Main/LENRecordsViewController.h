//
//  LENRecordsViewController.h
//  Sudoku
//
//  Created by 戴十三 on 2020/1/21.
//  Copyright © 2020 ledon. All rights reserved.
//

#import "LENBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface LENRecordsViewController : LENBaseViewController

@property (weak, nonatomic) IBOutlet UILabel *todayCurrentLabel;

@property (weak, nonatomic) IBOutlet UILabel *todayFinish;

@property (weak, nonatomic) IBOutlet UILabel *todayEnd;

@property (weak, nonatomic) IBOutlet UILabel *monthFinish;

@property (weak, nonatomic) IBOutlet UILabel *monthEnd;



@end

NS_ASSUME_NONNULL_END
