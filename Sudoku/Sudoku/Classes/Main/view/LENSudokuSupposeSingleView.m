//
//  LENSudokuSupposeSingleView.m
//  Sudoku
//
//  Created by 戴十三 on 2020/1/19.
//  Copyright © 2020 ledon. All rights reserved.
//

#import "LENSudokuSupposeSingleView.h"

@interface LENSudokuSupposeSingleView()

@property (nonatomic, strong) LENSudokuSingleModel *model;

@property (nonatomic, assign) LENSudokuStyle style;

@property (nonatomic, strong) LENSudokuStyleModel *styleModel;

@property (nonatomic, strong) UIView *normalView; // 在填入数字和没有填入数字的视图

@property (nonatomic, strong) UILabel *normalLabel;

@property (nonatomic, strong) UIView *highLightView;

@end

@implementation LENSudokuSupposeSingleView

- (instancetype)initWithFrame:(CGRect)frame single:(LENSudokuSingleModel *)model{
    self = [super initWithFrame:frame];
    if (self) {
        self.model = model;
        self.style = [LENHandle defaultConfigureRead].style;
        self.styleModel = [LENHandle styleModelWithStyle:self.style];
        [self configureUI];
    }
    return self;
}

- (void)configureUI{
    self.backgroundColor = [UIColor clearColor];
    self.normalView = [[UIView alloc] initWithFrame:self.bounds];
    if ([LENHandle defaultConfigureRead].supposeCloseMark) {
        self.normalView.backgroundColor = self.styleModel.sudokuSupposeSingleBackgroundColor;
    } else {
        self.normalView.backgroundColor = [UIColor clearColor];
    }
    [self addSubview:self.normalView];
    
    self.normalLabel = [UILabel new];
    self.normalLabel.font = FONTBOLD(18);
    self.normalLabel.textColor = self.styleModel.sudokuViewSingleFillInTextColor;
    self.normalLabel.text = [NSString stringWithFormat:@"%li", (long)self.model.fillIn];
    [self.normalView addSubview:self.normalLabel];
    [self.normalLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.normalView.mas_centerX);
        make.centerY.mas_equalTo(self.normalView.mas_centerY);
    }];
    self.highLightView = [[UIView alloc] initWithFrame:self.bounds];
    self.highLightView.backgroundColor = self.styleModel.sudokuSupposeSingleHighLightBackgroundColor;
    self.highLightView.alpha = 0.3;
    self.highLightView.hidden = YES;
    [self addSubview:self.highLightView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [self addGestureRecognizer:tap];
    
    [self configureUIStatus:self.model.status];
}

- (void)configureUIStatus:(LENSudokuSingleStatus)status{
    if (status == LENSudokuSingleStatusNone) {
        self.normalLabel.hidden = YES;
    }
    else if (status == LENSudokuSingleStatusFillIn) {
        self.normalLabel.hidden = NO;
        self.normalLabel.textColor = self.styleModel.sudokuViewSingleFillInTextColor;
        self.normalLabel.text = [NSString stringWithFormat:@"%li", (long)self.model.fillIn];
        self.normalLabel.font = FONTBOLD(18);;
    }
    else if (status == LENSudokuSingleStatusSupposeFillIn) {
        self.normalLabel.hidden = NO;
        self.normalLabel.textColor = self.styleModel.sudokuSupposeSingleFillInTextColor;
        self.normalLabel.text = [NSString stringWithFormat:@"%li", (long)self.model.supposeFillIn];
        self.normalLabel.font = FONTDEFAULT(12);
    }
    else if (status == LENSudokuSingleStatusSupposeFillInError) {
        self.normalLabel.hidden = NO;
        self.normalLabel.textColor = self.styleModel.sudokuSupposeSingleFillInErrorTextColor;
        self.normalLabel.text = [NSString stringWithFormat:@"%li", (long)self.model.supposeFillIn];
        self.normalLabel.font = FONTDEFAULT(12);
    }
}

# pragma mark -- 修改status
- (void)statusUpdateWithStatus:(LENSudokuSingleStatus)status{
    self.model.status = status;
    [self configureUIStatus:status];
}

# pragma mark -- 点击效果
- (void)tap:(UITapGestureRecognizer *)sender{
    if (self.tapBlock) {
        self.tapBlock(self.model.section, self.model.row);
    }
}

# pragma mark -- 高亮显示
- (void)highLightShow{
    self.highLightView.hidden = NO;
}

# pragma mark -- 高亮隐藏
- (void)heighLightHidden{
    self.highLightView.hidden = YES;
}

@end
