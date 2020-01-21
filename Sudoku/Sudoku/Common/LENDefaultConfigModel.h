//
//  LENDefaultConfigModel.h
//  Sudoku
//
//  Created by 戴十三 on 2020/1/18.
//  Copyright © 2020 ledon. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LENDefaultConfigModel : NSObject

@property (nonatomic, assign) LENSudokuStyle style; // 数独外观

@property (nonatomic, assign) CGFloat volume; // 音量

@property (nonatomic, assign) BOOL timerHidden; // 计时器隐藏

@property (nonatomic, assign) BOOL supposeCloseMark; // 预设时候关闭mark，相当于背景色不为clearColor

@end

NS_ASSUME_NONNULL_END
