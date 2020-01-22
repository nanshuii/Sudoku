//
//  LENBaseTableViewCell.h
//  Sudoku
//
//  Created by 戴十三 on 2020/1/22.
//  Copyright © 2020 ledon. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LENBaseTableViewCell : UITableViewCell

+ (UINib *)nib;

+ (NSString*)myClassNameAsCellIdentifier;

- (void)configureForCellModel:(id) cellModel;

@end

NS_ASSUME_NONNULL_END
