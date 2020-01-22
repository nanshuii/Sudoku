//
//  LENHandle.m
//  Sudoku
//
//  Created by 林南水 on 2020/1/6.
//  Copyright © 2020 ledon. All rights reserved.
//

#import "LENHandle.h"
#import "LENStyleHandle.h"

@implementation LENHandle

# pragma mark -- sudoku创建
+ (LENSudokuModel *)sudoKuCreateWithType:(LENSudokuType)type{
    LENSudokuModel *model = [LENSudokuModel new];
    model.type = type;
    model.singles = [self sudokuSinglesCreateWithType:type];
    model.time = 0;
    model.errorTimes = 0;
    model.status = 0;
    model.numbers = [self sudokuFillInNumbersCreateWithSoduku:model];
    NSDate *date = [NSDate new];
    NSInteger startTime = [date timeIntervalSince1970];
    model.startTime = startTime;
    model.startTimeString = [self YMDHMSStringWithTimestamp:startTime];
    return model;
}

# pragma mark -- sudoku打印
+ (void)logSudokuWithNumbers:(NSMutableArray *)numbers{
    for (int i = 0; i < numbers.count / 9; i++) {
        NSString *string = @"";
        for (int j = 0; j < 9; j++) {
            int index = i * 9 + j;
            NSString *string_t = @"0";
            if (index < numbers.count) {
                string_t = numbers[index];
            }
            string = [NSString stringWithFormat:@"%@ %@", string, string_t];
        }
        NSLog(@"%i----%@", i, string);
    }
}

# pragma mark -- sudoku验证
+ (BOOL)veritySudokuWithNumbers:(NSMutableArray *)numbers{
    NSMutableArray *array = [NSMutableArray arrayWithArray:@[@"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9"]];
    // 检查横排
    for (int i = 0; i < 9; i++) {
        NSMutableArray *array0 = [NSMutableArray arrayWithArray:array];
        for (int j = 0; j < 9; j++) {
            int index = i * 9 + j;
            NSString *num = numbers[index];
            if ([array0 containsObject:num]) {
                [array0 removeObject:num];
            }
        }
        if (array0.count != 0) {
            return NO;
        }
    }
    // 检查竖排
    for (int i = 0; i < 9; i++) {
        NSMutableArray *array0 = [NSMutableArray arrayWithArray:array];
        for (int j = 0; j < 9; j++) {
            int index = j * 9 + i;
            NSString *num = numbers[index];
            if ([array0 containsObject:num]) {
                [array0 removeObject:num];
            }
        }
        if (array0.count != 0) {
            return NO;
        }
    }
    // 九宫格检查
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
    for (int i = 0; i < 9; i++) {
        NSArray *arr = arr9[i];
        NSMutableArray *arr_t = [NSMutableArray arrayWithArray:array];
        for (int j = 0; j < 9; j++) {
            int index = [arr[j] intValue];
            NSString *num = numbers[index];
            if ([arr_t containsObject:num]) {
                [arr_t removeObject:num];
            }
        }
        if (arr_t.count != 0) {
            return NO;
        }
    }
    
    return YES;
}

# pragma mark -- 随机数生成
+ (NSMutableArray *)sudokuSinglesCreateWithType:(LENSudokuType)type{
    NSMutableArray *numbers = [self numbersCreate];
    NSMutableArray *singles = [self singlesCreateWithType:type];
    NSMutableArray *models = [NSMutableArray array];
    for (int i = 0; i < 81; i++) {
        LENSudokuSingleModel *single = [LENSudokuSingleModel new];
        int section = i / 9;
        int row = i % 9;
        single.section = section;
        single.row = row;
        NSString *status = singles[i];
        if ([status isEqualToString:@"1"]) {
            single.status = LENSudokuSingleStatusFillIn;
        } else {
            single.status = LENSudokuSingleStatusNone;
        }
        single.fillIn = [numbers[i] integerValue];
        [models addObject:single];
    }
    return models;
}

