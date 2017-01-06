//
//  HistorySameViewController.m
//  TwoColorBall
//
//  Created by 刘明 on 2016/12/27.
//  Copyright © 2016年 刘明. All rights reserved.
//

#import "HistorySameViewController.h"
#import "StatisticsManager.h"
#import "SimpleWinning.h"
#import "NumberCombinations.h"
#import "WinningBallView.h"

#import <MBProgressHUD/MBProgressHUD.h>

@interface HistorySameViewController () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation HistorySameViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // 预设一下行高
    _heightOfCell = [WinningBallView heightOfCellWithWidth:self.view.bounds.size.width*0.75];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initializeUserInterface];
    [self updateTableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 初始化界面
- (void)initializeUserInterface {
    self.title = @"历史同期";
    // 视图加载
    [self.view addSubview:self.tableView];
}

#pragma mark - 表格视图刷新
- (void)updateTableView {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        StatisticsManager *statisticsManager = [StatisticsManager sharedData];
        _historySameWinningList = [[[statisticsManager historySame] reverseObjectEnumerator] allObjects];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        });
    });
}

#pragma mark - Getters
- (UITableView *)tableView {
    if (!_tableView) {
        CGRect tableViewRect = CGRectMake(0, 0,
                                          CGRectGetWidth(self.view.bounds),
                                          CGRectGetHeight(self.view.bounds));
        _tableView = [[UITableView alloc] initWithFrame:tableViewRect];

        _tableView.dataSource = self;
        _tableView.delegate = self;
        
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
    return _historySameWinningList.count;
}

#define kDefaultSpace 5.0f
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"winningBaseCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:cellID];
        CGFloat width = self.view.bounds.size.width;
        UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(kDefaultSpace,
                                                                       kDefaultSpace,
                                                                       width*0.2,
                                                                       _heightOfCell)];
        textLabel.tag = 101;
        textLabel.font = [UIFont systemFontOfSize:14.0f];
        textLabel.textColor = [UIColor grayColor];
        [cell.contentView addSubview:textLabel];
        
        // 解决重用导致的重影问题
        WinningBallView *winningBaseView = [[WinningBallView alloc] initWithFrame:CGRectMake(width*0.2+kDefaultSpace,
                                                                                             kDefaultSpace,
                                                                                             width*0.75,
                                                                                             _heightOfCell)];
        winningBaseView.tag = 102;
        [cell.contentView addSubview:winningBaseView];
    }
    
    SimpleWinning *winning = (SimpleWinning *) _historySameWinningList[(NSUInteger) indexPath.row];
    
    UILabel *textLabel = [cell.contentView viewWithTag:101];
    textLabel.text = winning.term;
    
    WinningBallView *winningBallView = [cell.contentView viewWithTag:102];
    NSMutableArray *balls = [NSMutableArray arrayWithCapacity:7];
    [balls addObjectsFromArray:winning.reds.numbers];
    [balls addObjectsFromArray:winning.blues.numbers];
    
    [winningBallView setBalls:[balls copy]];
    
    return cell;
}

#pragma mark - UITableViewDelegate
/**
 *  单元高度。
 *
 *  @param tableView 表格视图
 *  @param indexPath 单元索引
 *
 *  @return 高度。
 */
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return _heightOfCell+kDefaultSpace*2;
}

@end
