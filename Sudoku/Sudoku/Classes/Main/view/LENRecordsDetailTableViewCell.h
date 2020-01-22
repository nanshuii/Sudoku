//
//  LENRecordsDetailTableViewCell.h
//  Sudoku
//
//  Created by 戴十三 on 2020/1/22.
//  Copyright © 2020 ledon. All rights reserved.
//

#import "LENBaseTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface LENRecordsDetailTableViewCell : LENBaseTableViewCell

@property (weak, nonatomic) IBOutlet UILabel *typeLabel;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UILabel *timerLabel;

@property (weak, nonatomic) IBOutlet UILabel *errorLabel;


- (void)configureForCellModel:(id)cellModel;

@end

NS_ASSUME_NONNULL_END