# pragma mark -- 81位string类型随机数数据表格生成
+ (NSMutableArray *)numbersCreate{
    NSMutableArray *numbers = [NSMutableArray array];
    BOOL create = NO;
    while (create == NO) {
        NSMutableArray *numbers_t = [NSMutableArray array];
        for (int i = 0; i < 9; i++) {
            numbers_t = [self numbersCreateWithNumbers:numbers_t section:i];
            if (numbers_t.count == 0) {
                break;
            }
        }
        if (numbers_t.count == 81) {
            numbers = numbers_t;
            create = YES;
        }
    }
    return numbers;
}

# pragma mark -- 单行随机数生成
+ (NSMutableArray *)numbersCreateWithNumbers:(NSMutableArray *)numbers section:(int)section{
    NSMutableArray *nums_none = [NSMutableArray array];
    NSMutableArray *nums = [NSMutableArray array];
    NSMutableArray *array = [NSMutableArray arrayWithArray:@[@"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9"]];
    if (section == 8) {
        NSMutableArray *array0 = [NSMutableArray arrayWithArray:array];
        for (int i = 0; i < 9; i++) {
            NSMutableArray *array1 = [NSMutableArray arrayWithArray:array0];
            for (int j = 0; j < 8; j++) {
                int index = j * 9 + i;
                NSString *num = numbers[index];
                [array1 removeObject:num];
            }
            NSString *num = array1[0];
            [numbers addObject:num];
        }
        return numbers;
    }
    
    // 获取前四个数字
    for (int i = 0; i < 4; i++) {
        NSMutableArray *array0 = [self numbersCreateWithNumbers:numbers array:array section:section row:i];
        int count0 = (int)array0.count;
        if (count0 == 0) {
            return nums_none;
        }
        int random0 = arc4random_uniform(count0);
        NSString *num0 = array0[random0];
        [array removeObject:num0];
        [numbers addObject:num0];
    }
    // 获取第五个数字
    NSMutableArray *array0 = [self numbersCreateWithNumbers:numbers array:array section:section row:4];
    int count0 = (int)array0.count;
    if (count0 == 0) {
        return nums_none;
    }
    for (int i = 0; i < count0; i++) {
        NSMutableArray *array_t = [NSMutableArray arrayWithArray:array];
        NSMutableArray *numbers_t = [NSMutableArray arrayWithArray:numbers];
        NSString *num0 = array0[i];
        [array_t removeObject:num0];
        [numbers_t addObject:num0];
        // 获取第六个数字
        NSMutableArray *array1 = [self numbersCreateWithNumbers:numbers_t array:array_t section:section row:5];
        int count1 = (int)array1.count;
        if (count1 == 0) {
            return nums_none;
        }
        for (int j = 0; j < count1; j++) {
            NSMutableArray *array_t1 = [NSMutableArray arrayWithArray:array_t];
            NSMutableArray *numbers_t1 = [NSMutableArray arrayWithArray:numbers_t];
            NSString *num1 = array1[j];
            [array_t1 removeObject:num1];
            [numbers_t1 addObject:num1];
            // 获取七八九的数字
            NSMutableArray *array_t2 = [self numbers789CreateWithNumber:numbers_t1 array:array_t1 section:section];
//            NSLog(@"arrayt2 = %@", array_t2.description);
            if (array_t2.count == 3) {
                [numbers_t1 addObjectsFromArray:array_t2];
                [nums addObject:numbers_t1];
            }
        }
    }
    int count = (int)nums.count;
    if (count == 0) {
        return nums_none;
    }
    int random = arc4random_uniform(count);
    return nums[random];
}

