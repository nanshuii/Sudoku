//
//  LENHandle.m
//  Sudoku
//
//  Created by 林南水 on 2020/1/6.
//  Copyright © 2020 ledon. All rights reserved.
//

#import "LENHandle.h"

@implementation LENHandle

# pragma mark -- sudoku创建
+ (LENSudokuModel *)sudoKuCreateWithType:(LENSudokuType)type style:(LENSudokuStyle)style{
    LENSudokuModel *model = [LENSudokuModel new];
    model.type = type;
    model.style = style;
    model.singles = [self sudokuSinglesCreateWithType:type];
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
//    NSMutableArray *n = [NSMutableArray array];
//    NSInteger time = [[NSDate date] timeIntervalSince1970];
//    for (int i = 0; i < 1000; i++) {
//        NSMutableArray *numbers = [self numbersCreate];
//        [n addObject:numbers];
//    }
//    NSInteger time1 = [[NSDate date] timeIntervalSince1970];
//    for (int i = 0; i < n.count; i++) {
//        BOOL verity = [self veritySudokuWithNumbers:n[i]];
//        if (verity == NO) {
//            NSLog(@"不合格");
//        }
//    }
//    NSInteger time2 = [[NSDate date] timeIntervalSince1970];
//    NSLog(@"%i %i", time1 - time, time2 - time1);
    
    NSMutableArray *numbers = [self numbersCreate];
    NSMutableArray *singles = [self singlesCreateWithMin:4 max:6 numbers:numbers];
    return singles;
}

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

# pragma mark -- 生成算法1 每行少n-m个
+ (NSMutableArray *)singlesCreateWithMin:(int)min max:(int)max numbers:(NSArray *)numbers{
    NSMutableArray *singles = [NSMutableArray arrayWithCapacity:81];
    int m = max;
    NSMutableArray *randoms = [NSMutableArray array];
    NSArray *array = @[@"0", @"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8"];
    for (int i = 0; i < numbers.count; i++) {
        int index = i % 9;
        if (index == 0) {
            // 需要更换m
            m = [self singlesRandomMCreateWithMin:min max:max];
            randoms = [self randomWithArray:array times:m];
            NSLog(@"i = %i m = %i array = %@", i, m, array.description);
        }
        LENSudokuSingleModel *model = [LENSudokuSingleModel new];
        model.fillIn = [numbers[i] intValue];
        if ([randoms containsObject:[NSString stringWithFormat:@"%i", index]]) {
            // 不显示
            model.status = LENSudokuSingleStatusNone;
        } else {
            model.status = LENSudokuSingleStatusFillIn;
        }
        model.section = i / 9; // section
        model.row = index; // row
        [singles addObject:model];
    }
    return singles;
}

// 从最小值和最大值之后随机出一个数字
+ (int)singlesRandomMCreateWithMin:(int)min max:(int)max{
    int m = max;
    if (max > min) {
        int m_ = max - min + 1;
        int m_r = arc4random_uniform(m_);
        m = m_r + min;
    }
    return m;
}

// 从0-9中随机出一个数组 填入stirng数组 生成string数组
+ (NSMutableArray *)randomWithArray:(NSArray *)array times:(int)times{
    NSMutableArray *randoms = [NSMutableArray arrayWithCapacity:times];
    int count = (int)array.count;
    while (times == 0) {
        int num = arc4random_uniform(count);
        NSString *string = array[num];
        if (![randoms containsObject:string]) {
            [randoms addObject:string];
            times--;
        }
    }
    return randoms;
}

@end
