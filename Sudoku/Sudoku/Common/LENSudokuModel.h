//
//  LENSudokuModel.h
//  Sudoku
//
//  Created by 林南水 on 2020/1/6.
//  Copyright © 2020 ledon. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LENSudokuModel : NSObject

@property (nonatomic, assign) LENSudokuType type; // 难度

@property (nonatomic, assign) LENSudokuStyle style; // 样式

@property (nonatomic, copy) NSMutableArray *singles;

@property (nonatomic, assign) NSInteger time; // 时间 单位秒

@property (nonatomic, assign) NSInteger errorTimes; // 错误次数

@property (nonatomic, copy) NSMutableArray *numbers; // 已经填入的所有数字数量集合 1-9排列


@end

NS_ASSUME_NONNULL_END
