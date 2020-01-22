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

@property (nonatomic, assign) NSInteger s_id;

@property (nonatomic, assign) LENSudokuType type; // 难度

@property (nonatomic, strong) NSMutableArray *singles;

@property (nonatomic, assign) NSInteger time; // 时间 单位秒

@property (nonatomic, assign) NSInteger errorTimes; // 错误次数

@property (nonatomic, strong) NSMutableArray *numbers; // 已经填入的所有数字数量集合 1-9排列

@property (nonatomic, assign) NSInteger status; // 0 new 1 end 2 finish

@property (nonatomic, assign) NSInteger startTime;

@property (nonatomic, assign) NSInteger endTime;

@property (nonatomic, copy) NSString *startTimeString;

@property (nonatomic, copy) NSString *endTimeString;

// 临时调用的数据
@property (nonatomic, copy) NSString *endTimeString_hms;

@property (nonatomic, copy) NSString *endTimeString_d;


@end

NS_ASSUME_NONNULL_END
