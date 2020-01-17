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

@property (nonatomic, assign) LENSudokuType type;

@property (nonatomic, assign) LENSudokuStyle style;

@property (nonatomic, strong) NSMutableArray *singles;

@property (nonatomic, assign) CGFloat width;

@property (nonatomic, assign) CGFloat margin;

@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) NSMutableArray *lines;

@property (nonatomic, strong) NSMutableArray *singleViews;

@property (nonatomic, strong) NSMutableArray *highLights; // 高亮的view indexs集合

@end

@implementation LENSudokuView

- (instancetype)initWithFrame:(CGRect)frame sudoku:(LENSudokuModel *)sudoku{
    self = [super initWithFrame:frame];
    if (self) {
        self.type = sudoku.type;
        self.style = sudoku.style;
        self.singles = self.singles = [NSMutableArray arrayWithArray:sudoku.singles];
        self.status = LENSudokuViewStatusNone;
        self.highLights = [NSMutableArray array];
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
    CGFloat line_height_big = 2;
    // 横排
    for (int i = 0; i < 9; i++) {
        CGFloat height = line_height;
        if (i % 3 == 0) {
            height = line_height_big;
        }
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(self.margin, i * self.width + self.margin, line_width, height)];
        line.backgroundColor = lineColor;
        [self addSubview:line];
        [self.lines addObject:line];
    }
    // 竖排
    for (int i = 0; i < 9; i++) {
        CGFloat height = line_height;
        if (i % 3 == 0) {
            height = line_height_big;
        }
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(i * self.width + self.margin, self.margin, height, line_width)];
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
        LENSudokuSingleView *view = [[LENSudokuSingleView alloc] initWithFrame:CGRectMake(self.margin + row * self.width, self.margin + section * self.width, self.width, self.width) model:model style:self.style];
        [view setTapBlock:^(NSInteger section, NSInteger row) {
            [weakSelf singlesTapWithSingle:model];
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
            NSInteger index = [self indexWithSection:single.section row:single.row];
            [self highLightShowWithIndexs:@[@(index)]];
        }
        else if (self.status == LENSudokuViewStatusPrepareFillInOrMask) {
            // 准备填入数字或者填入标记的状态 点击相同格子或者不同格子
            NSInteger index = [self.highLights[0] integerValue]; // 上一次高亮的格子
            NSInteger currenIndex = [self indexWithSection:single.section row:single.row]; // 这次点击的格子
            if (index == currenIndex) {
                // 相同格子不做处理
                return;
            }
            // 不同的格子
            [self highLightHiddenWithIndexs:@[@(index)]];
            [self highLightShowWithIndexs:@[@(currenIndex)]];
        }
        else if (self.status == LENSudokuViewStatusHighLightPart) {
            // 部分高亮改为正常输入
            NSMutableArray *array = [NSMutableArray arrayWithArray:self.highLights];
            [self highLightHiddenWithIndexs:array];
            self.status = LENSudokuViewStatusPrepareFillInOrMask;
            NSInteger index = [self indexWithSection:single.section row:single.row];
            [self highLightShowWithIndexs:@[@(index)]];
        }
    }
    
    // 格子里有标记填入的状态
    else if (single.status == LENSudokuSingleStatusmark) {
        if (self.status == LENSudokuViewStatusNone) {
            // 进入到准备填入数字或者填入标记的状态
            self.status = LENSudokuViewStatusPrepareFillInOrMask;
            // 单格子高亮
            NSInteger index = [self indexWithSection:single.section row:single.row];
            [self highLightShowWithIndexs:@[@(index)]];
        }
        else if (self.status == LENSudokuViewStatusPrepareFillInOrMask) {
            // 准备填入数字或者填入标记的状态 点击相同格子或者不同格子
            NSInteger index = [self.highLights[0] integerValue]; // 上一次高亮的格子
            NSInteger currenIndex = [self indexWithSection:single.section row:single.row]; // 这次点击的格子
            if (index == currenIndex) {
                // 相同格子不做处理
                return;
            }
            // 不同的格子
            [self highLightHiddenWithIndexs:@[@(index)]];
            [self highLightShowWithIndexs:@[@(currenIndex)]];
        }
        else if (self.status == LENSudokuViewStatusHighLightPart) {
            // 部分高亮改为正常输入
            NSMutableArray *array = [NSMutableArray arrayWithArray:self.highLights];
            [self highLightHiddenWithIndexs:array];
            self.status = LENSudokuViewStatusPrepareFillInOrMask;
            NSInteger index = [self indexWithSection:single.section row:single.row];
            [self highLightShowWithIndexs:@[@(index)]];
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
                    NSInteger index = [self indexWithSection:model.section row:model.row];
                    [indexs addObject:@(index)];
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
                    NSInteger index = [self indexWithSection:model.section row:model.row];
                    [indexs addObject:@(index)];
                }
            }
            [self highLightShowWithIndexs:indexs];
        }
        else if (self.status == LENSudokuViewStatusHighLightPart) {
            // 观察高亮数字是否一致
            NSInteger index = [self.highLights[0] integerValue];
            LENSudokuSingleModel *single = self.singles[index];
            NSInteger fillIn = single.fillIn;
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
                    NSInteger index = [self indexWithSection:model.section row:model.row];
                    [indexs addObject:@(index)];
                }
            }
            [self highLightShowWithIndexs:indexs];
        }
    }
    
    SSLog(@"self.status = %li", self.status);
}

