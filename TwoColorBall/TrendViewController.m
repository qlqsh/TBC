//
//  TrendViewController2.m
//  TwoColorBall
//
//  Created by 刘明 on 2017/1/9.
//  Copyright © 2017年 刘明. All rights reserved.
//

#define kDefaultRowWidth 65.0f+25.0f*(33+16)
#define kDefaultRowHeight 25.0f

#import "TrendViewController.h"

#import "TrendTitleView.h"
#import "TrendView.h"
#import "TrendStatisticsView.h"
#import "TrendBallButtonView.h"

#import "TrendData.h"

#import <MBProgressHUD/MBProgressHUD.h>

@interface TrendViewController ()

// 数据
@property (nonatomic, strong, readonly) NSArray *winningList;       // 获奖列表（走势整理后）
@property (nonatomic, strong, readonly) NSArray *statisticsArray;   // 统计数组

// 设置属性
@property (nonatomic, strong) NSDictionary *settingDict;
@property (nonatomic) NSUInteger termAmount;    // 期数
@property (nonatomic) BOOL hasMissing;          // 显示遗漏值
@property (nonatomic) BOOL hasStatistics;       // 显示统计
@property (nonatomic) BOOL hasSelectedBall;     // 显示选择球按钮

// 显示视图
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *titleView;        // (0, 0)，常驻视图
@property (nonatomic, strong) UIView *trendView;        // (0, 25.0f)，常驻视图（30行、50行、100行）
@property (nonatomic, strong) UIView *statisticsView;   // 动态显示视图
@property (nonatomic, strong) UIView *selectedBallView; // 动态显示视图

@end

@implementation TrendViewController

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];

	// 进度指示器
	[MBProgressHUD showHUDAddedTo:self.view animated:YES];
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
		TrendData *trendData = [[TrendData alloc] init];
		_winningList = [trendData termAndBallsWithCustomNumber:100];
		_statisticsArray = [trendData statisticsArrayWithNumber:0];
		dispatch_async(dispatch_get_main_queue(), ^{
			[MBProgressHUD hideHUDForView:self.view animated:YES];
			[self.view addSubview:self.scrollView];
		});
	});
}

- (void)viewDidLoad {
	[super viewDidLoad];
	// Do any additional setup after loading the view.

	self.title = @"走势图";

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

	[self removeView];
}

