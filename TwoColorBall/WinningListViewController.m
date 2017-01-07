//
//  WinningListViewController.m
//  TwoColorBall
//
//  Created by 刘明 on 2016/12/24.
//  Copyright © 2016年 刘明. All rights reserved.
//

#import "WinningListViewController.h"
#import "WinningCell.h"
#import "Winning.h"
#import "DataManager.h"
#import "WinningBallView.h"
#import "NumberCombinations.h"
#import "WinningDetailViewController.h"

static NSString *const kWinningCell = @"winningCell";

@interface WinningListViewController () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic) CGFloat heightOfCell;
@end

@implementation WinningListViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    DataManager *dataManager = [DataManager sharedManager];
    _winningList = [dataManager readAllWinningListInFile];
    
    _heightOfCell = [WinningCell heightOfCellWithWidth:self.view.bounds.size.width];
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
    self.title = @"开奖历史";
    // 视图加载
    [self.view addSubview:self.tableView];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WinningCell *cell = [tableView dequeueReusableCellWithIdentifier:kWinningCell
                                                        forIndexPath:indexPath];
    Winning *winning = (Winning *)_winningList[(NSUInteger)indexPath.row];
    cell.termLabel.text = [NSString stringWithFormat:@"第%@期", winning.term];
    cell.dateLabel.text = [NSString stringWithFormat:@"%@（%@）", winning.date, winning.week];
    NSMutableArray *balls = [NSMutableArray arrayWithArray:winning.reds];
    [balls addObjectsFromArray:winning.blues];
    cell.winningBallView.balls = [balls copy];
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return _heightOfCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {    
    [self performSegueWithIdentifier:@"WinningDetail" sender:nil];
}

#pragma mark - Getters
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds
                                                  style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        
        // 注册
        [_tableView registerClass:[WinningCell class] forCellReuseIdentifier:kWinningCell];
    }
    
    return _tableView;
}

#pragma mark - segue 导航
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"WinningDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        WinningDetailViewController *winningDetailViewController = (WinningDetailViewController *)[segue destinationViewController];
        winningDetailViewController.winning = _winningList[indexPath.row];
    }
}

@end
