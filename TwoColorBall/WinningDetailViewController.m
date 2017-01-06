//
//  WinningDetailViewController.m
//  TwoColorBall
//
//  Created by 刘明 on 2016/12/28.
//  Copyright © 2016年 刘明. All rights reserved.
//

#import "WinningDetailViewController.h"
#import "WinningBallView.h"
#import "Winning.h"
#import "WinningCell.h"
#import "MoneyCell.h"
#import "PrizeCell.h"
#import "WinningRuleViewController.h"

@interface WinningDetailViewController () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic) CGFloat heightOfCell1;
@end

@implementation WinningDetailViewController

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
    self.title = @"本期开奖";
    _heightOfCell1 = [WinningCell heightOfCellWithWidth:self.view.frame.size.width];
    
    UIBarButtonItem *ruleButton = [[UIBarButtonItem alloc] initWithTitle:@"获奖规则"
                                                                   style:UIBarButtonItemStylePlain
                                                                  target:self
                                                                  action:@selector(pushRuleViewController)];
    self.navigationItem.rightBarButtonItem = ruleButton;
    
    // 视图加载
    [self.view addSubview:self.tableView];
}

#pragma mark - 载入规则视图
- (void)pushRuleViewController {
    WinningRuleViewController *winningRuleViewController = [[WinningRuleViewController alloc] init];
    [self.navigationController pushViewController:winningRuleViewController animated:YES];
}

#pragma mark - Getters
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds
                                                  style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        
        _tableView.scrollEnabled = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.allowsSelection = NO;
    }
    
    return _tableView;
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return 1;
        case 2:
            return 1;
        case 4:
            return 4;
        default:
            return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0: {
            WinningCell *cell = [[WinningCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                   reuseIdentifier:@"oneSection"];
            cell.termLabel.text = [NSString stringWithFormat:@"第%@期", _winning.term];
            cell.dateLabel.text = [NSString stringWithFormat:@"%@（%@）", _winning.date, _winning.week];
            NSMutableArray *balls = [NSMutableArray arrayWithArray:_winning.reds];
            [balls addObjectsFromArray:_winning.blues];
            cell.winningBallView.balls = [balls copy];
            return cell;
        }
        case 2: {
            MoneyCell *cell = [[MoneyCell alloc] initWithStyle:UITableViewCellStyleDefault
                                               reuseIdentifier:@"twoSection"];
            cell.poolMoneyLabel.text = [NSString stringWithFormat:@"%@元", _winning.moneyState[@"pool"]];
            cell.salesMoneyLabel.text = [NSString stringWithFormat:@"%@元", _winning.moneyState[@"sales"]];
            return cell;
        }
        case 4: {
            PrizeCell *cell = [[PrizeCell alloc] initWithStyle:UITableViewCellStyleDefault
                                               reuseIdentifier:@"threeSection"];
            switch (indexPath.row) {
                case 0:
                    cell.awardsLabel.text = @"奖项";
                    cell.winningAmountLabel.text = @"中奖人数";
                    cell.winningMoneyLabel.text = @"中奖金额";
                    break;
                case 1:
                    cell.awardsLabel.text = @"一等奖";
                    cell.winningAmountLabel.text =_winning.prizeState[@"firstAmount"];
                    cell.winningMoneyLabel.text = [NSString stringWithFormat:@"%@元", _winning.prizeState[@"firstMoney"]];
                    cell.backgroundColor = [UIColor groupTableViewBackgroundColor];
                    break;
                case 2:
                    cell.awardsLabel.text = @"二等奖";
                    cell.winningAmountLabel.text =_winning.prizeState[@"secondAmount"];
                    cell.winningMoneyLabel.text = [NSString stringWithFormat:@"%@元", _winning.prizeState[@"secondMoney"]];
                    break;
                case 3:
                    cell.awardsLabel.text = @"三等奖";
                    cell.winningAmountLabel.text =_winning.prizeState[@"thirdAmount"];
                    cell.winningMoneyLabel.text = [NSString stringWithFormat:@"%@元", _winning.prizeState[@"thirdMoney"]];
                    cell.backgroundColor = [UIColor groupTableViewBackgroundColor];
                    break;
                default:
                    break;
            }
            return cell;
        }
        default: {
            UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                           reuseIdentifier:@"line"];
            return cell;
        }
    }
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:
            return _heightOfCell1;
        case 2:
            return [MoneyCell heightOfCell];
        case 4:
            return [PrizeCell heightOfCell];
        default:
            return 10.0f;
    }
}

@end