# pragma mark -- section row index 互转
- (NSInteger)indexWithSection:(NSInteger)section row:(NSInteger)row{
    return section * 9 + row;
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
                NSInteger index = [self indexWithSection:model.section row:model.row];
                [indexs addObject:@(index)];
            }
        }
        [self highLightShowWithIndexs:indexs];
        self.currentSingle = single;
        if (self.inToBlock) {
            self.inToBlock(NO, number);
        }
        // 是否全部正确
        if ([self checkAll]) {
            SSLog(@"全部正确");
            return;
        }
        // 判断九宫格正确
        if ([self checkNineWithSection:single.section row:single.row]) {
            SSLog(@"九宫格正确");
        }
        // 判断单行正确
        if ([self checkWithSection:single.section]) {
            SSLog(@"单行正确");
        }
        // 判断横行正确
        if ([self checkWithRow:single.section]) {
            SSLog(@"单列正确");
        }
    } else {
        SSLog(@"填入错误");
        NSInteger errorTimes = self.sudoku.errorTimes;
        errorTimes += 1;
        self.sudoku.errorTimes = errorTimes;
        if (self.inToBlock) {
            self.inToBlock(YES, -1);
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
- (BOOL)checkWithSection:(NSInteger)section{
    for (int i = 0; i < 9; i++) {
        NSInteger index = section * 9 + i;
        LENSudokuSingleModel *single = self.singles[index];
        if (single.status != LENSudokuSingleStatusFillIn) {
            return NO;
        }
    }
    return YES;
}

# pragma mark -- 竖排正确检测
- (BOOL)checkWithRow:(NSInteger)row{
    for (int i = 0; i < 9; i++) {
        NSInteger index = i * 9 + row;
        LENSudokuSingleModel *single = self.singles[index];
        if (single.status != LENSudokuSingleStatusFillIn) {
            return NO;
        }
    }
    return YES;
}


# pragma mark -- 九宫格检测
- (BOOL)checkNineWithSection:(NSInteger)section row:(NSInteger)row{
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
    for (NSNumber *number in nine) {
        int nine = [number intValue];
        LENSudokuSingleModel *single = self.singles[nine];
        if (single.status != LENSudokuSingleStatusFillIn) {
            return NO;
        }
    }
    return YES;
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
}



@end
