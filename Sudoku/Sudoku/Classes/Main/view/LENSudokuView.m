//
//  LENSudokuView.m
//  Sudoku
//
//  Created by 林南水 on 2020/1/6.
//  Copyright © 2020 ledon. All rights reserved.
//

#import "LENSudokuView.h"
#import "LENSudokuSingleView.h"
#import "LENSudokuSupposeView.h"

@interface LENSudokuView()

@property (nonatomic, assign) LENSudokuType type;

@property (nonatomic, assign) LENSudokuStyle style;

@property (nonatomic, strong) NSMutableArray *singles;

@property (nonatomic, assign) CGFloat width;

@property (nonatomic, assign) CGFloat margin;

@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, assign) CGFloat lineWidthBig;

@property (nonatomic, assign) CGFloat lineWidth;

@property (nonatomic, strong) NSMutableArray *lines;

@property (nonatomic, strong) NSMutableArray *singleViews;

@property (nonatomic, strong) NSMutableArray *highLights; // 高亮的view indexs集合

@property (nonatomic, strong) LENSudokuStyleModel *styleModel;

@property (nonatomic, strong) CAKeyframeAnimation *animation;

@property (nonatomic, strong) LENSudokuSupposeView *supposeView;

@end

@implementation LENSudokuView

- (instancetype)initWithFrame:(CGRect)frame sudoku:(LENSudokuModel *)sudoku{
    self = [super initWithFrame:frame];
    if (self) {
        self.sudoku = sudoku;
        self.type = sudoku.type;
        self.style = [LENHandle defaultConfigureRead].style;
        self.singles = self.singles = [NSMutableArray arrayWithArray:sudoku.singles];
        self.status = LENSudokuViewStatusNone;
        self.highLights = [NSMutableArray array];
        self.styleModel = [LENHandle styleModelWithStyle:self.style];
        [self configureUI];
    }
    return self;
}

- (void)configureUI{
    self.margin = 4;
    self.lineWidthBig = 3;
    self.lineWidth = 1;
    self.width = (self.frame.size.width - self.margin * 2 - self.lineWidthBig * 2 - self.lineWidth * 6 ) / 9;
    self.backgroundColor = [UIColor clearColor];
    [self bgViewCreate];
    [self singlesCreate];
    [self linesCreate];
}

# pragma mark -- 背景图创建
- (void)bgViewCreate{
    self.bgView = [[UIView alloc] initWithFrame:self.bounds];
    self.bgView.layer.borderWidth = self.margin;
    self.bgView.layer.borderColor = self.styleModel.sudokuViewBoardColor.CGColor;
    [self addSubview:self.bgView];
}

# pragma mark -- 线条创建
- (void)linesCreate{
    self.lines = [NSMutableArray arrayWithCapacity:18];
    CGFloat line_width = self.frame.size.width - self.margin * 2;
    // 横排
    for (int i = 0; i < 9; i++) {
        if (i == 0) {
            continue;
        }
        CGFloat height = self.lineWidth;
        UIColor *lineColor = self.styleModel.sudokuViewLineColor;
        if (i % 3 == 0) {
            height = self.lineWidthBig;
            lineColor = self.styleModel.sudokuViewLineBigColor;
        }
        CGFloat x = self.margin;
        CGFloat y = i * self.lineWidth + (int)((i-1) / 3) * (self.lineWidthBig - self.lineWidth) + self.margin + i * self.width;
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(x, y, line_width, height)];
        if (i % 3 != 0) {
            line.alpha = 0.5;
        }
        line.backgroundColor = lineColor;
        [self addSubview:line];
        [self.lines addObject:line];
    }
    // 竖排
    for (int i = 0; i < 9; i++) {
        if (i == 0) {
            continue;
        }
        CGFloat height = self.lineWidth;
        UIColor *lineColor = self.styleModel.sudokuViewLineColor;
        if (i % 3 == 0) {
            height = self.lineWidthBig;
            lineColor = self.styleModel.sudokuViewLineBigColor;
        }
        CGFloat y = self.margin;
        CGFloat x = i * self.lineWidth + (int)((i-1) / 3) * (self.lineWidthBig - self.lineWidth) + self.margin + i * self.width;
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(x, y, height, line_width)];
        if (i % 3 != 0) {
            line.alpha = 0.6;
        }
        line.backgroundColor = lineColor;
        [self addSubview:line];
        [self.lines addObject:line];
    }
}

