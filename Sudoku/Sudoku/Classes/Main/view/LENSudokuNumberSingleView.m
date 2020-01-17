//
//  LENSudokuNumberSingleView.m
//  Sudoku
//
//  Created by 戴十三 on 2020/1/13.
//  Copyright © 2020 ledon. All rights reserved.
//

#import "LENSudokuNumberSingleView.h"

@interface LENSudokuNumberSingleView()

@property (nonatomic, assign) LENSudokuStyle style;

@property (nonatomic, strong) UIView *view;

@property (nonatomic, strong) UIView *highLightView;

@property (nonatomic, strong) UILabel *label;

@property (nonatomic, assign) int number;

// nomal
@property (nonatomic, strong) UIView *normalView;

@property (nonatomic, strong) UIView *normalBgView;

@property (nonatomic, strong) UILabel *normalLabel;

// mark
@property (nonatomic, strong) UIView *markView;

@property (nonatomic, strong) UIView *markBgView;

@property (nonatomic, strong) UIView *markSelectedView;

@property (nonatomic, strong) UILabel *markLabel;

@end

@implementation LENSudokuNumberSingleView

- (instancetype)initWithFrame:(CGRect)frame style:(LENSudokuStyle)style number:(int)number status:(LENSudokuNumberStatus)status{
    self = [super initWithFrame:frame];
    if (self) {
        self.style = style;
        self.number = number;
        self.status = status;
        [self configureUI];
    }
    return self;
}

- (void)configureUI{
    // normal
    self.normalView = [[UIView alloc] initWithFrame:self.bounds];
    self.normalView.backgroundColor = [UIColor clearColor];
    [self addSubview:self.normalView];
    
    self.normalBgView = [[UIView alloc] initWithFrame:self.normalView.bounds];
    self.normalBgView.backgroundColor = [UIColor blueColor];
    [self.normalView addSubview:self.normalBgView];
    
    self.normalLabel = [UILabel new];
    self.normalLabel.font = [UIFont systemFontOfSize:12];
    self.normalLabel.textColor = [UIColor whiteColor];
    self.normalLabel.text = [NSString stringWithFormat:@"%i", self.number];
    [self.normalView addSubview:self.normalLabel];
    [self.normalLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.normalView.mas_centerX);
        make.centerY.mas_equalTo(self.normalView.mas_centerY);
    }];
    
    // mark
    self.markView = [[UIView alloc] initWithFrame:self.bounds];
    self.markView.backgroundColor = [UIColor clearColor];
    self.markView.hidden = YES;
    [self addSubview:self.markView];
    
    self.markBgView = [[UIView alloc] initWithFrame:self.markView.bounds];
    self.markBgView.backgroundColor = [UIColor lightGrayColor];
    [self.markView addSubview:self.markBgView];
    
    self.markSelectedView = [[UIView alloc] initWithFrame:self.markView.bounds];
    self.markSelectedView.backgroundColor = [UIColor lightGrayColor];
    self.markSelectedView.layer.borderColor = [UIColor darkGrayColor].CGColor;
    self.markSelectedView.layer.borderWidth = 1;
    self.markSelectedView.hidden = YES;
    [self.markView addSubview:self.markSelectedView];
    
    self.markLabel = [UILabel new];
    self.markLabel.font = [UIFont systemFontOfSize:12];
    self.markLabel.textColor = [UIColor darkGrayColor];
    self.markLabel.text = [NSString stringWithFormat:@"%i", self.number];
    [self.markLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.markView.mas_centerX);
        make.centerY.mas_equalTo(self.markView.mas_centerY);
    }];
    
    // tap
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
    [self addGestureRecognizer:tap];
    
    if (self.status == LENSudokuNumberStatusNormalHidden) {
        self.hidden = YES;
    }
}

- (void)tap{
    if (self.tapBlock) {
        self.tapBlock(self.number);
    }
}

# pragma mark -- edit
- (void)beEditing:(BOOL)editing{
    if (editing) {
        self.normalView.hidden = YES;
        self.markView.hidden = NO;
    } else {
        self.normalView.hidden = YES;
        self.markView.hidden = NO;
    }
}

# pragma mark -- recovery
- (void)recovery{
    self.label.textColor = [UIColor blackColor];
    self.highLightView.hidden = YES;
}

# pragma mark -- 状态变更
- (void)statusUpdateWithStatus:(LENSudokuNumberStatus)status editing:(BOOL)editing{
    self.hidden = NO;
    // normal和mark的转变
    if (editing) {
        self.normalView.hidden = YES;
        self.markView.hidden = NO;
    } else {
        self.normalView.hidden = YES;
        self.markView.hidden = NO;
    }
    
    // mark下不可点击的状态
    if (status == LENSudokuNumberStatusMarkEnable) {
        self.markSelectedView.hidden = YES;
        self.markLabel.textColor = [UIColor grayColor];
    }
    // mark下状态
    else if (status == LENSudokuNumberStatusMark) {
        self.markSelectedView.hidden = YES;
        self.markLabel.textColor = [UIColor darkGrayColor];
    }
    // mark下选择的状态
    else if (status == LENSudokuNumberStatusMarkSelected) {
        self.markSelectedView.hidden = NO;
        self.markLabel.textColor = [UIColor darkGrayColor];
    }
    // normal
    else if (status == LENSudokuNumberStatusNormal) {
        self.normalLabel.textColor = [UIColor blueColor];
    }
    // normal下不可点击
    else if (status == LENSudokuNumberStatusNormalEnable) {
        self.normalLabel.textColor = [UIColor blueColor];
    }
    // normal下隐藏
    else if (status == LENSudokuNumberStatusNormalHidden) {
        self.normalView.hidden = YES;
         
    }
}

@end
