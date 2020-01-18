//
//  LENStyleHandle.h
//  Sudoku
//
//  Created by 戴十三 on 2020/1/18.
//  Copyright © 2020 ledon. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LENStyleHandle : NSObject

+ (LENSudokuStyleModel *)styleModelWithStyle:(LENSudokuStyle)style;

@end

NS_ASSUME_NONNULL_END