# pragma mark -- 格子创建
- (void)singlesCreate{
    WEAKSELF(weakSelf);
    self.singleViews = [NSMutableArray arrayWithCapacity:81];
    for (LENSudokuSingleModel *model in self.singles) {
        NSInteger section = model.section;
        NSInteger row = model.row;
        CGFloat x = row * self.lineWidth + (int)(row / 3) * (self.lineWidthBig - self.lineWidth) + self.margin + row * self.width;
        CGFloat y = section * self.lineWidth + (int)(section / 3) * (self.lineWidthBig - self.lineWidth) + self.margin + section * self.width;
        LENSudokuSingleView *view = [[LENSudokuSingleView alloc] initWithFrame:CGRectMake(x, y, self.width, self.width) model:model style:self.style];
        [view setTapBlock:^(NSInteger section, NSInteger row) {
            NSInteger index = [LENHandle indexWithSection:section row:row];
            LENSudokuSingleModel *model_t = self.singles[index];
            [weakSelf singlesTapWithSingle:model_t];
        }];
        [self addSubview:view];
        [self.singleViews addObject:view];
    }
}

# pragma mark -- 格子点击事件
- (void)singlesTapWithSingle:(LENSudokuSingleModel *)single{
    SSLog(@"single.status = %li", single.status);
    SSLog(@"self.status = %li", self.status);
    self.currentSingle = single;
    // 格子里什么都没有填入的状态
    if (single.status == LENSudokuSingleStatusNone) {
        if (self.status == LENSudokuViewStatusNone) {
            // 进入到准备填入数字或者填入标记的状态
            self.status = LENSudokuViewStatusPrepareFillInOrMask;
            // 单格子高亮
            NSInteger index_t = [LENHandle indexWithSection:single.section row:single.row];
            [self highLightShowWithIndexs:@[@(index_t)]];
        }
        else if (self.status == LENSudokuViewStatusPrepareFillInOrMask) {
            self.status = LENSudokuViewStatusPrepareFillInOrMask;
            // 准备填入数字或者填入标记的状态 点击相同格子或者不同格子
            NSInteger index_t = [self.highLights[0] integerValue]; // 上一次高亮的格子
            NSInteger currenIndex = [LENHandle indexWithSection:single.section row:single.row]; // 这次点击的格子
            if (index_t == currenIndex) {
                // 相同格子不做处理
                return;
            }
            // 不同的格子
            [self highLightHiddenWithIndexs:@[@(index_t)]];
            [self highLightShowWithIndexs:@[@(currenIndex)]];
        }
        else if (self.status == LENSudokuViewStatusHighLightPart) {
            // 部分高亮改为正常输入
            NSMutableArray *array = [NSMutableArray arrayWithArray:self.highLights];
            [self highLightHiddenWithIndexs:array];
            self.status = LENSudokuViewStatusPrepareFillInOrMask;
            NSInteger index_t = [LENHandle indexWithSection:single.section row:single.row];
            [self highLightShowWithIndexs:@[@(index_t)]];
        }
    }
    
    // 格子里有标记填入的状态
    else if (single.status == LENSudokuSingleStatusmark) {
        if (self.status == LENSudokuViewStatusNone) {
            // 进入到准备填入数字或者填入标记的状态
            self.status = LENSudokuViewStatusPrepareFillInOrMask;
            // 单格子高亮
            NSInteger index_t = [LENHandle indexWithSection:single.section row:single.row];
            [self highLightShowWithIndexs:@[@(index_t)]];
        }
        else if (self.status == LENSudokuViewStatusPrepareFillInOrMask) {
            // 准备填入数字或者填入标记的状态 点击相同格子或者不同格子
            NSInteger index_t = [self.highLights[0] integerValue]; // 上一次高亮的格子
            NSInteger currenIndex = [LENHandle indexWithSection:single.section row:single.row];
            if (index_t == currenIndex) {
                // 相同格子不做处理
                return;
            }
            // 不同的格子
            [self highLightHiddenWithIndexs:@[@(index_t)]];
            [self highLightShowWithIndexs:@[@(currenIndex)]];
        }
        else if (self.status == LENSudokuViewStatusHighLightPart) {
            // 部分高亮改为正常输入
            NSMutableArray *array = [NSMutableArray arrayWithArray:self.highLights];
            [self highLightHiddenWithIndexs:array];
            self.status = LENSudokuViewStatusPrepareFillInOrMask;
            NSInteger index_t = [LENHandle indexWithSection:single.section row:single.row];
            [self highLightShowWithIndexs:@[@(index_t)]];
        }
    }
    
    // 格子里有数字的状态
    else if (single.status == LENSudokuSingleStatusFillIn) {
        if (self.status == LENSudokuViewStatusNone) {
            // 进入到部分高亮的状态
            self.status = LENSudokuViewStatusHighLightPart;
            NSInteger fillIn = single.fillIn;
            NSMutableArray *indexs = [NSMutableArray array];
            for (LENSudokuSingleModel *model in self.singles) {
                NSInteger fillIn_t = model.fillIn;
                if (fillIn == fillIn_t && model.status == LENSudokuSingleStatusFillIn) {
                    NSInteger index_t = [LENHandle indexWithSection:model.section row:model.row];
                    [indexs addObject:@(index_t)];
                }
            }
            [self highLightShowWithIndexs:indexs];
        }
        else if (self.status == LENSudokuViewStatusPrepareFillInOrMask) {
            // 部分高亮
            NSInteger index = [self.highLights[0] integerValue]; // 上一次高亮的格子
            [self highLightHiddenWithIndexs:@[@(index)]];
            // 进入到部分高亮的状态
            self.status = LENSudokuViewStatusHighLightPart;
            NSInteger fillIn = single.fillIn;
            NSMutableArray *indexs = [NSMutableArray array];
            for (LENSudokuSingleModel *model in self.singles) {
                NSInteger fillIn_t = model.fillIn;
                if (fillIn == fillIn_t && model.status == LENSudokuSingleStatusFillIn) {
                    NSInteger index_t = [LENHandle indexWithSection:single.section row:single.row];
                    [indexs addObject:@(index_t)];
                }
            }
            [self highLightShowWithIndexs:indexs];
        }
        else if (self.status == LENSudokuViewStatusHighLightPart) {
            // 观察高亮数字是否一致
            NSInteger index = [self.highLights[0] integerValue];
            LENSudokuSingleModel *single_t = self.singles[index];
            NSInteger fillIn = single_t.fillIn;
            NSInteger fillInCurrent = single.fillIn;
            if (fillIn == fillInCurrent) {
                return;
            }
            // 现在与之前的高亮数字不一致
            NSMutableArray *array = [NSMutableArray arrayWithArray:self.highLights];
            [self highLightHiddenWithIndexs:array];
            // 选择现在的高亮数字
            NSMutableArray *indexs = [NSMutableArray array];
            for (LENSudokuSingleModel *model in self.singles) {
                NSInteger fillIn_t = model.fillIn;
                if (fillInCurrent == fillIn_t && model.status == LENSudokuSingleStatusFillIn) {
                    NSInteger index_t = [LENHandle indexWithSection:model.section row:model.row];
                    [indexs addObject:@(index_t)];
                }
            }
            [self highLightShowWithIndexs:indexs];
        }
    }
    
    SSLog(@"self.status = %li", self.status);
    if (self.tapBlock) {
        self.tapBlock(self.status, self.currentSingle);
    }
}

