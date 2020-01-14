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


@end

NS_ASSUME_NONNULL_END
