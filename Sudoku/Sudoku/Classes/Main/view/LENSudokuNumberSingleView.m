//
//  LENSudokuNumberSingleView.m
//  Sudoku
//
//  Created by 戴十三 on 2020/1/13.
//  Copyright © 2020 ledon. All rights reserved.
//

#import "LENSudokuNumberSingleView.h"

@interface LENSudokuNumberSingleView()

@property (nonatomic, assign) LENSudokuStyle style;

@property (nonatomic, strong) UIView *view;

@property (nonatomic, strong) UILabel *label;

@property (nonatomic, assign) int number;

@end

@implementation LENSudokuNumberSingleView

- (instancetype)initWithFrame:(CGRect)frame style:(LENSudokuStyle)style number:(int)number{
    self = [super initWithFrame:frame];
    if (self) {
        self.style = style;
        self.number = number;
        [self configureUI];
    }
    return self;
}

- (void)configureUI{
    self.view = [[UIView alloc] initWithFrame:self.bounds];
    self.view.backgroundColor = [UIColor whiteColor];
    self.view.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.view.layer.borderWidth = 1;
    [self addSubview:self.view];
    
    self.label = [UILabel new];
    self.label.font = [UIFont systemFontOfSize:12];
    self.label.textColor = [UIColor blackColor];
    self.label.text = [NSString stringWithFormat:@"%i", self.number];
    [self.view addSubview:self.label];
    [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.centerY.mas_equalTo(self.view.mas_centerY);
    }];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
    [self addGestureRecognizer:tap];
}

- (void)tap{
    if (self.tapBlock) {
        self.tapBlock(self.number);
    }
}

# pragma mark -- edit
- (void)beEditing:(BOOL)editing{
    if (editing) {
        self.label.textColor = [UIColor redColor];
    } else {
        self.label.textColor = [UIColor blackColor];
    }
}

@end
