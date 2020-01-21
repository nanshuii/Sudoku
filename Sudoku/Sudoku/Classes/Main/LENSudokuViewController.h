//
//  LENSudokuViewController.h
//  Sudoku
//
//  Created by 林南水 on 2020/1/6.
//  Copyright © 2020 ledon. All rights reserved.
//

#import "LENBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface LENSudokuViewController : LENBaseViewController

@property (nonatomic, strong) LENSudokuModel *model;

@property (weak, nonatomic) IBOutlet UIView *contentView;

@property (weak, nonatomic) IBOutlet UIView *bottomView;

@property (weak, nonatomic) IBOutlet UILabel *errorLabel;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UIView *numberView;

// 底部功能栏
@property (weak, nonatomic) IBOutlet UIView *bottom_view1;

@property (weak, nonatomic) IBOutlet UIImageView *bottom_image1;

@property (weak, nonatomic) IBOutlet UILabel *bottom_label1;

@property (weak, nonatomic) IBOutlet UIView *bottom_view2;

@property (weak, nonatomic) IBOutlet UIImageView *bottom_image2;

@property (weak, nonatomic) IBOutlet UILabel *bottom_label2;

@property (weak, nonatomic) IBOutlet UIView *bottom_view3;

@property (weak, nonatomic) IBOutlet UIImageView *bottom_image3;

@property (weak, nonatomic) IBOutlet UILabel *bottom_label3;

@property (weak, nonatomic) IBOutlet UIView *bottom_view4;

@property (weak, nonatomic) IBOutlet UIImageView *bottom_image4;

@property (weak, nonatomic) IBOutlet UILabel *bottom_label4;





@end

NS_ASSUME_NONNULL_END
