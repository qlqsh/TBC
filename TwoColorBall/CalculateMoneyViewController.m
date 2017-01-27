//
//  CalculateMoneyViewController.m
//  TwoColorBall
//
//  Created by 刘明 on 2017/1/16.
//  Copyright © 2017年 刘明. All rights reserved.
//

#import "CalculateMoneyViewController.h"

#import "WinningCell.h"
#import "CMButtonCell.h"
#import "MyNumbersCell.h"
#import "WinningMoneyCell.h"

#import "WinningBallView.h"
#import "BallButtonView.h"

#import "DataManager.h"
#import "Winning.h"

#import "StatisticsManager.h"

#import <MBProgressHUD/MBProgressHUD.h>

static NSString *const kWinningCell = @"winningCell";
static NSString *const kButtonCell = @"buttonCell";
static NSString *const kMyNumbersCell = @"myNumbersCell";
static NSString *const kWinningMoneyCell = @"winningMoneyCell";

@interface CalculateMoneyViewController () <UITableViewDataSource, UITableViewDelegate,
		UIPickerViewDataSource, UIPickerViewDelegate>

@property (nonatomic, strong) NSArray *recentlyWinnings;
@property (nonatomic, strong) NSString *winningMoneyDescription;
@property (nonatomic, strong) Winning *winning; // 最近一期获奖信息
@property (nonatomic, strong) NSMutableArray *myNumbersArray;   // 我选择的号码数组

@property (nonatomic, strong) UIPickerView *pickerView;
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation CalculateMoneyViewController

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];

	DataManager *dataManager = [[DataManager alloc] init];

	_recentlyWinnings = [[dataManager readAllWinningListInFile] subarrayWithRange:NSMakeRange(0, 10)];
	_winning = [dataManager readLatestWinningInFile];
	_myNumbersArray = [[NSMutableArray alloc] initWithCapacity:1];
	_winningMoneyDescription = @"";
}

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
	self.title = @"奖金计算";
	[self.view addSubview:self.tableView];
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
			return _myNumbersArray.count;
		case 2:
			return 1;
		case 3: {
			if ([_winningMoneyDescription isEqualToString:@""]) {
				return 0;
			}
			return 1;
		}
		default:
			return 0;
	}
}

- (UITableViewCell *)tableView:(UITableView *)tableView
		 cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	switch (indexPath.section) {
		case 0: {
			WinningCell *cell = [tableView dequeueReusableCellWithIdentifier:kWinningCell
																forIndexPath:indexPath];
			cell.termLabel.text = [NSString stringWithFormat:@"第%@期", _winning.term];
			cell.dateLabel.text = [NSString stringWithFormat:@"%@（%@）", _winning.date, _winning.week];
			NSMutableArray *balls = [NSMutableArray arrayWithArray:_winning.reds];
			[balls addObjectsFromArray:_winning.blues];
			cell.winningBallView.balls = [balls copy];
			UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectedWinningTermAction)];
			[cell addGestureRecognizer:tapGestureRecognizer];

			return cell;
		}
		case 1: {
			MyNumbersCell *cell = [tableView dequeueReusableCellWithIdentifier:kMyNumbersCell
																  forIndexPath:indexPath];
			// 删除重影
			while ([cell.contentView.subviews lastObject] != nil) {
				[[cell.contentView.subviews lastObject] removeFromSuperview];
			}

			cell.numbersDictionary = _myNumbersArray[(NSUInteger) indexPath.row];

			return cell;
		}
		case 2: {
			CMButtonCell *cell = [tableView dequeueReusableCellWithIdentifier:kButtonCell
																 forIndexPath:indexPath];
			[cell.addButton addTarget:self
							   action:@selector(addAction)
					 forControlEvents:UIControlEventTouchUpInside];
			[cell.clearButton addTarget:self
								 action:@selector(clearAction)
					   forControlEvents:UIControlEventTouchUpInside];
			[cell.calculateButton addTarget:self
									 action:@selector(calculateAction)
						   forControlEvents:UIControlEventTouchUpInside];
			return cell;
		}
		case 3: {
			WinningMoneyCell *cell = [tableView dequeueReusableCellWithIdentifier:kWinningMoneyCell
																	 forIndexPath:indexPath];
			cell.winningMoneyView.text = _winningMoneyDescription;

			return cell;
		}
		default: { // 用不上
			UITableViewCell *cell =
					[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
										   reuseIdentifier:@"default"];
			return cell;
		}
	}
}