# pragma mark -- 单行随机数789位置生成 返回一个随机的3位数组
+ (NSMutableArray *)numbers789CreateWithNumber:(NSMutableArray *)numbers array:(NSMutableArray *)array section:(int)section{
    NSMutableArray *nums = [NSMutableArray array];
    int section0 = section % 3;
    // 是否满足九宫格的条件
    if (section0 > 0) {
        for (int i = 0; i < section0; i++) {
            for (int j = 0; j < 3; j++) {
                int index = (section - i - 1) * 9 + 6 + j;
                NSString *num = numbers[index];
                if ([array containsObject:num]) {
                    // 不符合九宫格条件
                    return nums;
                }
            }
        }
    }
    // 随机挑选 判断是否满足竖排条件
    NSMutableArray *array0 = [NSMutableArray array];
    NSMutableArray *array1 = [NSMutableArray array];
    NSMutableArray *array2 = [NSMutableArray array];
    for (int i = 0; i < 3; i++) {
        for (int j = 0; j < section; j++) {
            int index = j * 9 + 6 + i;
            NSString *num = numbers[index];
            if (i == 0) {
                [array0 addObject:num];
            } else if (i == 1) {
                [array1 addObject:num];
            } else {
                [array2 addObject:num];
            }
        }
    }
    for (int i = 0; i < 3; i++) {
        NSString *num0 = array[i]; // 7
        if (![array0 containsObject:num0]) {
            NSMutableArray *array_t = [NSMutableArray arrayWithArray:array];
            [array_t removeObject:num0];
            for (int j = 0; j < 2; j++) {
                NSString *num1 = array_t[j];
                if (![array1 containsObject:num1]) {
                    NSMutableArray *array_t1 = [NSMutableArray arrayWithArray:array_t];
                    [array_t1 removeObject:num1];
                    NSString *num2 = array_t1[0];
                    if (![array2 containsObject:num2]) {
                        NSMutableArray *array_t2 = [NSMutableArray arrayWithArray:@[num0, num1, num2]];
                        [nums addObject:array_t2];
                    }
                }
            }
        }
    }
    int count = (int)nums.count;
    if (count == 0) {
        return nums;
    }
    int random = arc4random_uniform(count);
    NSMutableArray *nums_r = nums[random];
    return nums_r;
}

# pragma mark -- 单个随机数生成组合
+ (NSMutableArray *)numbersCreateWithNumbers:(NSMutableArray *)numbers array:(NSMutableArray *)array section:(int)section row:(int)row{
    NSMutableArray *array_t = [NSMutableArray arrayWithArray:array];
    int section0 = section % 3;
    // 去除九宫格n上两排的数
    if (section > 0) {
        int row0 = row / 3 * 3;
        for (int i = 0; i < section0; i++) {
            for (int j = 0; j < 3; j++) {
                int index = (section - i - 1) * 9 + row0 + j;
                NSString *num = numbers[index];
                if ([array_t containsObject:num]) {
                    [array_t removeObject:num];
                }
            }
        }
    }
    // 去除竖排的其他相同数字
    for (int i = 0; i < section; i++) {
        int index = i * 9 + row;
        NSString *num = numbers[index];
        if ([array_t containsObject:num]) {
            [array_t removeObject:num];
        }
    }
    return array_t;
}

# pragma mark -- 显示和隐藏算法的生成
+ (NSMutableArray *)singlesCreateWithType:(LENSudokuType)type{
    switch (type) {
        case LENSudokuTypeOne:
            return [self singlesCreateOneWithMax:1 min:1 maxForSingle:1];
            break;
        case LENSudokuTypeTwo:
            return [self singlesCreateOneWithMax:2 min:2 maxForSingle:2];
            break;
        case LENSudokuTypeThree:
            return [self singlesCreateOneWithMax:3 min:2 maxForSingle:3];
            break;
        case LENSudokuTypeFour:
            return [self singlesCreateOneWithMax:4 min:3 maxForSingle:4];
            break;
        case LENSudokuTypeFive:
            return [self singlesCreateOneWithMax:5 min:4 maxForSingle:5];
            break;
        case LENSudokuTypeSix:
            return [self singlesCreateOneWithMax:7 min:5 maxForSingle:6];
            break;
        case LENSudokuTypeSeven:
            return [self singlesCreateOneWithMax:7 min:6 maxForSingle:7];
            break;
        default:
            break;
    }
    // 默认难度一
    return [self singlesCreateOneWithMax:1 min:1 maxForSingle:1];
}