- (void)removeView {
	// 滚动视图删除所有子视图
	for (UIView *subView in [_scrollView subviews]) {
		[subView removeFromSuperview];
	}

	// 删除滚动视图
	for (UIView *subView in [self.view subviews]) {
		if ([subView isKindOfClass:[UIScrollView class]]) {
			[subView removeFromSuperview];
		}
	}

	// 视图全部为空
	_titleView = nil;
	_trendView = nil;
	_statisticsView = nil;
	_selectedBallView = nil;
	_scrollView = nil;
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

									   [MBProgressHUD showHUDAddedTo:self.view animated:YES];
									   // 清除所有视图
									   [self removeView];

									   // 延时机制。消除警告
									   dispatch_after((dispatch_time_t) 0.2, dispatch_get_main_queue(), ^{
										   // 进度指示器
										   [MBProgressHUD hideHUDForView:self.view animated:YES];
										   [self.view addSubview:self.scrollView];
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


#pragma mark - 获取

- (UIView *)titleView {
	if (!_titleView) {
		_titleView = [[TrendTitleView alloc] init];
	}

	return _titleView;
}

- (UIView *)trendView {
	if (!_trendView) {
		_trendView = [[UIView alloc] init];
		NSArray *subArray = [_winningList subarrayWithRange:NSMakeRange(_winningList.count - self.termAmount,
				self.termAmount)];
		for (NSUInteger i = 0; i < self.termAmount; i++) {
			NSArray *termAndBalls = subArray[i];
			TrendView *trendView = [[TrendView alloc] init];
			trendView.termLabel.text = [termAndBalls firstObject];
			trendView.trendBaseView.hasMissing = self.hasMissing;
			trendView.trendBaseView.trendBalls = [termAndBalls lastObject];
			if (i % 2 == 1) {
				trendView.state = 1;
			} else {
				trendView.state = 0;
			}
			trendView.frame = CGRectMake(0.0f,
					trendView.frame.size.height * i,
					trendView.frame.size.width,
					trendView.frame.size.height);
			[_trendView addSubview:trendView];
		}
	}

	return _trendView;
}

- (UIView *)statisticsView {
	if (!_statisticsView) {
		_statisticsView = [[UIView alloc] init];
		for (NSUInteger i = 0; i <= 3; i++) {
			TrendStatisticsView *trendStatisticsView = [[TrendStatisticsView alloc] init];
			switch (i) {
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
			trendStatisticsView.statisticses = self.statisticsArray[i];
			trendStatisticsView.frame = CGRectMake(0.0f, trendStatisticsView.frame.size.height * i,
					trendStatisticsView.frame.size.width, trendStatisticsView.frame.size.height);
			[_statisticsView addSubview:trendStatisticsView];
		}
	}

	return _statisticsView;
}

- (UIView *)selectedBallView {
	if (!_selectedBallView) {
		_selectedBallView = [[TrendBallButtonView alloc] init];
	}

	return _selectedBallView;
}

- (UIScrollView *)scrollView {
	if (!_scrollView) {
		CGRect bounds = [[UIScreen mainScreen] bounds]; // 滚动视图占满整个屏幕
		_scrollView = [[UIScrollView alloc] initWithFrame:bounds];

		_scrollView.showsVerticalScrollIndicator = NO;
		_scrollView.showsHorizontalScrollIndicator = NO;
		_scrollView.bounces = NO;                 // 边界无法弹动
		_scrollView.directionalLockEnabled = YES; // 定向锁定

		// 状态栏(statusbar)
		CGRect rectStatusBar = [[UIApplication sharedApplication] statusBarFrame];
		// 导航栏（navigationbar）
		CGRect rectNavigationBar = self.navigationController.navigationBar.frame;
		CGFloat positionY = rectStatusBar.size.height + rectNavigationBar.size.height;

		UIView *titleView = self.titleView;
		titleView.frame = CGRectMake(0.0f, positionY, kDefaultRowWidth, kDefaultRowHeight);
		[_scrollView addSubview:titleView];
		positionY += titleView.frame.size.height;

		UIView *trendView = self.trendView;
		trendView.frame = CGRectMake(0.0f, positionY, kDefaultRowWidth, kDefaultRowHeight * self.termAmount);
		[_scrollView addSubview:trendView];
		positionY += trendView.frame.size.height;

		if (self.hasStatistics) {
			UIView *statisticsView = self.statisticsView;
			statisticsView.frame = CGRectMake(0.0f, positionY, kDefaultRowWidth, kDefaultRowHeight * 4);
			[_scrollView addSubview:statisticsView];
			positionY += statisticsView.frame.size.height;
		}

		if (self.hasSelectedBall) {
			UIView *selectedBallView = self.selectedBallView;
			selectedBallView.frame = CGRectMake(0.0f, positionY, kDefaultRowWidth, kDefaultRowHeight);
			[_scrollView addSubview:selectedBallView];
			positionY += selectedBallView.frame.size.height;
		}

		_scrollView.contentSize = CGSizeMake(kDefaultRowWidth, positionY);
	}

	return _scrollView;
}

- (void)setSettingDict:(NSDictionary *)settingDict {
	[[NSUserDefaults standardUserDefaults] setObject:settingDict forKey:@"trend_setting"];
}

- (NSDictionary *)settingDict {
	NSDictionary *settingDict = [[NSUserDefaults standardUserDefaults] objectForKey:@"trend_setting"];
	if (settingDict == nil) {
		settingDict = @{@"termAmount": @(0), @"missing": @(0), @"statistics": @(0), @"selectedBall": @(0)};
	}
	return settingDict;
}

- (NSUInteger)termAmount {
	NSInteger amount = [self.settingDict[@"termAmount"] integerValue];
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
	NSInteger missing = [self.settingDict[@"missing"] integerValue];
	return missing != 0;
}

- (BOOL)hasStatistics {
	NSInteger statistics = [self.settingDict[@"statistics"] integerValue];
	return statistics != 0;
}

- (BOOL)hasSelectedBall {
	NSInteger selectedBall = [self.settingDict[@"selectedBall"] integerValue];
	return selectedBall != 0;
}

@end
