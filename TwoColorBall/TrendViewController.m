//
//  TrendViewController.m
//  TwoColorBall
//
//  Created by 刘明 on 2016/12/29.
//  Copyright © 2016年 刘明. All rights reserved.
//

#import "TrendViewController.h"
#import "TrendCell.h"
#import "Winning.h"
#import "BallView.h"
#import "TrendBaseView.h"
#import "TrendTitleView.h"
#import "TrendView.h"
#import "TrendData.h"
#import "TrendStatisticsView.h"
#import "TrendBallButtonView.h"
#import <MBProgressHUD/MBProgressHUD.h>

static NSString *const kTrendCell = @"trendCell";

@interface TrendViewController () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSDictionary *settingDict;
@property (nonatomic) CGFloat heightOfCell;

@property (nonatomic) NSUInteger termAmount;
@property (nonatomic) BOOL hasMissing;
@property (nonatomic) BOOL hasStatistics;
@property (nonatomic) BOOL hasSelectedBall;
@end

@implementation TrendViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // 进度指示器
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        TrendData *trendData = [TrendData sharedData];
        _winningList = [trendData termAndBallsWithCustomNumber:100];
        _statisticsArray = [trendData statisticsArrayWithNumber:0];
        _heightOfCell = [TrendCell heightOfCell];
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [self.tableView reloadData];
        });
    });
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initializeUserInterface];
    
    // 设置视图
    UIBarButtonItem *settingButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Setting"]
                                                                          style:UIBarButtonItemStylePlain
                                                                         target:self
                                                                         action:@selector(settingAlertView)];
    settingButtonItem.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = settingButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return 1;
        case 1:
            return self.termAmount;
        case 2:
            if (self.hasStatistics) {
                return 4;
            }
            return 0;
        case 3:
            if (self.hasSelectedBall) {
                return 1;
            }
            return 0;
        default:
            return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TrendCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell == nil) {
        cell = [[TrendCell alloc] initWithStyle:UITableViewCellStyleDefault
                                reuseIdentifier:kTrendCell];
    }
    switch (indexPath.section) {
        case 0: {
            TrendTitleView *trendTitleView = [[TrendTitleView alloc] init];
            [cell.cellScrollView addSubview:trendTitleView];
            break;
        }
        case 1:{
            // 最多100行数据
            NSArray *subArray = [_winningList subarrayWithRange:NSMakeRange(_winningList.count-self.termAmount,
                                                                            self.termAmount)];
            NSArray *termAndBalls = subArray[(NSUInteger)indexPath.row];
            TrendView *trendView = [[TrendView alloc] init];
            trendView.termLabel.text = [termAndBalls firstObject];
            trendView.trendBaseView.hasMissing = self.hasMissing;
            trendView.trendBaseView.trendBalls = [termAndBalls lastObject];
            if (indexPath.row%2 == 1) {
                trendView.state = 1;
            } else {
                trendView.state = 0;
            }
            [cell.cellScrollView addSubview:trendView];
            break;
        }
        case 2: {
            if (self.hasStatistics) {
                TrendStatisticsView *trendStatisticsView = [[TrendStatisticsView alloc] init];
                switch (indexPath.row) {
                    case 0:
                        trendStatisticsView.titleLabel.text = @"出现次数";
                        trendStatisticsView.state = 0;
                        break;
                    case 1:
                        trendStatisticsView.titleLabel.text = @"最大连出";
                        trendStatisticsView.state = 1;
                        break;
                    case 2:
                        trendStatisticsView.titleLabel.text = @"最大遗漏";
                        trendStatisticsView.state = 2;
                        break;
                    case 3:
                        trendStatisticsView.titleLabel.text = @"平均遗漏";
                        trendStatisticsView.state = 3;
                        break;
                    default:
                        break;
                }
                trendStatisticsView.statisticses = _statisticsArray[indexPath.row];
                [cell.cellScrollView addSubview:trendStatisticsView];
            }
            break;
        }
        case 3: {
            if (self.hasSelectedBall) {
                TrendBallButtonView *trendBallButtonView = [[TrendBallButtonView alloc] init];
                [cell.cellScrollView addSubview:trendBallButtonView];
            }
            break;
        }
        default:
            break;
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return _heightOfCell;
}

#pragma mark - 初始化界面
- (void)initializeUserInterface {
    self.title = @"走势图";
    // 视图加载
    [self.view addSubview:self.tableView];
}

#pragma mark - 设置对话框
/**
 *  弹出对话框，设置走势图属性(显示期数/遗漏/统计/选号)。
 */
