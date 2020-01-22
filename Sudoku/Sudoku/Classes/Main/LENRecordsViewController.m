//
//  LENRecordsViewController.m
//  Sudoku
//
//  Created by 戴十三 on 2020/1/21.
//  Copyright © 2020 ledon. All rights reserved.
//

#import "LENRecordsViewController.h"
#import "LENRecordsDetailViewController.h"

@interface LENRecordsViewController ()

@property (nonatomic, strong) NSMutableArray *recordsToday;

@property (nonatomic, strong) NSMutableArray *recordsMonth;

@property (nonatomic, strong) NSMutableArray *months;

@property (nonatomic, strong) NSMutableArray *typesDoneMonth;

@property (nonatomic, strong) NSMutableArray *typesFinishMonth;

@property (nonatomic, strong) NSMutableArray *typesDoneToday;

@property (nonatomic, strong) NSMutableArray *typesFinishToday;

@end

@implementation LENRecordsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self recordsCreate];
    [self configureUI];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)configureUI{
    self.navigationController.navigationBarHidden = NO;
}

# pragma mark -- records 读取
- (void)recordsCreate{
    self.recordsToday = [NSMutableArray array];
    self.recordsMonth = [NSMutableArray array];
    self.months = [NSMutableArray array];
    self.typesDoneMonth = [NSMutableArray array];
    self.typesFinishMonth = [NSMutableArray array];
    self.typesDoneToday = [NSMutableArray array];
    self.typesFinishToday = [NSMutableArray array];
    int today_done = 0;
    int today_finish = 0;
    int month_done = 0;
    int month_finish = 0;
    int today_done_type1 = 0;
    int today_done_type2 = 0;
    int today_done_type3 = 0;
    int today_done_type4 = 0;
    int today_done_type5 = 0;
    int today_done_type6 = 0;
    int today_done_type7 = 0;
    int today_finish_type1 = 0;
    int today_finish_type2 = 0;
    int today_finish_type3 = 0;
    int today_finish_type4 = 0;
    int today_finish_type5 = 0;
    int today_finish_type6 = 0;
    int today_finish_type7 = 0;
    int month_done_type1 = 0;
    int month_done_type2 = 0;
    int month_done_type3 = 0;
    int month_done_type4 = 0;
    int month_done_type5 = 0;
    int month_done_type6 = 0;
    int month_done_type7 = 0;
    int month_finish_type1 = 0;
    int month_finish_type2 = 0;
    int month_finish_type3 = 0;
    int month_finish_type4 = 0;
    int month_finish_type5 = 0;
    int month_finish_type6 = 0;
    int month_finish_type7 = 0;
    NSMutableArray *records = [LENHandle sudokuModelsRead];
    // 根据一个月不同的日子分类出多个array
    NSDate *today = [NSDate new];
    NSInteger timestamp = [today timeIntervalSince1970];
    NSString *todayString = [LENHandle YMDHMSStringWithTimestamp:timestamp];
    NSMutableArray *todays = [LENHandle dateArrayWithDateString:todayString];
    NSString *today_ym = todays[2];
    NSString *today_d = todays[3];
    NSString *last_ymd = @"";
    NSMutableArray *temp = [NSMutableArray array];
    for (int i = 0; i < records.count; i++) {
        LENSudokuModel *sudoku = records[i];
        NSMutableArray *endTimeDates = [LENHandle dateArrayWithDateString:sudoku.endTimeString];
        NSString *end_ym = endTimeDates[2];
        if ([end_ym isEqualToString:today_ym]) {
            // 满足年月要求
            NSInteger status = sudoku.status;
            LENSudokuType type = sudoku.type;
            if (status == 1) {
                month_done += 1;
                if ([today_ym isEqualToString:end_ym]) {
                    // 今日end
                    switch (type) {
                        case LENSudokuTypeOne:
                            today_done_type1 += 1;
                            break;
                        case LENSudokuTypeTwo:
                            today_done_type2 += 1;
                            break;
                        case LENSudokuTypeThree:
                            today_done_type3 += 1;
                            break;
                        case LENSudokuTypeFour:
                            today_done_type4 += 1;
                            break;
                        case LENSudokuTypeFive:
                            today_done_type5 += 1;
                            break;
                        case LENSudokuTypeSix:
                            today_done_type6 += 1;
                            break;
                        case LENSudokuTypeSeven:
                            today_done_type7 += 1;
                            break;
                        default:
                            break;
                    }
                }
                // 本月end
                switch (type) {
                    case LENSudokuTypeOne:
                        month_done_type1 += 1;
                        break;
                    case LENSudokuTypeTwo:
                        month_done_type2 += 1;
                        break;
                    case LENSudokuTypeThree:
                        month_done_type3 += 1;
                        break;
                    case LENSudokuTypeFour:
                        month_done_type4 += 1;
                        break;
                    case LENSudokuTypeFive:
                        month_done_type5 += 1;
                        break;
                    case LENSudokuTypeSix:
                        month_done_type6 += 1;
                        break;
                    case LENSudokuTypeSeven:
                        month_done_type7 += 1;
                        break;
                    default:
                        break;
                }
            } else if (status == 2) {
                month_finish += 1;
                if ([today_ym isEqualToString:end_ym]) {
                    // 今日finish
                    switch (type) {
                        case LENSudokuTypeOne:
                            today_finish_type1 += 1;
                            break;
                        case LENSudokuTypeTwo:
                            today_finish_type2 += 1;
                            break;
                        case LENSudokuTypeThree:
                            today_finish_type3 += 1;
                            break;
                        case LENSudokuTypeFour:
                            today_finish_type4 += 1;
                            break;
                        case LENSudokuTypeFive:
                            today_finish_type5 += 1;
                            break;
                        case LENSudokuTypeSix:
                            today_finish_type6 += 1;
                            break;
                        case LENSudokuTypeSeven:
                            today_finish_type7 += 1;
                            break;
                        default:
                            break;
                    }
                }
                // 本月finish
                switch (type) {
                    case LENSudokuTypeOne:
                        month_finish_type1 += 1;
                        break;
                    case LENSudokuTypeTwo:
                        month_finish_type2 += 1;
                        break;
                    case LENSudokuTypeThree:
                        month_finish_type3 += 1;
                        break;
                    case LENSudokuTypeFour:
                        month_finish_type4 += 1;
                        break;
                    case LENSudokuTypeFive:
                        month_finish_type5 += 1;
                        break;
                    case LENSudokuTypeSix:
                        month_finish_type6 += 1;
                        break;
                    case LENSudokuTypeSeven:
                        month_finish_type7 += 1;
                        break;
                    default:
                        break;
                }
            }
            NSString *end_hms = endTimeDates[1];
            NSString *end_d = endTimeDates[3];
            sudoku.endTimeString_hms = end_hms;
            sudoku.endTimeString_d = end_d;
            NSString *end_ymd = endTimeDates[0];
            if ([end_ymd isEqualToString:last_ymd]) {
                // 在上一个数组里面
            }
            else {
                // 进入下一个数组
                if ([last_ymd isEqualToString:@""]) {
                    
                } else {
                    [self.recordsMonth addObject:temp];
                    temp = [NSMutableArray array];
//                    [temp removeAllObjects];
                }
                last_ymd = end_ymd;
                [self.months addObject:end_d];
            }
            [temp addObject:sudoku];
        }
        if (i == records.count-1) {
            if (temp.count > 0) {
                [self.recordsMonth addObject:temp];
            }
        }
    }
    // 获取当前的sudoku
    LENSudokuModel *currentModel = [LENHandle currentSudokuRead];
    if (currentModel) {
        NSString *typeString = [LENHandle typeStringWithType:currentModel.type];
        NSString *string = [NSString stringWithFormat:@"进行中游戏 %@", typeString];
        self.todayCurrentLabel.text = string;
//        if (self.months.count > 0) {
//            NSString *month = self.months[0];
//            if ([month isEqualToString:today_d]) {
//                NSMutableArray *array = self.recordsMonth[0];
//                [array insertObject:currentModel atIndex:0];
//                self.recordsMonth[0] = array;
//            } else {
//                [self.months insertObject:today_d atIndex:0];
//                NSMutableArray *array = [NSMutableArray array];
//                [array addObject:currentModel];
//                [self.recordsMonth insertObject:array atIndex:0];
//            }
//        } else {
//            [self.months addObject:today_d];
//            NSMutableArray *array = [NSMutableArray array];
//            [array addObject:currentModel];
//            [self.recordsMonth addObject:array];
//        }
    } else {
        self.todayCurrentLabel.text = @"无进行中游戏";
    }
    // 今日records
    if (self.months.count > 0) {
        NSString *month = self.months[0];
        if ([month isEqualToString:today_d]) {
            self.recordsToday = self.recordsMonth[0];
            //
            for (LENSudokuModel *sudoku in self.recordsToday) {
                NSInteger status = sudoku.status;
                if (status == 1) {
                    today_done += 1;
                } else if (status == 2) {
                    today_finish += 1;
                }
            }
        }
    }
    self.todayEnd.text = [NSString stringWithFormat:@"%i个", today_done];
    self.todayFinish.text = [NSString stringWithFormat:@"%i个", today_finish];
    self.monthEnd.text = [NSString stringWithFormat:@"%i个", month_done];
    self.monthFinish.text = [NSString stringWithFormat:@"%i个", month_finish];
    
    [self.typesDoneToday addObject:@(today_done_type1)];
    [self.typesDoneToday addObject:@(today_done_type2)];
    [self.typesDoneToday addObject:@(today_done_type3)];
    [self.typesDoneToday addObject:@(today_done_type4)];
    [self.typesDoneToday addObject:@(today_done_type5)];
    [self.typesDoneToday addObject:@(today_done_type6)];
    [self.typesDoneToday addObject:@(today_done_type7)];
    [self.typesFinishToday addObject:@(today_finish_type1)];
    [self.typesFinishToday addObject:@(today_finish_type2)];
    [self.typesFinishToday addObject:@(today_finish_type3)];
    [self.typesFinishToday addObject:@(today_finish_type4)];
    [self.typesFinishToday addObject:@(today_finish_type5)];
    [self.typesFinishToday addObject:@(today_finish_type6)];
    [self.typesFinishToday addObject:@(today_finish_type7)];
    [self.typesDoneMonth addObject:@(month_done_type1)];
    [self.typesDoneMonth addObject:@(month_done_type2)];
    [self.typesDoneMonth addObject:@(month_done_type3)];
    [self.typesDoneMonth addObject:@(month_done_type4)];
    [self.typesDoneMonth addObject:@(month_done_type5)];
    [self.typesDoneMonth addObject:@(month_done_type6)];
    [self.typesDoneMonth addObject:@(month_done_type7)];
    [self.typesFinishMonth addObject:@(month_finish_type1)];
    [self.typesFinishMonth addObject:@(month_finish_type2)];
    [self.typesFinishMonth addObject:@(month_finish_type3)];
    [self.typesFinishMonth addObject:@(month_finish_type4)];
    [self.typesFinishMonth addObject:@(month_finish_type5)];
    [self.typesFinishMonth addObject:@(month_finish_type6)];
    [self.typesFinishMonth addObject:@(month_finish_type7)];
    
    
}

