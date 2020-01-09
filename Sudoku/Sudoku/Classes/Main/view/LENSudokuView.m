//
//  LENSudokuView.m
//  Sudoku
//
//  Created by 林南水 on 2020/1/6.
//  Copyright © 2020 ledon. All rights reserved.
//

#import "LENSudokuView.h"
#import "LENSudokuSingleView.h"

@interface LENSudokuView()

@property (nonatomic, strong) LENSudokuModel *sudoku;

@property (nonatomic, assign) LENSudokuType type;

@property (nonatomic, assign) LENSudokuStyle style;

@property (nonatomic, strong) NSMutableArray <LENSudokuSingleModel *> *singles;

@property (nonatomic, assign) CGFloat width;

@property (nonatomic, assign) CGFloat margin;

@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) NSMutableArray <UIView *> *lines;

@property (nonatomic, strong) NSMutableArray <LENSudokuSingleView *> *singleViews;

@end

@implementation LENSudokuView

- (instancetype)initWithFrame:(CGRect)frame sudoku:(LENSudokuModel *)sudoku{
    self = [super initWithFrame:frame];
    if (self) {
        self.type = sudoku.type;
        self.style = sudoku.style;
        self.singles = sudoku.singles;
        [self configureUI];
    }
    return self;
}

- (void)configureUI{
    self.margin = 2;
    self.width = (self.frame.size.width - self.margin * 2) / 9;
    
    self.backgroundColor = [UIColor clearColor];
    [self bgViewCreate];
    [self singlesCreate];
    [self linesCreate];
}

# pragma mark -- 背景图创建
- (void)bgViewCreate{
    self.bgView = [[UIView alloc] initWithFrame:self.bounds];
    self.bgView.layer.borderWidth = self.margin;
    self.bgView.layer.borderColor = [UIColor redColor].CGColor;
    [self addSubview:self.bgView];
}

# pragma mark -- 线条创建
- (void)linesCreate{
    self.lines = [NSMutableArray arrayWithCapacity:18];
    UIColor *lineColor = [UIColor lightGrayColor];
    CGFloat line_width = self.frame.size.width - self.margin * 2;
    CGFloat line_height = 1;
    // 横排
    for (int i = 0; i < 9; i++) {
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(self.margin, i * self.width + self.margin, line_width, line_height)];
        line.backgroundColor = lineColor;
        [self addSubview:line];
        [self.lines addObject:line];
    }
    // 竖排
    for (int i = 0; i < 9; i++) {
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(i * self.width + self.margin, self.margin, line_height, line_width)];
        line.backgroundColor = lineColor;
        [self addSubview:line];
        [self.lines addObject:line];
    }
}

# pragma mark -- 格子创建
- (void)singlesCreate{
    self.singleViews = [NSMutableArray arrayWithCapacity:81];
    for (LENSudokuSingleModel *model in self.singles) {
        NSInteger section = model.section;
        NSInteger row = model.row;
        LENSudokuSingleView *view = [[LENSudokuSingleView alloc] initWithFrame:CGRectMake(self.margin + row * self.width, self.margin + section * self.width, self.width, self.width) model:model];
        [self addSubview:view];
        [self.singleViews addObject:view];
    }
}

@end
