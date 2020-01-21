//
//  LENSudokuSupposeView.m
//  Sudoku
//
//  Created by 戴十三 on 2020/1/19.
//  Copyright © 2020 ledon. All rights reserved.
//

#import "LENSudokuSupposeView.h"
#import "LENSudokuSupposeSingleView.h"
#import "LENSudokuSingleView.h"

@interface LENSudokuSupposeView()

@property (nonatomic, strong) NSMutableArray *singles;

@property (nonatomic, strong) NSMutableArray *singleViews;

@property (nonatomic, strong) NSMutableArray *supposeSingles;

@property (nonatomic, strong) NSMutableArray *supposeSingleViews;

@property (nonatomic, assign) LENSudokuStyle style;

@property (nonatomic, strong) LENSudokuStyleModel *styleModel;

@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, assign) LENSudokuViewStatus status;

@property (nonatomic, strong) NSMutableArray *highLights;

@end

@implementation LENSudokuSupposeView

- (instancetype)initWithFrame:(CGRect)frame singles:(NSMutableArray *)singles singleViews:(NSMutableArray *)singleViews{
    self = [super initWithFrame:frame];
    if (self) {
        self.singles = [singles copy];
        self.singleViews = [NSMutableArray arrayWithArray:singleViews];
        self.status = LENSudokuViewStatusNone;
        self.supposeSingles = [NSMutableArray array];
        self.supposeSingleViews = [NSMutableArray array];
        self.highLights = [NSMutableArray array];
        self.style = [LENHandle defaultConfigureRead].style;
        self.styleModel = [LENHandle styleModelWithStyle:self.style];
        [self configureUI];
    }
    return self;
}

- (void)configureUI{
    self.backgroundColor = [UIColor clearColor];
    // bgView
    self.bgView = [[UIView alloc] initWithFrame:self.bounds];
    self.bgView.backgroundColor = self.styleModel.sudokuSupposeBackgroundColor;
    self.bgView.alpha = 0.2;
    [self addSubview:self.bgView];
    // 里面的构成
    [self supposeSinglesCreate];
    // 页面构成
    [self supposeSingleViewsCreate];
}


# pragma mark -- supposeSinglesCreate
- (void)supposeSinglesCreate{
    for (LENSudokuSingleModel *single in self.singles) {
        LENSudokuSingleModel *model = [[LENSudokuSingleModel alloc] init];
        model.fillIn = single.fillIn;
        model.section = single.section;
        model.row = single.row;
        model.status = single.status;
        if (model.status == LENSudokuSingleStatusmark) {
            model.status = LENSudokuSingleStatusNone;
        }
        [self.supposeSingles addObject:model];
    }
}

# pragma mark -- supposeSingleViewsCreate
- (void)supposeSingleViewsCreate{
    for (int i = 0; i < 81; i++) {
        LENSudokuSingleView *view = self.singleViews[i];
        LENSudokuSingleModel *single = self.supposeSingles[i];
        LENSudokuSupposeSingleView *singleView = [[LENSudokuSupposeSingleView alloc] initWithFrame:view.frame single:single];
        [singleView setTapBlock:^(NSInteger section, NSInteger row) {
            [self singleTapWithSection:section row:row];
        }];
        [self addSubview:singleView];
        [self.supposeSingleViews addObject:singleView];
    }
}