#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	switch (indexPath.section) {
		case 0:
			return [WinningCell heightOfCellWithWidth:kScreenWidth];
		case 1:
			return [MyNumbersCell heightOfCellWithNumbersDictionary:_myNumbersArray[(NSUInteger) indexPath.row]];
		case 2:
			return [CMButtonCell heightOfCell];
		case 3:
			return [WinningMoneyCell heightOfCell];
		default:
			return 50.0f;
	}
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.section == 0) {
		[self selectedWinningTermAction];
	}
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	switch (section) {
		case 0:
		case 1:
			return 20.0f;
		default:
			return 0.0f;
	}
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, kScreenWidth, 20.0f)];
	headerLabel.backgroundColor = kRedColor;
	headerLabel.textAlignment = NSTextAlignmentCenter;
	headerLabel.textColor = [UIColor whiteColor];
	switch (section) {
		case 0:
			headerLabel.text = @"开奖号码";
			break;
		case 1:
			headerLabel.text = @"我的号码";
			break;
		default:
			break;
	}
	return headerLabel;
}


#pragma mark - UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
	return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
	return _recentlyWinnings.count;
}


#pragma mark - UIPickerViewDelegate

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
	Winning *winning = _recentlyWinnings[(NSUInteger) row];
	return [NSString stringWithFormat:@"%@期 （%@）", winning.term, winning.week];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
	_winning = _recentlyWinnings[(NSUInteger) row];
}


#pragma mark - 给按钮附加动作

- (void)clearAction {
	[_myNumbersArray removeAllObjects];
	_winningMoneyDescription = @"";
	[self.tableView reloadData];
}

- (void)calculateAction {
	[MBProgressHUD showHUDAddedTo:self.view animated:YES];
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
		StatisticsManager *statisticsManager = [[StatisticsManager alloc] init];
		_winningMoneyDescription = [statisticsManager calculateMoneyWithCurrentWinning:_winning
																		  andMyNumbers:_myNumbersArray];
		dispatch_async(dispatch_get_main_queue(), ^{
			[self.tableView reloadData];
			[MBProgressHUD hideHUDForView:self.view animated:YES];
		});
	});
}