# pragma mark -- 高亮显示格子和隐藏高亮个字
- (void)highLightShowWithIndexs:(NSArray *)indexs{
    for (NSNumber *number in indexs) {
        NSInteger index = [number integerValue];
        LENSudokuSingleView *view = self.singleViews[index];
        [view highLightShow];
        [self.highLights addObject:@(index)];
    }
}

- (void)highLightHiddenWithIndexs:(NSArray *)indexs{
    for (NSNumber *number in indexs) {
        NSInteger index = [number integerValue];
        LENSudokuSingleView *view = self.singleViews[index];
        [view heighLightHidden];
        [self.highLights removeObject:@(index)];
    }
}

# pragma mark -- 填入数字
- (void)intoNumber:(int)number mark:(BOOL)mark callback:(nonnull InToBlock)callback{
    SSLog(@"into number");
    self.inToBlock = callback;
    if (self.status == LENSudokuViewStatusNone) {
        SSLog(@"还没选择格子");
        return;
    }
    if (self.status == LENSudokuViewStatusHighLightPart) {
        SSLog(@"选择了已经填入数字的格子");
        return;
    }
    if (self.status == LENSudokuViewStatusPrepareFillInOrMask) {
        NSInteger index = [self.highLights[0] integerValue];
        LENSudokuSingleModel *single = self.singles[index];
        LENSudokuSingleStatus status = single.status;
        if (status == LENSudokuSingleStatusFillIn) {
            SSLog(@"已经填入数字的格子");
            return;
        }
        if (status == LENSudokuSingleStatusNone || status == LENSudokuSingleStatusmark) {
            if (mark) {
                // 标记
                [self markChangeWithSingle:single number:number index:index];
            } else {
                // 填入
                [self fillInWithSingle:single number:number index:index];
            }
        }
    }
}

