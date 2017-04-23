//
//  ConditionTrendViewController.m
//  TwoColorBall
//
//  Created by 刘明 on 2017/1/9.
//  Copyright © 2017年 刘明. All rights reserved.
//

#import "ConditionTrendViewController.h"
#import "BallButtonView.h"
#import "ConditionTrendBaseStatisticsViewController.h"

#import "StatisticsManager.h"
#import "SimpleWinning.h"
#import "NumberCombinations.h"

#import "ButtonCell.h"
#import "ConditionCell.h"
#import "ResultCell.h"

#import <MBProgressHUD/MBProgressHUD.h>

static NSString *const kButtonCell = @"buttonCell";
static NSString *const kConditionCell = @"conditionCell";
static NSString *const kResultCell = @"resultCell";

@interface ConditionTrendViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSMutableArray *conditionArray;   // 条件数组
@property (nonatomic, strong) NSMutableArray *resultArray;      // 结果数组
@property (nonatomic, strong) NSArray *recentTwoTermWinnings; 	// 最近2期获奖数据

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation ConditionTrendViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	// Do any additional setup after loading the view.

	[self initializeUserInface];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}


#pragma mark - 界面设置

- (void)initializeUserInface {
	self.title = @"相似走势";
	_conditionArray = [NSMutableArray arrayWithCapacity:1];
	_resultArray = [NSMutableArray arrayWithCapacity:1];
	StatisticsManager *statisticsManager = [[StatisticsManager alloc] init];
	NSArray *allWinning = statisticsManager.allWinning;
	_recentTwoTermWinnings = [[[allWinning subarrayWithRange:NSMakeRange(0, 2)] reverseObjectEnumerator] allObjects];
	[self.view addSubview:self.tableView];

	// 基础统计
	UIBarButtonItem *pushButton =
			[[UIBarButtonItem alloc] initWithTitle:@"基础统计"
											 style:UIBarButtonItemStylePlain
											target:self
											action:@selector(pushBaseStatisticsViewController)];
	self.navigationItem.rightBarButtonItem = pushButton;
}

- (void)pushBaseStatisticsViewController {
	ConditionTrendBaseStatisticsViewController *viewController = [[ConditionTrendBaseStatisticsViewController alloc] init];
	[self.navigationController pushViewController:viewController animated:YES];
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	switch (section) {
		case 0: // 最近获奖2行
			return _recentTwoTermWinnings.count;
		case 1: // 条件行
			return _conditionArray.count;
		case 2: // 按钮行
			return 1;
		case 3: // 结果行
			return _resultArray.count;
		default:
			return 0;
	}
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	switch (indexPath.section) {
		case 0: {
			ResultCell *resultCell = [tableView dequeueReusableCellWithIdentifier:kResultCell
																	 forIndexPath:indexPath];
			SimpleWinning *simpleWinning = self.recentTwoTermWinnings[(NSUInteger) indexPath.row];
			resultCell.titleLabel.text = simpleWinning.term;
			NSMutableArray *balls = [NSMutableArray arrayWithCapacity:7];
			[balls addObjectsFromArray:simpleWinning.reds.numbers];
			[balls addObjectsFromArray:simpleWinning.blues.numbers];
			resultCell.winningBallView.balls = [balls copy];

			return resultCell;
		}
		case 1: {
			ConditionCell *conditionCell = [tableView dequeueReusableCellWithIdentifier:kConditionCell
																		   forIndexPath:indexPath];
			// 删除重影
			while ([conditionCell.contentView.subviews lastObject] != nil) {
				[[conditionCell.contentView.subviews lastObject] removeFromSuperview];
			}
			conditionCell.conditionBalls = _conditionArray[(NSUInteger) indexPath.row];

			return conditionCell;
		}
		case 2: {
			ButtonCell *buttonCell = [tableView dequeueReusableCellWithIdentifier:kButtonCell
																	 forIndexPath:indexPath];
			[buttonCell.addButton addTarget:self
									 action:@selector(addAction)
						   forControlEvents:UIControlEventTouchUpInside];
			[buttonCell.clearButton addTarget:self
									   action:@selector(clearAction)
							 forControlEvents:UIControlEventTouchUpInside];
			[buttonCell.calculateButton addTarget:self
										   action:@selector(calculateAction)
								 forControlEvents:UIControlEventTouchUpInside];

			return buttonCell;
		}
		case 3: {
			ResultCell *resultCell = [tableView dequeueReusableCellWithIdentifier:kResultCell
																	 forIndexPath:indexPath];
			SimpleWinning *simpleWinning = self.resultArray[(NSUInteger) indexPath.row];
			resultCell.titleLabel.text = simpleWinning.term;
			NSMutableArray *balls = [NSMutableArray arrayWithCapacity:7];
			[balls addObjectsFromArray:simpleWinning.reds.numbers];
			[balls addObjectsFromArray:simpleWinning.blues.numbers];
			resultCell.winningBallView.balls = [balls copy];

			return resultCell;
		}
		default: { // 用不上
			UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
														   reuseIdentifier:@"default"];
			return cell;
		}
	}
}


#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	switch (indexPath.section) {
		case 0:
			return [ResultCell heightOfCell];
		case 1:
			return [ConditionCell heightOfCell];
		case 2:
			return [ButtonCell heightOfCell];
		case 3:
			return [ResultCell heightOfCell];
		default:
			return 0;
	}
}


