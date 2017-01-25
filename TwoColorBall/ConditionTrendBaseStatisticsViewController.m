//
// Created by 刘明 on 2017/1/22.
// Copyright (c) 2017 刘明. All rights reserved.
//

#import "ConditionTrendBaseStatisticsViewController.h"

#import "StatisticsManager.h"
#import "NumberCombinations.h"

#import "ResultCell.h"
#import "SimpleWinning.h"

#import <MBProgressHUD/MBProgressHUD.h>

static NSString *const kResultCell = @"resultCell";

@interface ConditionTrendBaseStatisticsViewController () <UITableViewDataSource, UITableViewDelegate>

// 数据
@property (nonatomic, strong) NSArray *statisticsArray;

// 显示视图
@property (nonatomic, strong) UITableView *tableView;

@end


@implementation ConditionTrendBaseStatisticsViewController

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];

    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        StatisticsManager *statisticsManager = [StatisticsManager sharedData];
        _statisticsArray = [statisticsManager conditionTrendBaseStatistics];
        dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
                [MBProgressHUD hideHUDForView:self.view animated:YES];
            
        });
    });
}


- (void)viewDidLoad {
	[super viewDidLoad];
	// Do any additional setup after loading the view.

    self.title = @"基础统计";
	[self.view addSubview:self.tableView];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

#define kCellDefaultHeight 40.0
#define kHeaderDefaultHeight kCellDefaultHeight/2
#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return _statisticsArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	NSDictionary *statisticsDictionary = _statisticsArray[(NSUInteger) section];
	NSArray *statisticsResult = statisticsDictionary[@"statistics"];
	return statisticsResult.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	ResultCell *resultCell = [tableView dequeueReusableCellWithIdentifier:kResultCell
															 forIndexPath:indexPath];
	NSDictionary *statisticsDictionary = _statisticsArray[(NSUInteger) indexPath.section];
	NSArray *statisticsResult = statisticsDictionary[@"statistics"];
	SimpleWinning *simpleWinning = statisticsResult[(NSUInteger) indexPath.row];
	resultCell.titleLabel.text = simpleWinning.term;
	NSMutableArray *balls = [NSMutableArray arrayWithCapacity:7];
	[balls addObjectsFromArray:simpleWinning.reds.numbers];
	[balls addObjectsFromArray:simpleWinning.blues.numbers];
	resultCell.winningBallView.balls = [balls copy];

	return resultCell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return kCellDefaultHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	return (CGFloat) (kHeaderDefaultHeight);
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	UILabel *conditionLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth,
			(CGFloat) (kHeaderDefaultHeight))];
	conditionLabel.backgroundColor = [UIColor groupTableViewBackgroundColor];

	NSDictionary *statisticsDictionary = _statisticsArray[(NSUInteger) section];
	NSDictionary *conditionDictionary = statisticsDictionary[@"conditionRed"];
	NSString *key = [[conditionDictionary allKeys] firstObject];
	NSArray *reds = [key componentsSeparatedByString:@" "];

	NSMutableString *headerString = [NSMutableString stringWithCapacity:4];
	for (int i = 0; i < reds.count; ++i) {
		[headerString appendFormat:@"%@ ", reds[(NSUInteger) i]];
	}
	[headerString appendFormat:@" [%@]", conditionDictionary[key]];

	conditionLabel.text = [headerString copy];
	conditionLabel.textAlignment = NSTextAlignmentCenter;
	conditionLabel.font = [UIFont systemFontOfSize:9.0f];

	return conditionLabel;
}


#pragma mark - 属性设置与获取

- (UITableView *)tableView {
	if (!_tableView) {
		_tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];

		_tableView.dataSource = self;
		_tableView.delegate = self;

		_tableView.allowsSelection = NO;
		_tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];

		// 注册
		[_tableView registerClass:[ResultCell class] forCellReuseIdentifier:kResultCell];
	}

	return _tableView;
}

@end
