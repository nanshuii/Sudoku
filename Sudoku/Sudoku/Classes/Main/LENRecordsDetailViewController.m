//
//  LENRecordsDetailViewController.m
//  Sudoku
//
//  Created by 戴十三 on 2020/1/22.
//  Copyright © 2020 ledon. All rights reserved.
//

#import "LENRecordsDetailViewController.h"
#import "LENRecordsDetailTableViewCell.h"

@interface LENRecordsDetailViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *doneMonths;

@property (nonatomic, strong) NSMutableArray *doneRecords;

@property (nonatomic, strong) NSMutableArray *finishMonths;

@property (nonatomic, strong) NSMutableArray *finishRecords;

@property (nonatomic, assign) BOOL isFinish;

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation LENRecordsDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.isFinish = YES;
    [self configureMonthsAndRecords];
    [self configureUI];
}

- (void)configureUI{
    NSString *string = @"详细数据";
    if (self.isToday) {
        string = [NSString stringWithFormat:@"今日%@", string];
    } else {
        string = [NSString stringWithFormat:@"本月%@", string];
    }
    self.title = string;
    [self configureFinishUI];
    [self.contentView addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView.mas_top);
        make.bottom.mas_equalTo(self.contentView.mas_bottom);
        make.left.mas_equalTo(self.contentView.mas_left);
        make.right.mas_equalTo(self.contentView.mas_right);
    }];
    [self.tableView reloadData];
}

- (void)configureFinishUI{
    self.statusLabel.text = @"已完成";
    // height 17
    int all = 0;
    for (int i = 0; i < self.typesFinish.count; i++) {
        int number = [self.typesFinish[i] intValue];
        all += number;
        
        if (number == 0) {
            switch (i) {
                case 0:
                    self.typeLabel1.hidden = YES;
                    self.typeLabel1Top.constant = -17;
                    break;
                case 1:
                    self.typeLabel2.hidden = YES;
                    self.typeLabel2Top.constant = -17;
                    break;
                case 2:
                    self.typeLabel3.hidden = YES;
                    self.typeLabel3Top.constant = -17;
                    break;
                case 3:
                    self.typeLabel4.hidden = YES;
                    self.typeLabel4Top.constant = -17;
                    break;
                case 4:
                    self.typeLabel5.hidden = YES;
                    self.typeLabel5Top.constant = -17;
                    break;
                case 5:
                    self.typeLabel6.hidden = YES;
                    self.typeLabel6Top.constant = -17;
                    break;
                case 6:
                    self.typeLabel7.hidden = YES;
                    self.typeLabel7Top.constant = -17;
                    break;
                default:
                    break;
            }
        } else {
            switch (i) {
                case 0:
                    self.typeLabel1.hidden = NO;
                    self.typeLabel1.text = [NSString stringWithFormat:@"难度一  %i", number];
                    self.typeLabel1Top.constant = 10;
                    break;
                case 1:
                    self.typeLabel2.hidden = NO;
                    self.typeLabel2.text = [NSString stringWithFormat:@"难度二  %i", number];
                    self.typeLabel2Top.constant = 5;
                    break;
                case 2:
                    self.typeLabel3.hidden = NO;
                    self.typeLabel3.text = [NSString stringWithFormat:@"难度三  %i", number];
                    self.typeLabel3Top.constant = 5;
                    break;
                case 3:
                    self.typeLabel4.hidden = NO;
                    self.typeLabel4.text = [NSString stringWithFormat:@"难度四  %i", number];
                    self.typeLabel4Top.constant = 5;
                    break;
                case 4:
                    self.typeLabel5.hidden = NO;
                    self.typeLabel5.text = [NSString stringWithFormat:@"难度五  %i", number];
                    self.typeLabel5Top.constant = 5;
                    break;
                case 5:
                    self.typeLabel6.hidden = NO;
                    self.typeLabel6.text = [NSString stringWithFormat:@"难度六  %i", number];
                    self.typeLabel6Top.constant = 5;
                    break;
                case 6:
                    self.typeLabel7.hidden = NO;
                    self.typeLabel7.text = [NSString stringWithFormat:@"难度七  %i", number];
                    self.typeLabel7Top.constant = 5;
                    break;
                default:
                    break;
            }
        }
    }
    self.statusNumberLabel.text = [NSString stringWithFormat:@"%i个", all];
}