#pragma mark - 给按钮附加动作

- (void)clearAction {
	[self.conditionArray removeAllObjects];
	[self.resultArray removeAllObjects];
	[self.tableView reloadData];
}

- (void)calculateAction {
	[MBProgressHUD showHUDAddedTo:self.view animated:YES];
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
		StatisticsManager *statisticsManager = [[StatisticsManager alloc] init];
		self.resultArray =
				[[statisticsManager nextWinningDataWithNumberCombinations:self.conditionArray] mutableCopy];
		dispatch_async(dispatch_get_main_queue(), ^{
            // TODO: 这里应该再有个判断。就是条件为空（没有条件），啥也不做
            
			if (self.resultArray.count == 0) {
				[MBProgressHUD hideHUDForView:self.view animated:YES];
				MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
				hud.mode = MBProgressHUDModeText;
				hud.label.text = @"没有符合条件的数据";
				[hud hideAnimated:YES afterDelay:2.0f];
			} else {
				[self.tableView reloadData];
				[MBProgressHUD hideHUDForView:self.view animated:YES];
			}
		});
	});
}

// 选择条件视图
- (void)addAction {
	NSMutableArray *ballArray = [NSMutableArray arrayWithCapacity:34];
	UIAlertController *alert =
			[UIAlertController alertControllerWithTitle:@"条件"
												message:@"\n\n\n\n\n\n\n\n\n\n\n"
										 preferredStyle:UIAlertControllerStyleAlert];
	CGFloat width = 36.0f;
	// 绘制33个红球
	for (NSInteger i = 1, j = 0; i <= 34; i++) {
		if ((i - 1) % 7 == 0) {
			j += 1;
		}

		CGFloat positionX = 9.0f + ((i - 1) % 7) * width;
		CGFloat positionY = 50.0f + (j - 1) * width;

		BallButtonView *ballButtonView =
				[[BallButtonView alloc] initWithFrame:CGRectMake(positionX,
						positionY,
						width,
						width)];
		ballButtonView.isRed = YES;
		if (i == 34) {
			ballButtonView.text = @"空";
		} else {
			if (i < 10) {
				ballButtonView.text = [NSString stringWithFormat:@"0%ld", (long) i];
			} else {
				ballButtonView.text = [NSString stringWithFormat:@"%ld", (long) i];
			}
		}
		[alert.view addSubview:ballButtonView];
		[ballArray addObject:ballButtonView];
	}

	UIAlertAction *defaultAction =
			[UIAlertAction actionWithTitle:@"确认"
									 style:UIAlertActionStyleDefault
								   handler:^(UIAlertAction *action) {
									   if (_conditionArray.count > 5) {
										   MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view
																					 animated:YES];
										   hud.mode = MBProgressHUDModeText;
										   hud.label.text = @"您的条件太多了！";
										   [hud hideAnimated:YES afterDelay:2.0f];
									   } else {
										   NSMutableArray *selectedBallArray = [NSMutableArray arrayWithCapacity:6];
										   for (BallButtonView *ballButtonView in ballArray) {
											   if (ballButtonView.ballButton.selected) {
												   [selectedBallArray addObject:ballButtonView.ballButton.titleLabel.text];
											   }
										   }

										   // 1、最多只能选择6个红球。
										   if (selectedBallArray.count > 6) {
											   MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view
																						 animated:YES];
											   hud.mode = MBProgressHUDModeText;
											   hud.label.text = @"最多只能选择6个红球";
											   [hud hideAnimated:YES afterDelay:2.0f];
										   } else {
											   // 2、选择了“空”
											   if ([[selectedBallArray lastObject] isEqualToString:@"空"]) {
												   [_conditionArray addObject:@[]];
											   } else {
												   [_conditionArray addObject:selectedBallArray];
											   }
											   // 延时机制。消除警告
											   dispatch_after((dispatch_time_t) 0.2,
													   dispatch_get_main_queue(), ^{
														   // 刷新表格
														   [self.tableView reloadData];
													   });
										   }
									   }
								   }];
	[defaultAction setValue:kRedColor forKey:NSLocalizedString(@"titleTextColor", @"titleTextColor")];
	UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消"
														   style:UIAlertActionStyleCancel
														 handler:^(UIAlertAction *action) {
														 }];
	[cancelAction setValue:kRedColor forKey:NSLocalizedString(@"titleTextColor", @"titleTextColor")];

	[alert addAction:defaultAction];
	[alert addAction:cancelAction];

	[self presentViewController:alert animated:YES completion:nil];
}


#pragma mark - 属性获取

- (UITableView *)tableView {
	if (!_tableView) {
		_tableView = [[UITableView alloc] initWithFrame:self.view.bounds
												  style:UITableViewStylePlain];
		_tableView.dataSource = self;
		_tableView.delegate = self;

		_tableView.allowsSelection = NO;
		_tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
		_tableView.separatorInset = UIEdgeInsetsZero;

		// 注册
		[_tableView registerClass:[ButtonCell class] forCellReuseIdentifier:kButtonCell];
		[_tableView registerClass:[ConditionCell class] forCellReuseIdentifier:kConditionCell];
		[_tableView registerClass:[ResultCell class] forCellReuseIdentifier:kResultCell];
	}

	return _tableView;
}

@end
