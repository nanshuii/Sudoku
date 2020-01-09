//
//  LENSudokuSingleModel.h
//  Sudoku
//
//  Created by 林南水 on 2020/1/6.
//  Copyright © 2020 ledon. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LENSudokuSingleModel : NSObject

@property (nonatomic, assign) NSInteger section;

@property (nonatomic, assign) NSInteger row;

@property (nonatomic, assign) LENSudokuSingleStatus status; // 格子状态

@property (nonatomic, assign) NSInteger fillIn; // 格子填入的数字

@property (nonatomic, copy) NSMutableArray <NSNumber *> *marks; // 标记


@end

NS_ASSUME_NONNULL_END
