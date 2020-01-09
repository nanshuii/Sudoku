//
//  LENSudokuSingleView.m
//  Sudoku
//
//  Created by 林南水 on 2020/1/6.
//  Copyright © 2020 ledon. All rights reserved.
//

#import "LENSudokuSingleView.h"

@interface LENSudokuSingleView()

@property (nonatomic, strong) LENSudokuSingleModel *model;

@end

@implementation LENSudokuSingleView

- (instancetype)initWithFrame:(CGRect)frame model:(LENSudokuSingleModel *)model{
    self = [super initWithFrame:frame];
    if (self) {
        self.model = model;
        [self configureUI];
    }
    return self;
}

- (void)configureUI{
    
}

@end