# pragma mark -- 单个格子填入number内容
- (void)fillInWithSingle:(LENSudokuSingleModel *)single number:(int)number index:(NSInteger)index{
    LENSudokuSingleView *view = self.singleViews[index];
    int fillIn = (int)single.fillIn;
    if (fillIn == number) {
        SSLog(@"填入正确");
        [view statusUpdateWithStatus:LENSudokuSingleStatusFillIn];
        // 部分高亮
        [self.highLights removeAllObjects];
        self.status = LENSudokuViewStatusHighLightPart;
        single.status = LENSudokuSingleStatusFillIn;
        self.singles[index ] = single;
        self.sudoku.singles = self.singles;
        NSMutableArray *indexs = [NSMutableArray array];
        for (LENSudokuSingleModel *model in self.singles) {
            NSInteger fillIn_t = model.fillIn;
            if (fillIn == fillIn_t && model.status == LENSudokuSingleStatusFillIn) {
                NSInteger index = [LENHandle indexWithSection:model.section row:model.row];
                [indexs addObject:@(index)];
            }
        }
        [self highLightShowWithIndexs:indexs];
        self.currentSingle = single;
        NSMutableArray *numbers = [NSMutableArray arrayWithArray:self.sudoku.numbers];
        int num = [numbers[number-1] intValue];
        num += 1;
        numbers[number-1] = @(num);
        self.sudoku.numbers = numbers;
        // 是否全部正确，以及动画效果
        if ([self checkAll]) {
            SSLog(@"全部正确");
            [self singleAnimationStart];
            return;
        }
        NSMutableArray *animationIndexs = [NSMutableArray array];
        [animationIndexs addObject:@(index)];
        // 九宫格
        NSMutableArray *indexs0 = [self checkNineWithSection:single.section row:single.row];
        if (indexs0.count == 9) {
            for (NSNumber *num in indexs0) {
                if (![animationIndexs containsObject:num]) {
                    [animationIndexs addObject:num];
                }
            }
        }
        // 单行
        NSMutableArray *indexs1 = [self checkWithSection:single.section];
        if (indexs1.count == 9) {
            for (NSNumber *num in indexs1) {
                if (![animationIndexs containsObject:num]) {
                    [animationIndexs addObject:num];
                }
            }
        }
        // 单列
        NSMutableArray *indexs2 = [self checkWithRow:single.row];
        if (indexs2.count == 9) {
            for (NSNumber *num in indexs2) {
                if (![animationIndexs containsObject:num]) {
                    [animationIndexs addObject:num];
                }
            }
        }
        [self singleAnimationStartWithIndexs:animationIndexs];
        // 对同行，同列，同九宫格内mark的部分取消
        [self markCancelWithSingle:single];
        // 对supposeView的影响
        if (_supposeView) {
            [_supposeView updateSudokuViewIntoNumber:number index:index];
        }
        if (self.inToBlock) {
            self.inToBlock(NO, numbers, NO, -1, NO);
        }
    } else {
        SSLog(@"填入错误");
        [self animationStart];
        NSInteger errorTimes = self.sudoku.errorTimes;
        errorTimes += 1;
        self.sudoku.errorTimes = errorTimes;
        if (self.inToBlock) {
            self.inToBlock(YES, nil, NO, -1, NO);
        }
    }
}

