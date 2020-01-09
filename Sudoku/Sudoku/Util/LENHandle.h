//
//  LENHandle.h
//  Sudoku
//
//  Created by 林南水 on 2020/1/6.
//  Copyright © 2020 ledon. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


@interface LENHandle : NSObject

# pragma mark -- sudoku创建
/// sudoku创建
/// @param type type description
/// @param style style description
+ (LENSudokuModel *)sudoKuCreateWithType:(LENSudokuType)type style:(LENSudokuStyle)style;

@end

NS_ASSUME_NONNULL_END
