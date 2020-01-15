//
//  LENSudokuNumberView.m
//  Sudoku
//
//  Created by 戴十三 on 2020/1/13.
//  Copyright © 2020 ledon. All rights reserved.
//

#import "LENSudokuNumberView.h"
#import "LENSudokuNumberSingleView.h"

@interface LENSudokuNumberView()

@property (nonatomic, assign) LENSudokuStyle style;

@property (nonatomic, assign) CGFloat margin;

@property (nonatomic, assign) CGFloat itemWidth;

@property (nonatomic, assign) CGFloat itemMargin;

@property (nonatomic, strong) UIView *contentView;

@property (nonatomic, strong) NSMutableArray *items;



@end

@implementation LENSudokuNumberView

- (instancetype)initWithFrame:(CGRect)frame style:(LENSudokuStyle)style{
    self = [super initWithFrame:frame];
    if (self) {
        self.style = style;
        self.isEditing = NO;
        self.items = [NSMutableArray arrayWithCapacity:9];
        [self configureUI];
    }
    return self;
}

- (void)configureUI{
    WEAKSELF(weakSelf);
    // 页面适配计算
    CGFloat itemWidth = 44;
    CGFloat itemMargin = 10;
    CGFloat margin = (kFullScreenWidth - itemWidth * 9 - itemMargin * 8) / 2;
    if (margin < 20) {
        self.itemMargin = 5;
        self.margin = 20;
        self.itemWidth = (kFullScreenWidth - self.margin * 2 - self.itemMargin * 8) / 9;
    } else {
        self.margin = margin;
        self.itemWidth = itemWidth;
        self.margin = itemMargin;
    }
    // content view
    self.contentView = [[UIView alloc] initWithFrame:CGRectMake(self.margin, 0, kFullScreenWidth - self.margin * 2, self.itemWidth)];
    self.contentView.backgroundColor = [UIColor clearColor];
    [self addSubview:self.contentView];
    // items
    for (int i = 0; i < 9; i++) {
        LENSudokuNumberSingleView *view = [[LENSudokuNumberSingleView alloc] initWithFrame:CGRectMake(self.itemMargin * i + self.itemWidth * i, 0, self.itemWidth, self.itemWidth) style:self.style number:i+1];
        [view setTapBlock:^(int number) {
            [weakSelf tapNumber:number];
        }];
        [self.contentView addSubview:view];
        [self.items addObject:view];
    }
}

- (void)tapNumber:(int)number{
    if (self.tapNumberBlock) {
        self.tapNumberBlock(number, self.isEditing);
    }
}

# pragma mark -- 编辑模式开关
- (void)beEditing:(BOOL)editing{
    for (LENSudokuNumberSingleView *item in self.items) {
        [item beEditing:editing];
    }
    self.isEditing = editing;
}

# pragma mark -- 复原
- (void)recovery{
    self.isEditing = NO;
    for (LENSudokuNumberSingleView *item in self.items) {
        item.hidden = NO;
        [item recovery];
    }
}

@end