- (void)settingAlertView {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"走势图设置"
                                                                   message:@"\n\n\n\n\n\n\n\n\n\n"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIColor *segmentedColor = kRedColor;
    UISegmentedControl *termAmount = [[UISegmentedControl alloc] initWithItems:@[
                                                                                 @"近30期",
                                                                                 @"近50期",
                                                                                 @"近100期",
                                                                                 ]];
    termAmount.frame = CGRectMake(10.0f, 60.0f, 250.0f, 30.0f);
    termAmount.tintColor = segmentedColor;
    UISegmentedControl *missing = [[UISegmentedControl alloc] initWithItems:@[@"隐藏遗漏", @"显示遗漏"]];
    missing.frame = CGRectMake(10.0f, 100.0f, 250.0f, 30.0f);
    missing.tintColor = segmentedColor;
    UISegmentedControl *statistics = [[UISegmentedControl alloc] initWithItems:@[@"隐藏统计", @"显示统计"]];
    statistics.frame = CGRectMake(10.0f, 140.0f, 250.0f, 30.0f);
    statistics.tintColor = segmentedColor;
    UISegmentedControl *selectedBall = [[UISegmentedControl alloc] initWithItems:@[@"隐藏选号", @"显示选号"]];
    selectedBall.frame = CGRectMake(10.0f, 180.0f, 250.0f, 30.0f);
    selectedBall.tintColor = segmentedColor;
    
    termAmount.selectedSegmentIndex = [self.settingDict[@"termAmount"] integerValue];
    missing.selectedSegmentIndex = [self.settingDict[@"missing"] integerValue];
    statistics.selectedSegmentIndex = [self.settingDict[@"statistics"] integerValue];
    selectedBall.selectedSegmentIndex = [self.settingDict[@"selectedBall"] integerValue];
    
    [alert.view addSubview:termAmount];
    [alert.view addSubview:missing];
    [alert.view addSubview:statistics];
    [alert.view addSubview:selectedBall];
    
    UIAlertAction *defaultAction =
        [UIAlertAction actionWithTitle:@"确认"
                                 style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction *action) {
                                   // 保存走势图属性设置
                                   NSMutableDictionary *saveTrendSettingDict = [NSMutableDictionary dictionary];
                                   saveTrendSettingDict[@"termAmount"] = @(termAmount.selectedSegmentIndex);
                                   saveTrendSettingDict[@"missing"] = @(missing.selectedSegmentIndex);
                                   saveTrendSettingDict[@"statistics"] = @(statistics.selectedSegmentIndex);
                                   saveTrendSettingDict[@"selectedBall"] = @(selectedBall.selectedSegmentIndex);
                                   [self setSettingDict:[saveTrendSettingDict copy]];
                                   
                                   // 延时机制。消除警告。
                                   dispatch_after((dispatch_time_t) 0.2, dispatch_get_main_queue(), ^{
                                       [self.tableView reloadData];
                                   });
                               }];
    [defaultAction setValue:segmentedColor forKey:[NSString stringWithFormat:@"titleTextColor"]];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消"
                                                           style:UIAlertActionStyleCancel
                                                         handler:^(UIAlertAction *action) {
                                                         }];
    [cancelAction setValue:segmentedColor forKey:[NSString stringWithFormat:@"titleTextColor"]];
    
    [alert addAction:defaultAction];
    [alert addAction:cancelAction];
    
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - 获取、设置
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.frame
                                                  style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.allowsSelection = NO;
    }
    
    return _tableView;
}

- (void)setSettingDict:(NSDictionary *)settingDict {
    [[NSUserDefaults standardUserDefaults] setObject:settingDict forKey:@"trend_setting"];
}

- (NSDictionary *)settingDict {
    NSDictionary *settingDict = [[NSUserDefaults standardUserDefaults] objectForKey:@"trend_setting"];
    if (settingDict == nil) {
        settingDict = @{ @"termAmount":@(0), @"missing":@(0), @"statistics":@(0), @"selectedBall":@(0) };
    }
    return settingDict;
}

- (NSUInteger)termAmount {
    NSUInteger amount = [self.settingDict[@"termAmount"] integerValue];
    switch (amount) {
        case 0:
        default:
            return 30;
        case 1:
            return 50;
        case 2:
            return 100;
    }
}

- (BOOL)hasMissing {
    NSUInteger missing = [self.settingDict[@"missing"] integerValue];
    if (missing == 0) {
        return NO;
    }
    return YES;
}

- (BOOL)hasStatistics {
    NSUInteger statistics = [self.settingDict[@"statistics"] integerValue];
    if (statistics == 0) {
        return NO;
    }
    return YES;
}

- (BOOL)hasSelectedBall {
    NSUInteger selectedBall = [self.settingDict[@"selectedBall"] integerValue];
    if (selectedBall == 0) {
        return NO;
    }
    return YES;
}
@end