# pragma mark -- 单个格子改变mark内容
- (void)markChangeWithSingle:(LENSudokuSingleModel *)single number:(int)number index:(NSInteger)index{
    NSMutableArray *marks = [NSMutableArray arrayWithArray:single.marks];
    NSNumber *markNumber = [NSNumber numberWithInt:number];
    LENSudokuSingleView *view = self.singleViews[index];
    if ([marks containsObject:markNumber]) {
        // mark删除
        [marks removeObject:markNumber];
        if (marks.count == 0) {
            single.status = LENSudokuSingleStatusNone;
        }
        single.marks = marks;
        self.singles[index] = single;
        if (single.status == LENSudokuSingleStatusNone) {
            [view statusUpdateWithStatus:LENSudokuSingleStatusNone];
        } else {
            [view markUpdateWithMarks:marks];
        }
        if (self.inToBlock) {
            self.inToBlock(NO, nil, YES, number, NO);
        }
    } else {
        // mark添加
        [marks addObject:markNumber];
        [self marksOrderWithMarks:marks];
        single.marks = marks;
        [view markUpdateWithMarks:marks];
        if (marks.count == 1) {
            single.status = LENSudokuSingleStatusmark;
            [view statusUpdateWithStatus:LENSudokuSingleStatusmark];
        }
        self.singles[index] = single;
        if (self.inToBlock) {
            self.inToBlock(NO, nil, YES, number, YES);
        }
    }
    self.sudoku.singles = self.singles;
    self.currentSingle = single;
}

# pragma mark -- mark 排序
- (void)marksOrderWithMarks:(NSMutableArray *)marks{
    [marks sortUsingComparator:^NSComparisonResult(NSNumber *  _Nonnull obj1, NSNumber *  _Nonnull obj2) {
        if ([obj1 intValue] < [obj2 intValue]) {
            return NSOrderedAscending;
        } else {
            return NSOrderedDescending;
        }
    }];
}

# pragma mark -- 全部正确检测
- (BOOL)checkAll{
    for (LENSudokuSingleModel *single in self.singles) {
        if (single.status != LENSudokuSingleStatusFillIn) {
            return NO;
        }
    }
    return YES;
}

# pragma mark -- 横排正确检测
- (NSMutableArray *)checkWithSection:(NSInteger)section{
    NSMutableArray *indexs = [NSMutableArray array];
    for (int i = 0; i < 9; i++) {
        NSInteger index = section * 9 + i;
        LENSudokuSingleModel *single = self.singles[index];
        if (single.status == LENSudokuSingleStatusFillIn) {
            [indexs addObject:@(index)];
        }
    }
    return indexs;
}

# pragma mark -- 竖排正确检测
- (NSMutableArray *)checkWithRow:(NSInteger)row{
    NSMutableArray *indexs = [NSMutableArray array];
    for (int i = 0; i < 9; i++) {
        NSInteger index = i * 9 + row;
        LENSudokuSingleModel *single = self.singles[index];
        if (single.status == LENSudokuSingleStatusFillIn) {
            [indexs addObject:@(index)];
        }
    }
    return indexs;
}

# pragma mark -- 九宫格检测
- (NSMutableArray *)checkNineWithSection:(NSInteger)section row:(NSInteger)row{
    NSArray *arr0 = @[@0, @1, @2, @9, @10, @11, @18, @19, @20];
    NSArray *arr1 = @[@3, @4, @5, @12, @13, @14, @21, @22, @23];
    NSArray *arr2 = @[@6, @7, @8, @15, @16, @17, @24, @25, @26];
    NSArray *arr3 = @[@27, @28, @29, @36, @37, @38, @45, @46, @47];
    NSArray *arr4 = @[@30, @31, @32, @39, @40, @41, @48, @49, @50];
    NSArray *arr5 = @[@33, @34, @35, @42, @43, @44, @51, @52, @53];
    NSArray *arr6 = @[@54, @55, @56, @63, @64, @65, @72, @73, @74];
    NSArray *arr7 = @[@57, @58, @59, @66, @67, @68, @75, @76, @77];
    NSArray *arr8 = @[@60, @61, @62, @69, @70, @71, @78, @79, @80];
    NSArray *arr9 = @[arr0, arr1, arr2, arr3, arr4, arr5, arr6, arr7, arr8];
    NSArray *nine = [NSArray array];
    NSInteger row_t = row / 3;
    NSInteger section_t = section / 3;
    int nineIndex = (int)(section_t * 3 + row_t);
    nine = arr9[nineIndex];
    NSMutableArray *indexs = [NSMutableArray array];
    for (NSNumber *number in nine) {
        int nine = [number intValue];
        LENSudokuSingleModel *single = self.singles[nine];
        if (single.status == LENSudokuSingleStatusFillIn) {
            [indexs addObject:@(nine)];
        }
    }
    return indexs;
}

