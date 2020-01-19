//
//  LENStyleHandle.m
//  Sudoku
//
//  Created by 戴十三 on 2020/1/18.
//  Copyright © 2020 ledon. All rights reserved.
//

#import "LENStyleHandle.h"

@implementation LENStyleHandle

+ (LENSudokuStyleModel *)styleModelWithStyle:(LENSudokuStyle)style{
    LENSudokuStyleModel *model = [self defaultModel];
    switch (style) {
        case LENSudokuStyleNone:
            
            break;
            
        default:
            break;
    }
    return model;
}

+ (LENSudokuStyleModel *)defaultModel{
    LENSudokuStyleModel *model = [LENSudokuStyleModel new];
    // sudokuView 浅灰色主调
    model.sudokuViewBoardColor = UIColorFromHex(0x5F9EA0);
    model.sudokuViewLineBigColor = UIColorFromHex(0x708090);
    model.sudokuViewLineColor = UIColorFromHex(0x778899);
    model.sudokuViewSingleBackgroundColor = UIColorFromHex(0xFFFFFF);
    model.sudokuViewSingleHighLightBackgroundColor = UIColorFromHex(0x5F9EA0);
    model.sudokuViewSingleMarkBackgroundColor = UIColorFromHex(0xFFFFFF);
    model.sudokuViewSingleFillInTextColor = UIColorFromHex(0x333333);
    model.sudokuViewSingleMarkTextColor = UIColorFromHex(0x333333);
    // sudokuSupposeView
    model.sudokuSupposeBackgroundColor = UIColorFromHex(0x778899);
    model.sudokuSupposeSingleBackgroundColor = [UIColor clearColor];
    model.sudokuSupposeSingleHighLightBackgroundColor = UIColorFromHex(0x5F9EA0);
    model.sudokuSupposeSingleFillInTextColor = UIColorFromHex(0x333333);
    model.sudokuSupposeSingleFillInErrorTextColor = UIColorFromHex(0x0000FF);
    // numbersView normal 深灰色主调
    model.numbersViewNormalBackgroundColor = UIColorFromHex(0x2F4F4F);
    model.numbersViewNormalTextColor = UIColorFromHex(0xFFFFFF);
    model.numbersViewNormalEnableBackgroundColor = UIColorFromHex(0x2F4F4F);
    model.numbersViewNormalEnableTextColor = UIColorFromHex(0xFFFFFF);
    // numbersView mark 蓝色主调
    model.numbersViewMarkBackgroundColor = UIColorFromHex(0x6495ED);
    model.numbersViewMarkTextColor = UIColorFromHex(0xFFFFFF);
    model.numbersViewMarkEnableBackgroundColor = UIColorFromHex(0x6495ED);
    model.numbersViewMarkEnableTextColor = UIColorFromHex(0xFFFFFF);
    model.numbersViewMarkSelectedBackgroundColor = UIColorFromHex(0x000080);
    model.numbersViewMarkSelectedTextColor = UIColorFromHex(0xFFFFFF);
    // errors times
    model.errorTimesTextColor = UIColorFromHex(0x228B22);
    model.timesTextColor = UIColorFromHex(0x2F4F4F);
    return model;
}


@end