# pragma mark -- sudoku算法一
/// 算法一
/// @param max max description
/// @param min min description
/// @param maxForSingle // 每一种隐藏的方式中的最大值
+ (NSMutableArray *)singlesCreateOneWithMax:(int)max min:(int)min maxForSingle:(int)maxForSingle{
    // 1代表显示 0代表隐藏
    NSMutableArray *randoms = [NSMutableArray arrayWithCapacity:81];
    for (int i = 0; i < 81; i++) {
        [randoms addObject:@"1"];
    }
    // 从横排开始隐藏
    for (int i = 0; i < 9; i++) {
        // 获取每一行能够隐藏的index
        NSMutableArray *indexs = [self randomsWithRandoms:randoms section:i];
        int single = [self singlesRandomMCreateWithMin:min max:max];
        // 需要隐藏的index集合
        NSMutableArray *numbers = [self randomsWithRandoms:indexs random:single max:maxForSingle];
        for (NSNumber *number in numbers) {
            int index = [number intValue];
            randoms[index] = @"0";
        }
    }
    
    // 竖排的隐藏
    for (int i = 0; i < 9; i++) {
        NSMutableArray *indexs = [self randomsWithRandoms:randoms row:i];
        int single = [self singlesRandomMCreateWithMin:min max:max];
        NSMutableArray *numbers = [self randomsWithRandoms:indexs random:single max:maxForSingle];
        for (NSNumber *number in numbers) {
            int index = [number intValue];
            randoms[index] = @"0";
        }
    }
    
    // 九宫格的隐藏
    for (int i = 0; i < 9; i++) {
        NSMutableArray *indexs = [self randomsWithRandoms:randoms index:i];
        int single = [self singlesRandomMCreateWithMin:min max:max];
        NSMutableArray *numbers = [self randomsWithRandoms:indexs random:single max:maxForSingle];
        for (NSNumber *number in numbers) {
            int index = [number intValue];
            randoms[index] = @"0";
        }
    }
    
    return randoms;
}

# pragma mark -- 从最小值和最大值之后随机出一个数字
+ (int)singlesRandomMCreateWithMin:(int)min max:(int)max{
    int m = max;
    if (max > min) {
        int m_ = max - min + 1;
        int m_r = arc4random_uniform(m_);
        m = m_r + min;
    }
    return m;
}

# pragma mark -- 获取可以隐藏的数组 横排
+ (NSMutableArray *)randomsWithRandoms:(NSMutableArray *)randoms section:(int)section{
    NSMutableArray *indexs = [NSMutableArray array];
    for (int i = 0; i < 9; i++) {
        int index = section * 9 + i;
        NSString *num = randoms[index];
        if ([num isEqualToString:@"1"]) {
            [indexs addObject:@(index)];
        }
    }
    return indexs;
}

# pragma mark -- 获取可以隐藏的数组 竖排
+ (NSMutableArray *)randomsWithRandoms:(NSMutableArray *)randoms row:(int)row{
    NSMutableArray *indexs = [NSMutableArray array];
    for (int i = 0; i < 9; i++) {
        int index = i * 9 + row;
        NSString *num = randoms[index];
        if ([num isEqualToString:@"1"]) {
            [indexs addObject:@(index)];
        }
    }
    return indexs;
}

# pragma mark -- 获取可以隐藏的数组 九宫格
+ (NSMutableArray *)randomsWithRandoms:(NSMutableArray *)randoms index:(int)index{
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
    NSArray *array = arr9[index];
    NSMutableArray *indexs = [NSMutableArray array];
    for (int i = 0; i < 9; i++) {
        int index = [array[i] intValue];
        NSString *num = randoms[index];
        if ([num isEqualToString:@"1"]) {
            [indexs addObject:@(index)];
        }
    }
    return indexs;
}

