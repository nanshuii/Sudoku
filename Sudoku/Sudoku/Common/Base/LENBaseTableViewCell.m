//
//  LENBaseTableViewCell.m
//  Sudoku
//
//  Created by 戴十三 on 2020/1/22.
//  Copyright © 2020 ledon. All rights reserved.
//

#import "LENBaseTableViewCell.h"

@implementation LENBaseTableViewCell

+ (UINib *)nib
{
    return [UINib nibWithNibName:NSStringFromClass([self class]) bundle:nil];
}

+ (NSString *)myClassNameAsCellIdentifier{
    return  NSStringFromClass([self class]);
}
- (void)awakeFromNib {
    // Initialization code
     [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configureForCellModel:(id) cellModel{
    //please rewrite in subclass
    NSLog(@"please rewrite in subclass, thanks");
}

@end
