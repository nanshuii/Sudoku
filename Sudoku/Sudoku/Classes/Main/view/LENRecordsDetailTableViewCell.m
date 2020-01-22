//
//  LENRecordsDetailTableViewCell.m
//  Sudoku
//
//  Created by 戴十三 on 2020/1/22.
//  Copyright © 2020 ledon. All rights reserved.
//

#import "LENRecordsDetailTableViewCell.h"

@implementation LENRecordsDetailTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configureForCellModel:(id)cellModel{
    LENSudokuModel *sudoku = (LENSudokuModel *)cellModel;
    NSString *typeString = [LENHandle typeStringWithType:sudoku.type];
    self.typeLabel.text = typeString;
    NSString *statusString = @"";
    NSInteger status = sudoku.status;
    if (status == 1) {
        statusString = @"放弃";
        self.errorLabel.hidden = YES;
    } else if (status == 2) {
        statusString = @"完成";
        self.errorLabel.hidden = NO;
    }
    NSString *timeString = [NSString stringWithFormat:@"%@ %@", sudoku.endTimeString_hms, statusString];
    self.timeLabel.text = timeString;
    NSString *timerString = [self timerStringWithTime:sudoku.time];
    self.timerLabel.text = timerString;
    NSInteger errorTimes = sudoku.errorTimes;
    if (errorTimes == 0) {
        self.errorLabel.text = @"完美";
    } else {
        self.errorLabel.text = [NSString stringWithFormat:@"%li次错误", errorTimes];
    }
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

@end