// 选择条件视图
- (void)addAction {
	NSMutableArray *redBallsArray = [NSMutableArray arrayWithCapacity:33];
	UIAlertController *alert =
			[UIAlertController alertControllerWithTitle:@"条件"
												message:@"\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n"
										 preferredStyle:UIAlertControllerStyleAlert];
	CGFloat width = 36.0f;
	UIView *redBallsView = [[UIView alloc] initWithFrame:CGRectMake(9.0f,
			50.0f,
			width * 7,
			width * 5)];
	redBallsView.layer.borderWidth = 0.5f;
	redBallsView.layer.borderColor = kRedColor.CGColor;
	// 绘制33个红球
	for (NSInteger i = 1, j = 0; i <= 33; i++) {
		if ((i - 1) % 7 == 0) {
			j += 1;
		}

		CGFloat positionX = ((i - 1) % 7) * width;
		CGFloat positionY = (j - 1) * width;

		BallButtonView *ballButtonView =
				[[BallButtonView alloc] initWithFrame:CGRectMake(positionX,
						positionY,
						width,
						width)];
		ballButtonView.isRed = YES;
		if (i < 10) {
			ballButtonView.text = [NSString stringWithFormat:@"0%ld", (long) i];
		} else {
			ballButtonView.text = [NSString stringWithFormat:@"%ld", (long) i];
		}
		[redBallsView addSubview:ballButtonView];
		[redBallsArray addObject:ballButtonView];
	}

	NSMutableArray *blueBallsArray = [NSMutableArray arrayWithCapacity:16];
	UIView *blueBallsView =
			[[UIView alloc] initWithFrame:CGRectMake(9.0f,
					50.0f + redBallsView.frame.size.height + 9.0f,
					width * 7,
					width * 3)];
	blueBallsView.layer.borderWidth = 0.5f;
	blueBallsView.layer.borderColor = kBlueColor.CGColor;
	// 绘制16个蓝球
	for (NSInteger i = 1, j = 0; i <= 16; i++) {
		if ((i - 1) % 7 == 0) {
			j += 1;
		}

		CGFloat positionX = ((i - 1) % 7) * width;
		CGFloat positionY = (j - 1) * width;

		BallButtonView *ballButtonView =
				[[BallButtonView alloc] initWithFrame:CGRectMake(positionX,
						positionY,
						width,
						width)];
		ballButtonView.isRed = NO;
		if (i < 10) {
			ballButtonView.text = [NSString stringWithFormat:@"0%ld", (long) i];
		} else {
			ballButtonView.text = [NSString stringWithFormat:@"%ld", (long) i];
		}
		[blueBallsView addSubview:ballButtonView];
		[blueBallsArray addObject:ballButtonView];
	}

	[alert.view addSubview:redBallsView];
	[alert.view addSubview:blueBallsView];

	UIAlertAction *defaultAction =
			[UIAlertAction actionWithTitle:@"确认"
									 style:UIAlertActionStyleDefault
								   handler:^(UIAlertAction *action) {
									   if (_myNumbersArray.count > 20) {
										   MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
										   hud.mode = MBProgressHUDModeText;
										   hud.label.text = @"您的获奖号码太多了！";
										   [hud hideAnimated:YES afterDelay:2.0f];
									   } else {
										   NSMutableArray *selectedRedBallsArray = [NSMutableArray arrayWithCapacity:6];
										   for (BallButtonView *redBallButtonView in redBallsArray) {
											   if (redBallButtonView.ballButton.selected) {
												   [selectedRedBallsArray addObject:redBallButtonView.ballButton.titleLabel.text];
											   }
										   }
										   NSMutableArray *selectedBlueBallsArray = [NSMutableArray arrayWithCapacity:1];
										   for (BallButtonView *blueBallButtonView in blueBallsArray) {
											   if (blueBallButtonView.ballButton.selected) {
												   [selectedBlueBallsArray
														   addObject:blueBallButtonView.ballButton.titleLabel.text];
											   }
										   }
										   NSDictionary *selectedBallDictionary = @{@"reds": selectedRedBallsArray,
												   @"blues": selectedBlueBallsArray
										   };
										   MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
										   hud.mode = MBProgressHUDModeText;
										   if (selectedRedBallsArray.count < 6) {
											   hud.label.text = @"最少需要选择6个红球！";
											   [hud hideAnimated:YES afterDelay:2.0f];
										   } else if (selectedBlueBallsArray.count < 1) {
											   hud.label.text = @"最少需要选择1个蓝球！";
											   [hud hideAnimated:YES afterDelay:2.0f];
										   } else if (selectedRedBallsArray.count > 15) {
											   hud.label.text = @"最多只能选择15个红球！";
											   [hud hideAnimated:YES afterDelay:2.0f];
										   } else {
											   [hud hideAnimated:YES];
											   [_myNumbersArray addObject:selectedBallDictionary];
											   // 延时机制。消除警告
											   dispatch_after((dispatch_time_t) 0.2, dispatch_get_main_queue(), ^{
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

// 选择获奖期号
- (void)selectedWinningTermAction {
	UIAlertController *alert =
			[UIAlertController alertControllerWithTitle:@"条件"
												message:@"\n\n\n\n\n\n\n\n\n"
										 preferredStyle:UIAlertControllerStyleAlert];

	[alert.view addSubview:self.pickerView];

	UIAlertAction *defaultAction =
			[UIAlertAction actionWithTitle:@"确认"
									 style:UIAlertActionStyleDefault
								   handler:^(UIAlertAction *action) {
									   [self.tableView reloadData];
								   }];
	[defaultAction setValue:kRedColor forKey:NSLocalizedString(@"titleTextColor", @"titleTextColor")];

	[alert addAction:defaultAction];

	[self presentViewController:alert animated:YES completion:nil];
}


#pragma mark - 属性的设置与获取

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
		[_tableView registerClass:[WinningCell class] forCellReuseIdentifier:kWinningCell];
		[_tableView registerClass:[CMButtonCell class] forCellReuseIdentifier:kButtonCell];
		[_tableView registerClass:[MyNumbersCell class] forCellReuseIdentifier:kMyNumbersCell];
		[_tableView registerClass:[WinningMoneyCell class] forCellReuseIdentifier:kWinningMoneyCell];
	}

	return _tableView;
}

- (UIPickerView *)pickerView {
	if (!_pickerView) {
		_pickerView = [[UIPickerView alloc] initWithFrame:CGRectZero];
		_pickerView.frame = CGRectMake(0.0f, 40.0f, 270.0f, 162.0f);

		_pickerView.dataSource = self;
		_pickerView.delegate = self;

		[_pickerView selectRow:0 inComponent:0 animated:YES];
	}

	return _pickerView;
}

@end
