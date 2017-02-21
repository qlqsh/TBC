//
//  ViewController.m
//  TwoColorBall
//
//  Created by 刘明 on 2016/12/22.
//  Copyright © 2016年 刘明. All rights reserved.
//

#import "FunctionListViewController.h"
#import "FunctionCell.h"
#import "DataManager.h"
#import "Reachability.h"
#import <MBProgressHUD/MBProgressHUD.h>

static NSString *const kCollectionViewCellIdentifier = @"functionCell";

@interface FunctionListViewController () <UICollectionViewDataSource,
		UICollectionViewDelegate,
		UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *collectionView; // 集合视图
@property (nonatomic, strong) UICollectionViewFlowLayout *collectionViewFlowLayout; // 流式布局

// 网络标识
@property (nonatomic, strong) Reachability *connection;
@property (nonatomic, strong) MBProgressHUD *hud;
@end

@implementation FunctionListViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
	[self initializeUserInterface];
	[self initializeNetworking];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
	[self.connection stopNotifier];
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}


#pragma mark - 初始化界面

- (void)initializeUserInterface {
	self.title = @"功能列表";
	// 视图加载
	[self.view addSubview:self.collectionView];

	// 更新
	UIBarButtonItem *refreshButton =
			[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh
														  target:self
														  action:@selector(initializeNetworking)];
	refreshButton.tintColor = [UIColor whiteColor];
	self.navigationItem.rightBarButtonItem = refreshButton;

	[self.view addSubview:self.hud];
}


#pragma mark - 网络状态监控

- (void)initializeNetworking {
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(checkNetworkState)
												 name:kReachabilityChangedNotification
											   object:nil];
	self.connection = [Reachability reachabilityForInternetConnection];
	[self.connection startNotifier];

	if ([self.connection currentReachabilityStatus] != NotReachable) {
		[self updateDataUseNetworking];
	}
}


#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
	return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView
	 numberOfItemsInSection:(NSInteger)section {
	return 6;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
				  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
	FunctionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCollectionViewCellIdentifier
																   forIndexPath:indexPath];
	cell.state = indexPath.row;

	return cell;
}


#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
	switch (indexPath.row) {
		case 0: // 获奖列表
			[self performSegueWithIdentifier:@"WinningList" sender:nil];
			break;
		case 1: // 走势图
			[self performSegueWithIdentifier:@"Trend" sender:nil];
			break;
		case 2: // 历史同期
			[self performSegueWithIdentifier:@"HistorySame" sender:nil];
			break;
		case 3: // 统计
			[self performSegueWithIdentifier:@"Statistics" sender:nil];
			break;
		case 4: // 相似走势
			[self performSegueWithIdentifier:@"ConditionTrend" sender:nil];
			break;
		case 5: // 计算奖金
			[self performSegueWithIdentifier:@"CalculateMoney" sender:nil];
			break;
		default:
			break;
	}
}


#pragma mark - Getters

- (UICollectionView *)collectionView {
	if (!_collectionView) {
		CGRect collectionViewRect = CGRectMake(0, 0,
				CGRectGetWidth(self.view.bounds),
				CGRectGetHeight(self.view.bounds));
		_collectionView = [[UICollectionView alloc] initWithFrame:collectionViewRect
											 collectionViewLayout:self.collectionViewFlowLayout];
		UIImage *backgroundImage = [UIImage imageNamed:@"Background"];
		_collectionView.layer.contents = (id) backgroundImage.CGImage;
		_collectionView.dataSource = self;
		_collectionView.delegate = self;

		// 注册
		[_collectionView registerClass:[FunctionCell class]
			forCellWithReuseIdentifier:kCollectionViewCellIdentifier];
	}

	return _collectionView;
}

- (UICollectionViewFlowLayout *)collectionViewFlowLayout {
	if (!_collectionViewFlowLayout) {
		_collectionViewFlowLayout = [[UICollectionViewFlowLayout alloc] init];
		// 设置cell
		CGFloat cellWidth = self.view.bounds.size.width / 2;
		CGFloat cellHeight = (CGFloat) (cellWidth * 1.25);
		_collectionViewFlowLayout.estimatedItemSize = CGSizeMake(cellWidth, cellHeight);
		_collectionViewFlowLayout.itemSize = CGSizeMake(cellWidth, cellHeight);
		_collectionViewFlowLayout.minimumLineSpacing = 0;
		_collectionViewFlowLayout.minimumInteritemSpacing = 0;
	}

	return _collectionViewFlowLayout;
}

- (MBProgressHUD *)hud {
	if (!_hud) {
		_hud = [[MBProgressHUD alloc] initWithView:self.view];
	}

	return _hud;
}


#pragma mark - 网络状况监测

- (void)checkNetworkState {
	if ([self.connection currentReachabilityStatus] == ReachableViaWiFi) { // WiFi
		[self updateDataUseNetworking];
	} else if ([self.connection currentReachabilityStatus] == ReachableViaWWAN) { // 3G
		[self updateDataUseNetworking];
	} else { // NotReachable
		MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
		hud.mode = MBProgressHUDModeText;
		hud.label.text = @"网络无法访问";
		[hud hideAnimated:YES afterDelay:2.0f];
		[hud removeFromSuperViewOnHide];
		DLog(@"没有网络");
	}
}


#pragma mark - 网络获取数据

- (void)updateDataUseNetworking {
	// 进度指示器
	[self.hud showAnimated:YES];
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
		DataManager *dataManager = [[DataManager alloc] init];
        [dataManager updateWinningInfoUseNetworking];
		dispatch_async(dispatch_get_main_queue(), ^{
			[self.hud hideAnimated:YES];
		});
	});
    [self.hud hideAnimated:YES afterDelay:15.0f];
}

@end