# pragma mark -- mark cancel
- (void)markCancelWithSingle:(LENSudokuSingleModel *)single{
    // 对同行，同列，同九宫格内mark的部分取消
    NSMutableArray *indexs = [self markCancelIndexsWithSingle:single];
    for (NSNumber *num in indexs) {
        NSInteger index = [num integerValue];
        LENSudokuSingleModel *model = self.singles[index];
        LENSudokuSingleView *view = self.singleViews[index];
        NSMutableArray *marks = model.marks;
        [marks removeObject:@(single.fillIn)];
        if (marks.count == 0) {
            model.status = LENSudokuSingleStatusNone;
            [view statusUpdateWithStatus:LENSudokuSingleStatusNone];
        } else {
            [view markUpdateWithMarks:marks];
        }
        model.marks = marks;
        self.singles[index] = model;
    }
    self.sudoku.singles = self.singles;
}

- (NSMutableArray *)markCancelIndexsWithSingle:(LENSudokuSingleModel *)single{
    NSMutableArray *indexs = [NSMutableArray array];
    NSMutableArray *indexs0 = [self markEqualIndexsWithNumber:single.fillIn section:single.section];
    for (NSNumber *number in indexs0) {
        if (![indexs containsObject:number]) {
            [indexs addObject:number];
        }
    }
    NSMutableArray *indexs1 = [self markEqualIndexsWithNumber:single.fillIn row:single.row];
    for (NSNumber *number in indexs1) {
        if (![indexs containsObject:number]) {
            [indexs addObject:number];
        }
    }
    NSMutableArray *indexs2 = [self markEqualIndexsWithNumber:single.fillIn section:single.section row:single.row];
    for (NSNumber *number in indexs2) {
        if (![indexs containsObject:number]) {
            [indexs addObject:number];
        }
    }
    return indexs;
}

// 返回横排中number和格子mark有相同的index
- (NSMutableArray *)markEqualIndexsWithNumber:(NSInteger)number section:(NSInteger)section{
    NSMutableArray *indexs = [NSMutableArray array];
    for (int i = 0; i < 9; i++) {
        int index = (int)section * 9 + i;
        LENSudokuSingleModel *single = self.singles[index];
        NSMutableArray *marks = single.marks;
        if ([marks containsObject:@(number)] && single.status == LENSudokuSingleStatusmark) {
            [indexs addObject:@(index)];
        }
    }
    return indexs;
}

// 返回竖排中number和格子mark有相同的index
- (NSMutableArray *)markEqualIndexsWithNumber:(NSInteger)number row:(NSInteger)row{
    NSMutableArray *indexs = [NSMutableArray array];
    for (int i = 0; i < 9; i++) {
        int index = i * 9 + (int)row;
        LENSudokuSingleModel *single = self.singles[index];
        NSMutableArray *marks = single.marks;
        if ([marks containsObject:@(number)] && single.status == LENSudokuSingleStatusmark) {
            [indexs addObject:@(index)];
        }
    }
    return indexs;
}

