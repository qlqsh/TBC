//
//  WinningRuleViewController.m
//  TwoColorBall
//
//  Created by 刘明 on 2016/12/28.
//  Copyright © 2016年 刘明. All rights reserved.
//

#import "WinningRuleViewController.h"
#import "WinningBallView.h"
#import "BallView.h"
#import "RuleCell1.h"
#import "RuleCell2.h"
#import "RuleCell3.h"

@interface WinningRuleViewController () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic) CGFloat heightOfCell;
@end

@implementation WinningRuleViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    _heightOfCell = [RuleCell1 heightOfCellWithWidth:self.view.frame.size.width];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initializeUserInterface];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 初始化界面
- (void)initializeUserInterface {
    self.title = @"开奖规则";
    // 视图加载
    [self.view addSubview:self.tableView];
}

#pragma mark - Getters
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds
                                                  style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        
        _tableView.scrollEnabled = NO;
        _tableView.allowsSelection = NO;
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    }
    return _tableView;
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 6;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RuleCell1 *cell1 = [[RuleCell1 alloc] initWithStyle:UITableViewCellStyleDefault
                                        reuseIdentifier:@"ruleCell1"];
    RuleCell2 *cell2 = [[RuleCell2 alloc] initWithStyle:UITableViewCellStyleDefault
                                        reuseIdentifier:@"ruleCell2"];
    RuleCell3 *cell3 = [[RuleCell3 alloc] initWithStyle:UITableViewCellStyleDefault
                                        reuseIdentifier:@"ruleCell3"];
    
    switch (indexPath.row) {
        case 0: {
            cell1.awardLabel.text = @"一等奖";
            cell1.moneyLabel.text = @"浮动";
            cell1.states = @[ @2, @2, @2, @2, @2, @2, @3 ];
            return cell1;
        }
        case 1: {
            cell1.awardLabel.text = @"二等奖";
            cell1.moneyLabel.text = @"浮动";
            cell1.states = @[ @2, @2, @2, @2, @2, @2, @0 ];
            return cell1;
        }
        case 2: {
            cell1.awardLabel.text = @"三等奖";
            cell1.moneyLabel.text = @"3000元";
            cell1.states = @[ @2, @2, @2, @2, @2, @0, @3 ];
            return cell1;
        }
        case 3: {
            cell2.awardLabel.text = @"四等奖";
            cell2.moneyLabel.text = @"200元";
            cell2.states1 = @[ @2, @2, @2, @2, @2, @0, @0 ];
            cell2.states2 = @[ @2, @2, @2, @2, @0, @0, @3 ];
            return cell2;
        }
        case 4: {
            cell2.awardLabel.text = @"五等奖";
            cell2.moneyLabel.text = @"10元";
            cell2.states1 = @[ @2, @2, @2, @2, @0, @0, @0 ];
            cell2.states2 = @[ @2, @2, @2, @0, @0, @0, @3 ];
            return cell2;
        }
        case 5: {
            cell3.awardLabel.text = @"六等奖";
            cell3.moneyLabel.text = @"5元";
            cell3.states1 = @[ @2, @2, @0, @0, @0, @0, @3 ];
            cell3.states2 = @[ @2, @0, @0, @0, @0, @0, @3 ];
            cell3.states3 = @[ @0, @0, @0, @0, @0, @0, @3 ];
            return cell3;
        }
        default:
            return cell1;
    }
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 3:
        case 4:
            return _heightOfCell*2;
            break;
        case 5:
            return _heightOfCell*3;
            break;
        case 0:
        case 1:
        case 2:
        default:
            return _heightOfCell;
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    CGFloat width = self.view.frame.size.width;
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, width, 40.0f)];
    headerView.backgroundColor = kRedColor;
    
    UILabel *awardLevel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, width*0.2, 40.0f)];
    awardLevel.text = @"奖等";
    awardLevel.textColor = [UIColor whiteColor];
    awardLevel.textAlignment = NSTextAlignmentCenter;
    awardLevel.font = [UIFont boldSystemFontOfSize:20];
    UILabel *awardMoney = [[UILabel alloc] initWithFrame:CGRectMake(width*0.2, 0.0f, width*0.3, 40.0f)];
    awardMoney.text = @"奖金";
    awardMoney.textColor = [UIColor whiteColor];
    awardMoney.textAlignment = NSTextAlignmentCenter;
    awardMoney.font = [UIFont boldSystemFontOfSize:20];
    UILabel *winningConditions = [[UILabel alloc] initWithFrame:CGRectMake(width*0.5, 0.0f, width*0.5, 40.0f)];
    winningConditions.text = @"中奖条件";
    winningConditions.textColor = [UIColor whiteColor];
    winningConditions.textAlignment = NSTextAlignmentCenter;
    winningConditions.font = [UIFont boldSystemFontOfSize:20];
    
    [headerView addSubview:awardLevel];
    [headerView addSubview:awardMoney];
    [headerView addSubview:winningConditions];
    
    return headerView;
}

@end