# pragma mark -- 根据random需要隐藏的数量，max最大的隐藏值，返回一个已经选择好的数据
+ (NSMutableArray *)randomsWithRandoms:(NSMutableArray *)randoms random:(int)random max:(int)max{
    NSMutableArray *nums = [NSMutableArray array];
    while (9 - (int)randoms.count < max && randoms.count > 0 && random > 0) {
        int ran = arc4random_uniform((int)randoms.count-1);
        int index = [randoms[ran] intValue];
        [nums addObject:@(index)];
        [randoms removeObject:@(index)];
        random--;
    }
    return nums;
}

# pragma mark -- 当前sudoku存储
+ (void)currentSudokuSave:(nullable LENSudokuModel *)model{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if (model == nil) {
        [defaults removeObjectForKey:LENCurrentSudokuKey];
    } else {
        NSMutableArray *singles = [NSMutableArray array];
        for (LENSudokuSingleModel *single in model.singles) {
            NSDictionary *singleDict = [single mj_keyValues];
            [singles addObject:singleDict];
        }
        model.singles = singles;
        NSDictionary *dict = [model mj_keyValues];
        [defaults setValue:dict forKey:LENCurrentSudokuKey];
    }
    [defaults synchronize];
}

# pragma mark -- 当前sudoku读取
+ (LENSudokuModel *)currentSudokuRead{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults valueForKey:LENCurrentSudokuKey]) {
        NSDictionary *dict = [defaults valueForKey:LENCurrentSudokuKey];
        LENSudokuModel *model = [LENSudokuModel mj_objectWithKeyValues:dict];
        NSMutableArray *singles = [NSMutableArray array];
        for (NSDictionary *singleDict in model.singles) {
            LENSudokuSingleModel *single = [LENSudokuSingleModel mj_objectWithKeyValues:singleDict];
            [singles addObject:single];
        }
        model.singles = singles;
        return model;
    } else {
        return nil;
    }
}

# pragma mark -- 存入一个新的sudoku进sudokus
+ (void)sudokuInsertToSudokusWithSudoku:(LENSudokuModel *)sudoku status:(int)status{
    // status 1 end 2 finish
    NSDate *date = [NSDate new];
    NSInteger endTime = [date timeIntervalSince1970];
    sudoku.endTime = endTime;
    sudoku.endTimeString = [self YMDHMSStringWithTimestamp:endTime];
    sudoku.status = status;
    sudoku.singles = [NSMutableArray array];
    NSDictionary *dict = [sudoku mj_keyValues];
    NSArray *array = [self sudokusRead];
    NSMutableArray *sudokus = [NSMutableArray arrayWithArray:array];
    [sudokus insertObject:dict atIndex:0];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setValue:sudokus forKey:LENSudokusKey];
    [defaults synchronize];
}

# pragma mark -- sudokus read
+ (NSArray *)sudokusRead{
    NSArray *sudokus = [NSArray array];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults valueForKey:LENSudokusKey]) {
        sudokus = [defaults valueForKey:LENSudokusKey];
    }
    return sudokus;
}

# pragma mark -- sudokus read
+ (NSMutableArray *)sudokuModelsRead{
    NSMutableArray *sudokus = [NSMutableArray array];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults valueForKey:LENSudokusKey]) {
        NSArray *array = [defaults valueForKey:LENSudokusKey];
        // 读取的数值没有singles
        for (NSDictionary *dict in array) {
            LENSudokuModel *sudoku = [LENSudokuModel mj_objectWithKeyValues:dict];
            [sudokus addObject:sudoku];
        }
    }
    return sudokus;
}



# pragma mark -- 获取sudoku中已经全部填入的数字的数量
+ (NSMutableArray *)sudokuFillInNumbersCreateWithSoduku:(LENSudokuModel *)sudoku{
    // 数字数组创建
    NSMutableArray *array = [NSMutableArray array];
    for (int i = 0; i < 9; i++) {
        [array addObject:@(0)];
    }
    // 遍历填入数字
    for (LENSudokuSingleModel *single in sudoku.singles) {
        if (single.status == LENSudokuSingleStatusFillIn) {
            NSInteger fillIn = single.fillIn;
            NSNumber *number = array[fillIn-1];
            int num = [number intValue];
            num += 1;
            array[fillIn-1] = @(num);
        }
    }
    return array;
}