// 返回九宫格中number和格子mark有相同的index
- (NSMutableArray *)markEqualIndexsWithNumber:(NSInteger)number section:(NSInteger)section row:(NSInteger)row{
    NSMutableArray *indexs = [NSMutableArray array];
    NSArray *arr0 = @[@0, @1, @2, @9, @10, @11, @18, @19, @20];
    NSArray *arr1 = @[@3, @4, @5, @12, @13, @14, @21, @22, @23];
    NSArray *arr2 = @[@6, @7, @8, @15, @16, @17, @24, @25, @26];
    NSArray *arr3 = @[@27, @28, @29, @36, @37, @38, @45, @46, @47];
    NSArray *arr4 = @[@30, @31, @32, @39, @40, @41, @48, @49, @50];
    NSArray *arr5 = @[@33, @34, @35, @42, @43, @44, @51, @52, @53];
    NSArray *arr6 = @[@54, @55, @56, @63, @64, @65, @72, @73, @74];
    NSArray *arr7 = @[@57, @58, @59, @66, @67, @68, @75, @76, @77];
    NSArray *arr8 = @[@60, @61, @62, @69, @70, @71, @78, @79, @80];
    NSArray *arr9 = @[arr0, arr1, arr2, arr3, arr4, arr5, arr6, arr7, arr8];
    NSArray *nine = [NSArray array];
    NSInteger row_t = row / 3;
    NSInteger section_t = section / 3;
    int nineIndex = (int)(section_t * 3 + row_t);
    nine = arr9[nineIndex];
    for (NSNumber *num in nine) {
        int index = [num intValue];
        LENSudokuSingleModel *single = self.singles[index];
        NSMutableArray *marks = single.marks;
        if ([marks containsObject:@(number)] && single.status == LENSudokuSingleStatusmark) {
            [indexs addObject:@(index)];
        }
    }
    return indexs;
}

# pragma mark -- 格子动画
- (void)singleAnimationStart{
    NSMutableArray *indexs = [NSMutableArray array];
    for (LENSudokuSingleModel *single in self.singles) {
        if (single.status == LENSudokuSingleStatusFillIn) {
            NSInteger index = [LENHandle indexWithSection:single.section row:single.row];
            [indexs addObject:@(index)];
        }
    }
    [self singleAnimationStartWithIndexs:indexs];
}

- (void)singleAnimationStartWithIndexs:(NSMutableArray *)indexs{
    for (NSNumber *number in indexs) {
        NSInteger index = [number integerValue];
        LENSudokuSingleView *view = self.singleViews[index];
        [view animationStart];
    }
}

# pragma mark -- 错误时候的动画
#define angleValue(angle) ((angle) * M_PI / 180.0)//角度数值转换宏
- (void)animationStart{
//    [self.bgView.layer removeAllAnimations];
    if (!_animation) {
        _animation = [CAKeyframeAnimation animation];
        _animation.keyPath = @"transform.rotation";
        _animation.values = @[@(angleValue(-5)),@(angleValue(5)),@(angleValue(-5))];
        _animation.repeatCount = 2;
    }
    [self.layer addAnimation:self.animation forKey:nil];
}

# pragma mark -- 复原
- (void)recovery{
    // 高亮取消
    if (self.highLights.count > 0) {
        NSMutableArray *array = [NSMutableArray arrayWithArray:self.highLights];
        [self highLightHiddenWithIndexs:array];
    }
    // 状态变更
    self.status = LENSudokuViewStatusNone;
    // currenSingle nil
    self.currentSingle = nil;
    // 去除supposeView
    if (_supposeView) {
        [_supposeView removeFromSuperview];
        _supposeView = nil;
    }
}

# pragma mark -- suppose
- (void)supposeShow:(BOOL)show{
    if (show) {
        // 高亮还原
        if (self.status != LENSudokuViewStatusNone) {
            self.status = LENSudokuViewStatusNone;
            if (self.highLights.count > 0) {
                NSMutableArray *indexs = [NSMutableArray arrayWithArray:self.highLights];
                [self highLightHiddenWithIndexs:indexs];
            }
        }
        // suppose view
        if (!_supposeView) {
            _supposeView = [[LENSudokuSupposeView alloc] initWithFrame:self.bounds singles:self.singles singleViews:self.singleViews];
            [self addSubview:_supposeView];
        }
        self.supposeView.hidden = NO;
    } else {
        if (_supposeView) {
            [_supposeView hiddenView];
            _supposeView.hidden = YES;
        }
    }
}

- (void)supposeIntoNumber:(int)number{
    if (_supposeView) {
        [_supposeView intoNumber:number];
    }
}

- (void)supposeClear{
    if (_supposeView) {
        [_supposeView clear];
    }
}



@end