# pragma mark -- single tap
- (void)singleTapWithSection:(NSInteger)section row:(NSInteger)row{
    NSInteger index = [LENHandle indexWithSection:section row:row];
    LENSudokuSingleModel *single = self.supposeSingles[index];
    SSLog(@"single.status = %li", single.status);
    SSLog(@"self.status = %li", self.status);
    if (single.status == LENSudokuSingleStatusNone || single.status == LENSudokuSingleStatusSupposeFillIn || single.status == LENSudokuSingleStatusSupposeFillInError) {
        if (self.status == LENSudokuViewStatusNone) {
            // 单格子点亮
            self.status = LENSudokuViewStatusPrepareFillInOrMask;
            NSInteger index = [LENHandle indexWithSection:single.section row:single.row];
            [self highLightShowWithIndexs:@[@(index)]];
        }
        else if (self.status == LENSudokuViewStatusPrepareFillInOrMask) {
            // 准备填入数字或者填入标记的状态 点击相同格子或者不同格子
            self.status = LENSudokuViewStatusPrepareFillInOrMask;
            NSInteger index = [self.highLights[0] integerValue]; // 上一次高亮的格子
            NSInteger currenIndex = [LENHandle indexWithSection:single.section row:single.row]; // 这次点击的格子
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
            NSInteger index = [LENHandle indexWithSection:single.section row:single.row];
            [self highLightShowWithIndexs:@[@(index)]];
        }
    }
    else if (single.status == LENSudokuSingleStatusFillIn) {
        if (self.status == LENSudokuViewStatusNone) {
            // 进入到部分高亮的状态
            self.status = LENSudokuViewStatusHighLightPart;
            NSInteger fillIn = single.fillIn;
            NSMutableArray *indexs = [NSMutableArray array];
            for (LENSudokuSingleModel *model in self.supposeSingles) {
                NSInteger fillIn_t = model.fillIn;
                if (fillIn == fillIn_t && model.status == LENSudokuSingleStatusFillIn) {
                    NSInteger index = [LENHandle indexWithSection:model.section row:model.row];
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
            for (LENSudokuSingleModel *model in self.supposeSingles) {
                if ((model.fillIn == fillIn && model.status == LENSudokuSingleStatusFillIn) || (model.supposeFillIn == fillIn && (model.status == LENSudokuSingleStatusSupposeFillIn || model.status == LENSudokuSingleStatusSupposeFillInError))) {
                    NSInteger index = [LENHandle indexWithSection:model.section row:model.row];
                    [indexs addObject:@(index)];
                }
            }
            [self highLightShowWithIndexs:indexs];
        }
        else if (self.status == LENSudokuViewStatusHighLightPart) {
            // 观察高亮数字是否一致
            NSInteger index = [self.highLights[0] integerValue];
            LENSudokuSingleModel *single_t = self.supposeSingles[index];
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
            for (LENSudokuSingleModel *model in self.supposeSingles) {
                NSInteger fillIn_t = model.fillIn;
                if (fillInCurrent == fillIn_t && (model.status == LENSudokuSingleStatusFillIn || model.status == LENSudokuSingleStatusSupposeFillIn || model.status == LENSudokuSingleStatusSupposeFillInError)) {
                    NSInteger index = [LENHandle indexWithSection:model.section row:model.row];
                    [indexs addObject:@(index)];
                }
            }
            [self highLightShowWithIndexs:indexs];
        }
    }
}

# pragma mark -- 高亮显示格子和隐藏高亮个字
- (void)highLightShowWithIndexs:(NSArray *)indexs{
    for (NSNumber *number in indexs) {
        NSInteger index = [number integerValue];
        LENSudokuSupposeSingleView *view = self.supposeSingleViews[index];
        [view highLightShow];
        [self.highLights addObject:@(index)];
    }
}

- (void)highLightHiddenWithIndexs:(NSArray *)indexs{
    for (NSNumber *number in indexs) {
        NSInteger index = [number integerValue];
        LENSudokuSupposeSingleView *view = self.supposeSingleViews[index];
        [view heighLightHidden];
        [self.highLights removeObject:@(index)];
    }
}

# pragma mark -- 键入数字
- (void)intoNumber:(int)number{
    SSLog(@"into number");
    if (self.status == LENSudokuViewStatusNone) {
        SSLog(@"还没选择格子");
        return;
    }
    if (self.status == LENSudokuViewStatusHighLightPart) {
        SSLog(@"选择了已经填入数字的格子");
        return;
    }
    NSInteger index = [self.highLights[0] integerValue];
    LENSudokuSingleModel *single = self.supposeSingles[index];
    // 查询横排竖排九宫格内是否有重复的数字
    NSMutableArray *indexs = [NSMutableArray array];
    NSMutableArray *indexs0 = [self errorIndexsWithNumber:number section:single.section index:index];
    for (NSNumber *num in indexs0) {
        NSInteger index_t = [num integerValue];
        if (![indexs containsObject:@(index_t)]) {
            [indexs addObject:@(index_t)];
        }
    }
    NSMutableArray *indexs1 = [self errorIndexsWithNumber:number row:single.row index:index];
    for (NSNumber *num in indexs1) {
        NSInteger index_t = [num integerValue];
        if (![indexs containsObject:@(index_t)]) {
            [indexs addObject:@(index_t)];
        }
    }
    NSMutableArray *indexs2 = [self errorIndexsWithNumber:number section:single.section row:single.row index:index];
    for (NSNumber *num in indexs2) {
        NSInteger index_t = [num integerValue];
        if (![indexs containsObject:@(index_t)]) {
            [indexs addObject:@(index_t)];
        }
    }
    // 有数字的话 那就判定错误 没有则是正常假设填入
    if (indexs.count > 0) {
        [indexs addObject:@(index)];
        for (NSNumber *num in indexs) {
            NSInteger index_t = [num integerValue];
            LENSudokuSingleModel *single_t = self.supposeSingles[index_t];
            if (single_t.status != LENSudokuSingleStatusFillIn) {
                if (index_t == index) {
                    single_t.supposeFillIn = number;
                }
                LENSudokuSupposeSingleView *view = self.supposeSingleViews[index_t];
                [view statusUpdateWithStatus:LENSudokuSingleStatusSupposeFillInError];
                single_t.status = LENSudokuSingleStatusSupposeFillInError;
                self.supposeSingles[index_t] = single_t;
            }
        }
    } else {
        single.supposeFillIn = number;
        single.status = LENSudokuSingleStatusSupposeFillIn;
        self.supposeSingles[index] = single;
        LENSudokuSupposeSingleView *view = self.supposeSingleViews[index];
        [view statusUpdateWithStatus:LENSudokuSingleStatusSupposeFillIn];
    }
}

- (NSMutableArray *)errorIndexsWithNumber:(int)number section:(NSInteger)section index:(NSInteger)index{
    NSMutableArray *indexs = [NSMutableArray array];
    for (NSInteger i = 0; i < 9; i++) {
        NSInteger index_t = section * 9 + i;
        LENSudokuSingleModel *single = self.supposeSingles[index_t];
        if ((single.fillIn == number && single.status == LENSudokuSingleStatusFillIn) || (single.supposeFillIn == number && (single.status == LENSudokuSingleStatusSupposeFillIn || single.status == LENSudokuSingleStatusSupposeFillInError))) {
            [indexs addObject:@(index_t)];
        }
    }
    return indexs;
}

- (NSMutableArray *)errorIndexsWithNumber:(int)number row:(NSInteger)row index:(NSInteger)index{
    NSMutableArray *indexs = [NSMutableArray array];
    for (NSInteger i = 0; i < 9; i++) {
        NSInteger index_t = i * 9 + row;
        LENSudokuSingleModel *single = self.supposeSingles[index_t];
        if ((single.fillIn == number && single.status == LENSudokuSingleStatusFillIn) || (single.supposeFillIn == number && (single.status == LENSudokuSingleStatusSupposeFillIn || single.status == LENSudokuSingleStatusSupposeFillInError))) {
            [indexs addObject:@(index_t)];
        }
    }
    return indexs;
}

- (NSMutableArray *)errorIndexsWithNumber:(int)number section:(NSInteger)section row:(NSInteger)row index:(NSInteger)index{
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
        LENSudokuSingleModel *single = self.supposeSingles[nine];
        if ((single.fillIn == number && single.status == LENSudokuSingleStatusFillIn) || (single.supposeFillIn == number && (single.status == LENSudokuSingleStatusSupposeFillIn || single.status == LENSudokuSingleStatusSupposeFillInError))) {
            [indexs addObject:@(nine)];
        }
    }
    return indexs;
}

# pragma mark -- 清除
- (void)hiddenView{
    // 高亮清除
    if (self.status != LENSudokuViewStatusNone) {
        self.status = LENSudokuViewStatusNone;
        NSMutableArray *array = [NSMutableArray arrayWithArray:self.highLights];
        [self highLightHiddenWithIndexs:array];
    }
}

- (void)clear{
    // 文字清除
    for (int i = 0; i < 81; i++) {
        LENSudokuSingleModel *single = self.supposeSingles[i];
        if (single.status == LENSudokuSingleStatusSupposeFillIn || single.status == LENSudokuSingleStatusSupposeFillInError) {
            NSInteger index = [LENHandle indexWithSection:single.section row:single.row];
            LENSudokuSupposeSingleView *view = self.supposeSingleViews[index];
            [view statusUpdateWithStatus:(LENSudokuSingleStatusNone)];
            single.status = LENSudokuSingleStatusNone;
            self.supposeSingles[index] = single;
        }
    }
    // 高亮清除
    if (self.status != LENSudokuViewStatusNone) {
        self.status = LENSudokuViewStatusNone;
        NSMutableArray *array = [NSMutableArray arrayWithArray:self.highLights];
        [self highLightHiddenWithIndexs:array];
    }
}

# pragma mark -- 因为sudokuView键入的数字而发生的变化
- (void)updateSudokuViewIntoNumber:(int)number index:(NSInteger)index{
    // 单个数字FillIn
    LENSudokuSingleModel *single = self.supposeSingles[index];
    single.status = LENSudokuSingleStatusFillIn;
    self.supposeSingles[index] = single;
    LENSudokuSupposeSingleView *view = self.supposeSingleViews[index];
    [view statusUpdateWithStatus:LENSudokuSingleStatusFillIn];
    // 如果横排竖排九宫格内有相同数字，并且状态SupposeFillIn则变为SupposeFillInError
    NSMutableArray *indexs = [NSMutableArray array];
    NSMutableArray *indexs0 = [self equalIndexsWithNumber:number section:single.section index:index];
    for (NSNumber *num in indexs0) {
        NSInteger index_t = [num integerValue];
        if (![indexs containsObject:@(index_t)]) {
            [indexs addObject:@(index_t)];
        }
    }
    NSMutableArray *indexs1 = [self equalIndexsWithNumber:number row:single.row index:index];
    for (NSNumber *num in indexs1) {
        NSInteger index_t = [num integerValue];
        if (![indexs containsObject:@(index_t)]) {
            [indexs addObject:@(index_t)];
        }
    }
    NSMutableArray *indexs2 = [self equalIndexsWithNumber:number section:single.section row:single.row index:index];
    for (NSNumber *num in indexs2) {
        NSInteger index_t = [num integerValue];
        if (![indexs containsObject:@(index_t)]) {
            [indexs addObject:@(index_t)];
        }
    }
    for (NSNumber *num in indexs) {
        NSInteger index_t = [num integerValue];
        LENSudokuSupposeSingleView *view_t = self.supposeSingleViews[index_t];
        [view_t statusUpdateWithStatus:(LENSudokuSingleStatusSupposeFillInError)];
        LENSudokuSingleModel *single_t = self.supposeSingles[index_t];
        single_t.status = LENSudokuSingleStatusSupposeFillInError;
        self.supposeSingles[index_t] = single_t;
    }
}

- (NSMutableArray *)equalIndexsWithNumber:(int)number section:(NSInteger)section index:(NSInteger)index{
    NSMutableArray *indexs = [NSMutableArray array];
    for (NSInteger i = 0; i < 9; i++) {
        NSInteger index_t = section * 9 + i;
        LENSudokuSingleModel *single = self.supposeSingles[index_t];
        if ((single.fillIn == number || single.supposeFillIn == number) && index_t != index && (single.status == LENSudokuSingleStatusSupposeFillIn || single.status == LENSudokuSingleStatusSupposeFillInError)) {
            [indexs addObject:@(index_t)];
        }
    }
    return indexs;
}

- (NSMutableArray *)equalIndexsWithNumber:(int)number row:(NSInteger)row index:(NSInteger)index{
    NSMutableArray *indexs = [NSMutableArray array];
    for (NSInteger i = 0; i < 9; i++) {
        NSInteger index_t = i * 9 + row;
        LENSudokuSingleModel *single = self.supposeSingles[index_t];
        if ((single.fillIn == number || single.supposeFillIn == number) && index_t != index && (single.status == LENSudokuSingleStatusSupposeFillIn || single.status == LENSudokuSingleStatusSupposeFillInError)) {
            [indexs addObject:@(index_t)];
        }
    }
    return indexs;
}

- (NSMutableArray *)equalIndexsWithNumber:(int)number section:(NSInteger)section row:(NSInteger)row index:(NSInteger)index{
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
        LENSudokuSingleModel *single = self.supposeSingles[nine];
        if ((single.fillIn == number || single.supposeFillIn == number) && nine != index && (single.status == LENSudokuSingleStatusSupposeFillIn || single.status == LENSudokuSingleStatusSupposeFillInError)) {
            [indexs addObject:@(nine)];
        }
    }
    return indexs;
}


@end