- (void)configureDoneUI{
    self.statusLabel.text = @"已废弃";
    int all = 0;
    for (int i = 0; i < self.typesDone.count; i++) {
        int number = [self.typesDone[i] intValue];
        all += number;
        
        if (number == 0) {
            switch (i) {
                case 0:
                    self.typeLabel1.hidden = YES;
                    self.typeLabel1Top.constant = -17;
                    break;
                case 1:
                    self.typeLabel2.hidden = YES;
                    self.typeLabel2Top.constant = -17;
                    break;
                case 2:
                    self.typeLabel3.hidden = YES;
                    self.typeLabel3Top.constant = -17;
                    break;
                case 3:
                    self.typeLabel4.hidden = YES;
                    self.typeLabel4Top.constant = -17;
                    break;
                case 4:
                    self.typeLabel5.hidden = YES;
                    self.typeLabel5Top.constant = -17;
                    break;
                case 5:
                    self.typeLabel6.hidden = YES;
                    self.typeLabel6Top.constant = -17;
                    break;
                case 6:
                    self.typeLabel7.hidden = YES;
                    self.typeLabel7Top.constant = -17;
                    break;
                default:
                    break;
            }
        } else {
            switch (i) {
                case 0:
                    self.typeLabel1.hidden = NO;
                    self.typeLabel1.text = [NSString stringWithFormat:@"难度一  %i", number];
                    self.typeLabel1Top.constant = 10;
                    break;
                case 1:
                    self.typeLabel2.hidden = NO;
                    self.typeLabel2.text = [NSString stringWithFormat:@"难度二  %i", number];
                    self.typeLabel2Top.constant = 5;
                    break;
                case 2:
                    self.typeLabel3.hidden = NO;
                    self.typeLabel3.text = [NSString stringWithFormat:@"难度三  %i", number];
                    self.typeLabel3Top.constant = 5;
                    break;
                case 3:
                    self.typeLabel4.hidden = NO;
                    self.typeLabel4.text = [NSString stringWithFormat:@"难度四  %i", number];
                    self.typeLabel4Top.constant = 5;
                    break;
                case 4:
                    self.typeLabel5.hidden = NO;
                    self.typeLabel5.text = [NSString stringWithFormat:@"难度五  %i", number];
                    self.typeLabel5Top.constant = 5;
                    break;
                case 5:
                    self.typeLabel6.hidden = NO;
                    self.typeLabel6.text = [NSString stringWithFormat:@"难度六  %i", number];
                    self.typeLabel6Top.constant = 5;
                    break;
                case 6:
                    self.typeLabel7.hidden = NO;
                    self.typeLabel7.text = [NSString stringWithFormat:@"难度七  %i", number];
                    self.typeLabel7Top.constant = 5;
                    break;
                default:
                    break;
            }
        }
    }
    self.statusNumberLabel.text = [NSString stringWithFormat:@"%i个", all];
}

# pragma mark -- configure months records
- (void)configureMonthsAndRecords{
    self.finishMonths = [NSMutableArray arrayWithArray:self.months];
    self.doneMonths = [NSMutableArray arrayWithArray:self.months];
    self.finishRecords = [NSMutableArray array];
    self.doneRecords = [NSMutableArray array];
    for (int i = 0; i < self.records.count; i++) {
        NSString *d = self.months[i];
        NSMutableArray *records = self.records[i];
        // 进行分离
        NSMutableArray *finishTempArray = [NSMutableArray array];
        NSMutableArray *doneTempArray = [NSMutableArray array];
        for (int j = 0; j < records.count; j++) {
            LENSudokuModel *sudoku = records[j];
            NSInteger status = sudoku.status;
            if (status == 1) {
                [doneTempArray addObject:sudoku];
            } else if (status == 2) {
                [finishTempArray addObject:sudoku];
            }
        }
        if (finishTempArray.count == 0) {
            [self.finishMonths removeObject:d];
        } else {
            [self.finishRecords addObject:finishTempArray];
        }
        if (doneTempArray.count == 0) {
            [self.doneMonths removeObject:d];
        } else {
            [self.doneRecords addObject:doneTempArray];
        }
    }
}

# pragma mark -- segment change
- (IBAction)segmentChange:(UISegmentedControl *)sender {
    NSInteger value = sender.selectedSegmentIndex;
    SSLog(@"value = %li", value);
    if (value == 0) {
        // 已完成
        self.isFinish = YES;
        [self configureFinishUI];
    } else {
        // 已放弃
        self.isFinish = NO;
        [self configureDoneUI];
    }
    [self.tableView reloadData];
}

# pragma mark -- configureTableView
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.contentView.bounds style:(UITableViewStylePlain)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerNib:[LENRecordsDetailTableViewCell nib] forCellReuseIdentifier:[LENRecordsDetailTableViewCell myClassNameAsCellIdentifier]];
    }
    return _tableView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (self.isFinish) {
        return self.finishRecords.count;
    } else {
        return self.doneRecords.count;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.isFinish) {
        NSMutableArray *array = self.finishRecords[section];
        return array.count;
    } else {
        NSMutableArray *array = self.doneRecords[section];
        return array.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LENRecordsDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[LENRecordsDetailTableViewCell myClassNameAsCellIdentifier]];
    if (self.isFinish) {
        NSMutableArray *array = self.finishRecords[indexPath.section];
        [cell configureForCellModel:array[indexPath.row]];
    } else {
        NSMutableArray *array = self.doneRecords[indexPath.section];
        [cell configureForCellModel:array[indexPath.row]];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kFullScreenWidth, 40)];
    view.backgroundColor = UIColorFromHex(0xEEEEEE);
    
    UILabel *label = [UILabel new];
    if (self.isFinish) {
        label.text = [NSString stringWithFormat:@"%@日", self.finishMonths[section]];
    } else {
        label.text = [NSString stringWithFormat:@"%@日", self.doneMonths[section]];
    }
    label.font = FONTBOLD(14);
    [view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(view.mas_left).offset(20);
        make.centerY.mas_equalTo(view.mas_centerY);
    }];
    
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
