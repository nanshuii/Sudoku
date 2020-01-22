//
//  LENRecordsDetailViewController.h
//  Sudoku
//
//  Created by 戴十三 on 2020/1/22.
//  Copyright © 2020 ledon. All rights reserved.
//

#import "LENBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface LENRecordsDetailViewController : LENBaseViewController

@property (nonatomic, strong) NSMutableArray *records;

@property (nonatomic, strong) NSMutableArray *months;

@property (nonatomic, assign) BOOL isToday;

@property (nonatomic, strong) NSMutableArray *typesDone;

@property (nonatomic, strong) NSMutableArray *typesFinish;

@property (weak, nonatomic) IBOutlet UISegmentedControl *segment;

@property (weak, nonatomic) IBOutlet UILabel *statusLabel;

@property (weak, nonatomic) IBOutlet UILabel *statusNumberLabel;

@property (weak, nonatomic) IBOutlet UILabel *typeLabel1;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *typeLabel1Top; // default 10

@property (weak, nonatomic) IBOutlet UILabel *typeLabel2;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *typeLabel2Top; // default 5

@property (weak, nonatomic) IBOutlet UILabel *typeLabel3;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *typeLabel3Top; // default 5

@property (weak, nonatomic) IBOutlet UILabel *typeLabel4;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *typeLabel4Top; // default 5

@property (weak, nonatomic) IBOutlet UILabel *typeLabel5;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *typeLabel5Top; // default 5

@property (weak, nonatomic) IBOutlet UILabel *typeLabel6;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *typeLabel6Top; // default 5

@property (weak, nonatomic) IBOutlet UILabel *typeLabel7;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *typeLabel7Top;

@property (weak, nonatomic) IBOutlet UIView *contentView;








@end

NS_ASSUME_NONNULL_END
