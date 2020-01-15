//
//  LENSudokuSingleView.m
//  Sudoku
//
//  Created by 林南水 on 2020/1/6.
//  Copyright © 2020 ledon. All rights reserved.
//

#import "LENSudokuSingleView.h"

@interface LENSudokuSingleView()

@property (nonatomic, strong) LENSudokuSingleModel *model;

@property (nonatomic, assign) LENSudokuStyle style;

@property (nonatomic, strong) UIView *normalView; // 在填入数字和没有填入数字的视图

@property (nonatomic, strong) UILabel *normalLabel;

@property (nonatomic, strong) UIView *highLightView;

@property (nonatomic, strong) UIView *markView; // 在填入笔记数字的视图

@property (nonatomic, strong) NSMutableArray *maskLabels;

@property (nonatomic, strong) UILabel *markLabel;


@end

@implementation LENSudokuSingleView

- (instancetype)initWithFrame:(CGRect)frame model:(LENSudokuSingleModel *)model style:(LENSudokuStyle)style{
    self = [super initWithFrame:frame];
    if (self) {
        self.model = model;
        self.style = style;
        self.maskLabels = [NSMutableArray arrayWithCapacity:9];
        [self configureUI];
    }
    return self;
}

- (void)configureUI{
    self.normalView = [[UIView alloc] initWithFrame:self.bounds];
    self.normalView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.normalView];
    
    self.normalLabel = [UILabel new];
    self.normalLabel.font = [UIFont systemFontOfSize:12];
    self.normalLabel.textColor = [UIColor darkGrayColor];
    self.normalLabel.text = [NSString stringWithFormat:@"%li", (long)self.model.fillIn];
    [self.normalView addSubview:self.normalLabel];
    [self.normalLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.normalView.mas_centerX);
        make.centerY.mas_equalTo(self.normalView.mas_centerY);
    }];
    self.markView = [[UIView alloc] initWithFrame:self.bounds];
    self.markView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.markView];
    
    self.markLabel = [[UILabel alloc] initWithFrame:self.markView.bounds];
    self.markLabel.font = [UIFont systemFontOfSize:8];
    self.markLabel.textColor = [UIColor blackColor];
    self.markLabel.textAlignment = NSTextAlignmentCenter;
    self.markLabel.numberOfLines = 0;
    NSString *markString = @"";
    self.markLabel.text = markString;
    [self.markView addSubview:self.markLabel];
    [self.markLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.markView.mas_top).offset(4);
        make.left.mas_equalTo(self.markView.mas_left).offset(4);
        make.right.mas_equalTo(self.markView.mas_right).offset(-4);
        make.bottom.mas_equalTo(self.markView.mas_bottom).offset(-4);
    }];
    
    CGFloat margin = 2;
    self.highLightView = [[UIView alloc] initWithFrame:CGRectMake(margin, margin, self.frame.size.width - margin * 2,  self.frame.size.width - margin * 2)];
    self.highLightView.backgroundColor = [UIColor clearColor];
    self.highLightView.layer.borderColor = [UIColor redColor].CGColor;
    self.highLightView.layer.borderWidth = 2;
    self.highLightView.hidden = YES;
    [self addSubview:self.highLightView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [self addGestureRecognizer:tap];
    
    if (self.model.status == LENSudokuSingleStatusFillIn) {
        self.normalLabel.hidden = NO;
    }
    else if (self.model.status == LENSudokuStyleNone) {
        self.normalLabel.hidden = YES;
    }
    else {
        self.normalLabel.hidden = YES;
    }
}

- (void)configureUIStatus:(LENSudokuSingleStatus)status{
    if (status == LENSudokuSingleStatusNone) {
        self.normalView.hidden = NO;
        self.normalLabel.hidden = YES;
        self.markView.hidden = YES;
    }
    else if (status == LENSudokuSingleStatusmark) {
        self.normalView.hidden = YES;
        self.normalLabel.hidden = YES;
        self.markView.hidden = NO;
    }
    else if (status == LENSudokuSingleStatusFillIn) {
        self.normalView.hidden = NO;
        self.normalLabel.hidden = NO;
        self.markView.hidden = YES;
    }
}

# pragma mark -- 修改status
- (void)statusUpdateWithStatus:(LENSudokuSingleStatus)status{
    self.model.status = status;
    [self configureUIStatus:status];
}

# pragma mark -- 点击效果
- (void)tap:(UITapGestureRecognizer *)sender{
    NSLog(@"tap section = %li row = %li", self.model.section, self.model.row);
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

# pragma mark -- 修改格子里的marks
- (void)markUpdateWithMarks:(NSMutableArray *)marks{
    self.model.marks = marks;
    self.markLabel.text = [self marksString];
//    self.markView.hidden = NO;
}

# pragma mark -- marks排列
- (NSString *)marksString{
    NSString *string = @"";
    for (NSNumber *number in self.model.marks) {
        int mark = [number intValue];
        string = [NSString stringWithFormat:@"%@ %i", string, mark];
    }
    return string;
}




@end