# pragma mark -- 详细数据
- (IBAction)toDetailToday:(id)sender {
    if (self.recordsToday.count == 0) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"今日暂无数据" preferredStyle:(UIAlertControllerStyleAlert)];
        [self presentViewController:alert animated:YES completion:^{
            [alert dismissViewControllerAnimated:YES completion:nil];
        }];
    } else {
        LENRecordsDetailViewController *vc = [LENRecordsDetailViewController new];
        vc.isToday = YES;
        NSMutableArray *records = [NSMutableArray array];
        [records addObject:self.recordsToday];
        NSMutableArray *months = [NSMutableArray array];
        [months addObject:self.months[0]];
        vc.records = records;
        vc.months = months;
        vc.typesDone = self.typesDoneToday;
        vc.typesFinish = self.typesFinishToday;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (IBAction)toDetailMonth:(id)sender {
    if (self.recordsMonth.count == 0) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"本月暂无数据" preferredStyle:(UIAlertControllerStyleAlert)];
        [self presentViewController:alert animated:YES completion:^{
            [alert dismissViewControllerAnimated:YES completion:nil];
        }];
    } else {
        LENRecordsDetailViewController *vc = [LENRecordsDetailViewController new];
        vc.isToday = NO;
        vc.records = self.recordsMonth;
        vc.months = self.months;
        vc.typesDone = self.typesDoneMonth;
        vc.typesFinish = self.typesFinishMonth;
        [self.navigationController pushViewController:vc animated:YES];
    }
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