# pragma mark -- 获取soduku numbers中数量为9的数字
+ (NSMutableArray *)sodukuFillInNumberAllWithNumbers:(NSMutableArray *)numbers{
    NSMutableArray *array = [NSMutableArray array];
    for (int i = 0; i < numbers.count; i++) {
        int number = [numbers[i] intValue];
        if (number == 9) {
            [array addObject:@(i+1)];
        }
    }
    return array;
}

# pragma mark -- 根据style返回model
+ (LENSudokuStyleModel *)styleModelWithStyle:(LENSudokuStyle)style{
    return [LENStyleHandle styleModelWithStyle:style];
}

# pragma mark -- default configure read
+ (LENDefaultConfigModel *)defaultConfigureRead{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults valueForKey:LENDefaultConfigureKey]) {
        NSDictionary *dict = [defaults valueForKey:LENDefaultConfigureKey];
        LENDefaultConfigModel *model = [LENDefaultConfigModel mj_objectWithKeyValues:dict];
        return model;
    } else {
        return [self defaultsConfigureModel];
    }
}

+ (LENDefaultConfigModel *)defaultsConfigureModel{
    LENDefaultConfigModel *model = [LENDefaultConfigModel new];
    model.volume = 1.0;
    model.timerHidden = NO;
    model.style = LENSudokuStyleNone;
    return model;
}

# pragma mark -- default configure save
+ (void)defaultConfigureSave:(LENDefaultConfigModel *)model{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *dict = [model mj_keyValues];
    [defaults setValue:dict forKey:LENDefaultConfigureKey];
    [defaults synchronize];
}

# pragma mark -- sudoku根据section和row返回index
+ (NSInteger)indexWithSection:(NSInteger)section row:(NSInteger)row{
    return section * 9 + row;
}

# pragma mark -- 难度string
+ (NSString *)typeStringWithType:(LENSudokuType)type{
    NSString *string = @"难度一";
    switch (type) {
        case LENSudokuTypeOne:
            string = @"难度一";
            break;
        case LENSudokuTypeTwo:
            string = @"难度二";
            break;
        case LENSudokuTypeThree:
            string = @"难度三";
            break;
        case LENSudokuTypeFour:
            string = @"难度四";
            break;
        case LENSudokuTypeFive:
            string = @"难度五";
            break;
        case LENSudokuTypeSix:
            string = @"难度六";
            break;
        case LENSudokuTypeSeven:
            string = @"难度七";
            break;
        case LENSudokuTypeEight:
            string = @"难度八";
            break;
        case LENSudokuTypeNine:
            string = @"难度九";
            break;
        case LENSudokuTypeTen:
            string = @"难度十";
            break;
        default:
            break;
    }
    return string;
}

# pragma mark -- timestamp to YMD
+ (NSString *)YMDHMSStringWithTimestamp:(NSInteger)timestamp{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timestamp];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    formatter.timeZone = [NSTimeZone timeZoneWithName:zone.name];
    NSString *string = [formatter stringFromDate: date];
    return string;
}

# pragma mark -- yyyy-MM-dd HH:mm:ss to [yyyy-MM-dd, HH:mm:ss, yyyy-MM, d]
+ (NSMutableArray *)dateArrayWithDateString:(NSString *)dateString{
    NSMutableArray *dates = [NSMutableArray array];
    NSArray *array = [dateString componentsSeparatedByString:@" "];
    NSString *ymd = array[0];
    NSString *hms = array[1];
    // yyyy-MM-dd
    [dates addObject:ymd];
    // HH:mm:ss
    [dates addObject:hms];
    // yyyy-MM
    NSArray *array1 = [ymd componentsSeparatedByString:@"-"];
    NSString *ym = [NSString stringWithFormat:@"%@-%@", array1[0], array1[1]];
    [dates addObject:ym];
    // d
    NSString *d = array1[2];
    [dates addObject:d];
    return dates;
}


@end
