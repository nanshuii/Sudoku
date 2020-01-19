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

@property (nonatomic, strong) NSMutableArray *normalHiddens;

@end

@implementation LENSudokuNumberView

- (instancetype)initWithFrame:(CGRect)frame style:(LENSudokuStyle)style normalHiddens:(nonnull NSMutableArray *)normalHiddens{
    self = [super initWithFrame:frame];
    if (self) {
        self.style = style;
        self.isEditing = NO;
        self.items = [NSMutableArray arrayWithCapacity:9];
        self.normalHiddens = normalHiddens;
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
        LENSudokuNumberStatus status = LENSudokuNumberStatusNormal;
        if ([self.normalHiddens containsObject:[NSNumber numberWithInt:i+1]]) {
            status = LENSudokuNumberStatusNormalHidden;
        }
        LENSudokuNumberSingleView *view = [[LENSudokuNumberSingleView alloc] initWithFrame:CGRectMake(self.itemMargin * i + self.itemWidth * i, 0, self.itemWidth, self.itemWidth) style:self.style number:i+1 status:status];
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
- (void)beEditing:(BOOL)editing sudokuViewStatus:(LENSudokuViewStatus)sudokuViewStatus sudokuSingle:(nonnull LENSudokuSingleModel *)sudokuSingle{
    // normal -> mark
    if (editing) {
        // 没有任何点击的时候，mark全部为不可点击
        if (sudokuViewStatus == LENSudokuViewStatusNone) {
            for (LENSudokuNumberSingleView *item in self.items) {
                [item statusUpdateWithStatus:LENSudokuNumberStatusMarkEnable editing:YES];
            }
        }
        // 点击一个空的或是mark的格子
        else if (sudokuViewStatus == LENSudokuViewStatusPrepareFillInOrMask) {
            // 点击空格子，mark全部正常显示
            if (sudokuSingle.status == LENSudokuSingleStatusNone) {
                for (LENSudokuNumberSingleView *item in self.items) {
                    [item statusUpdateWithStatus:LENSudokuNumberStatusMark editing:YES];
                }
            }
            // 点击mark格子，部分正常显示，部分点击状态
            else if (sudokuSingle.status == LENSudokuSingleStatusmark) {
                NSMutableArray *marks = sudokuSingle.marks;
                for (int i = 0; i < self.items.count; i++) {
                    LENSudokuNumberSingleView *item = self.items[i];
                    if ([marks containsObject:@(i+1)]) {
                        [item statusUpdateWithStatus:LENSudokuNumberStatusMarkSelected editing:YES];
                    } else {
                        [item statusUpdateWithStatus:LENSudokuNumberStatusMark editing:YES];
                    }
                }
            }
        }
        // 点击一个填入数字的格子，mark全部不可点击
        else if (sudokuViewStatus == LENSudokuViewStatusHighLightPart) {
            for (LENSudokuNumberSingleView *item in self.items) {
                [item statusUpdateWithStatus:LENSudokuNumberStatusMarkEnable editing:YES];
            }
        }
    }
    // mark -> normal
    else {
        // 未点击状态，部分隐藏，部分不可点击状态
        // 点击一个填有数字的，部分隐藏，部分不可点击状态
        if (sudokuViewStatus == LENSudokuViewStatusNone || sudokuViewStatus == LENSudokuViewStatusHighLightPart) {
            for (int i = 0; i < self.items.count; i++) {
               LENSudokuNumberSingleView *item = self.items[i];
                if ([self.normalHiddens containsObject:@(i+1)]) {
                    [item statusUpdateWithStatus:LENSudokuNumberStatusNormalHidden editing:NO];
                } else {
                    [item statusUpdateWithStatus:LENSudokuNumberStatusNormalEnable editing:NO];
                }
            }
        }
        // 点击一个空的或是mark格子，部分隐藏，部分正常
        else if (sudokuViewStatus == LENSudokuViewStatusPrepareFillInOrMask) {
            for (int i = 0; i < self.items.count; i++) {
               LENSudokuNumberSingleView *item = self.items[i];
                if ([self.normalHiddens containsObject:@(i+1)]) {
                    [item statusUpdateWithStatus:LENSudokuNumberStatusNormalHidden editing:NO];
                } else {
                    [item statusUpdateWithStatus:LENSudokuNumberStatusNormal editing:NO];
                }
            }
        }
    }
        
    self.isEditing = editing;
}

# pragma mark -- 更改normal下需要隐藏的部分
- (void)normalHiddensUpdate:(NSMutableArray *)normalHiddens{
    self.normalHiddens = normalHiddens;
}

# pragma mark -- normal下除了要隐藏的部分，全部变为不可点击的状态
- (void)normalEnableAll{
    for (int i = 0; i < self.items.count; i++) {
       LENSudokuNumberSingleView *item = self.items[i];
        if ([self.normalHiddens containsObject:@(i+1)]) {
            [item statusUpdateWithStatus:LENSudokuNumberStatusNormalHidden editing:NO];
        } else {
            [item statusUpdateWithStatus:LENSudokuNumberStatusNormalEnable editing:NO];
        }
    }
}

# pragma mark -- normal下除了要隐藏的部分，全部变为normal状态
- (void)normalAll{
    for (int i = 0; i < self.items.count; i++) {
       LENSudokuNumberSingleView *item = self.items[i];
        if ([self.normalHiddens containsObject:@(i+1)]) {
            [item statusUpdateWithStatus:LENSudokuNumberStatusNormalHidden editing:NO];
        } else {
            [item statusUpdateWithStatus:LENSudokuNumberStatusNormal editing:NO];
        }
    }
}

# pragma mark -- mark模式下因为键入的关系，减少或增加markSelected状态的值
- (void)markAdd:(BOOL)add number:(int)number{
    LENSudokuNumberSingleView *item = self.items[number-1];
    if (add) {
        [item statusUpdateWithStatus:(LENSudokuNumberStatusMarkSelected) editing:YES];
    } else {
        [item statusUpdateWithStatus:(LENSudokuNumberStatusMark) editing:YES];
    }
}

# pragma mark -- suppose
- (void)supposeOpen{
    self.isEditing = NO;
    [self normalAll];
}

# pragma mark -- 复原
- (void)recovery{
    self.isEditing = NO;
    [self normalEnableAll];
}

@end
