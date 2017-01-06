//
//  StatisticsViewController.m
//  TwoColorBall
//
//  Created by 刘明 on 2016/12/27.
//  Copyright © 2016年 刘明. All rights reserved.
//

#import "StatisticsViewController.h"
#import "StatisticsCollectionReusableView.h"
#import "StatisticsManager.h"
#import "NumberCombinations.h"
#import <PNPieChart.h>
#import <MBProgressHUD.h>

static NSString *const kCollectionViewCellIdentifier = @"statisticsCell";
static NSString *const kCollectionElementKindSectionHeaderIdentifier = @"statisticsHeaderCell";

@interface StatisticsViewController () <UICollectionViewDataSource,
                                        UICollectionViewDelegate,
                                        UICollectionViewDelegateFlowLayout>

@property(nonatomic, strong) UICollectionView *collectionView; // 集合视图
@property(nonatomic, strong) UICollectionViewFlowLayout *collectionViewFlowLayout; // 流式布局

@property(nonatomic, strong) NSDictionary *dataDict;

@end

@implementation StatisticsViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    StatisticsManager *statisticsManager = [StatisticsManager sharedData];
    NSMutableDictionary *dataDict = [NSMutableDictionary dictionaryWithCapacity:8];
    
    dataDict[@"red"] = [statisticsManager redCountInWinningCount:0];
    dataDict[@"blue"] = [statisticsManager blueCountInWinningCount:0];
    dataDict[@"head"] = [statisticsManager headCountInWinningCount:0];
    dataDict[@"tail"] = [statisticsManager tailCountInWinningCount:0];
    dataDict[@"valueOfSum"] = [statisticsManager valueOfSumInWinningCount:0];
    dataDict[@"continuous"] = [statisticsManager continuousCountInWinningCount:0];
    dataDict[@"redThreeArea"] = [statisticsManager redThreeAreaCountInWinningCount:0];
    dataDict[@"blueRemainder"] = [statisticsManager blueRemainderCountInWinningCount:0];
    
    _dataDict = [dataDict copy];
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
    // 视图加载
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"统计";
    [self.view addSubview:self.collectionView];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 8;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell =
        [collectionView dequeueReusableCellWithReuseIdentifier:kCollectionViewCellIdentifier
                                                  forIndexPath:indexPath];
    // 解决重影的另一种方式
    if (!cell) {
        cell = [[UICollectionViewCell alloc] init];
    } else {
        while ([cell.contentView.subviews lastObject] != nil) {
            [[cell.contentView.subviews lastObject] removeFromSuperview];
        }
    }
    switch (indexPath.section) {
        case 0:
            [cell.contentView addSubview:[self drawPieChartWithArray:_dataDict[@"red"]]];
            break;
        case 1:
            [cell.contentView addSubview:[self drawPieChartWithArray:_dataDict[@"blue"]]];
            break;
        case 2:
            [cell.contentView addSubview:[self drawHeadOrTailPieChartWithArray:_dataDict[@"head"]]];
            break;
        case 3:
            [cell.contentView addSubview:[self drawHeadOrTailPieChartWithArray:_dataDict[@"tail"]]];
            break;
        case 4: {
            NSDictionary *dict = (NSDictionary *)_dataDict[@"valueOfSum"];
            NSArray *valueArray = @[ dict[@"range_61_80"],
                                     dict[@"range_81_100"],
                                     dict[@"range_101_120"],
                                     dict[@"range_121_140"],
                                     dict[@"other"],
                                     ];
            NSArray *colorArray = @[ kRedColor, kBlueColor, kGreenColor,
                                     kOrangeColor, kYellowColor];
            NSArray *descriptionArray = @[ @"和值（61 ～ 80）",
                                           @"和值（81 ～ 100）",
                                           @"和值（101 ～ 120）",
                                           @"和值（121 ～ 140）",
                                           @"其它",
                                           ];
            [cell.contentView addSubview:[self drawPieChartWithValueArray:valueArray
                                                            andColorArray:colorArray
                                                      andDescriptionArray:descriptionArray]];
            break;
        }
        case 5: {
            NSDictionary *dict = (NSDictionary *)_dataDict[@"continuous"];
            NSArray *valueArray = @[ dict[@"continuous_0"],
                                     dict[@"continuous_1"],
                                     dict[@"continuous_2"],
                                     dict[@"other"],
                                     ];
            NSArray *colorArray = @[ kRedColor, kBlueColor, kGreenColor, kOrangeColor ];
            NSArray *descriptionArray = @[ @"没有连号",
                                           @"1个连号",
                                           @"2个连号",
                                           @"其它",
                                           ];
            [cell.contentView addSubview:[self drawPieChartWithValueArray:valueArray
                                                            andColorArray:colorArray
                                                      andDescriptionArray:descriptionArray]];
            break;
        }
        case 6: {
            NSDictionary *dict = (NSDictionary *)_dataDict[@"redThreeArea"];
            NSArray *valueArray = @[ dict[@"redOneArea"],
                                     dict[@"redTwoArea"],
                                     dict[@"redThreeArea"]
                                     ];
            NSArray *colorArray = @[ kRedColor, kBlueColor, kGreenColor ];
            NSArray *descriptionArray = @[ @"红1区（01 ～ 11）",
                                           @"红2区（12 ～ 22）",
                                           @"红3区（23 ～ 33）"
                                           ];
            [cell.contentView addSubview:[self drawPieChartWithValueArray:valueArray
                                                            andColorArray:colorArray
                                                      andDescriptionArray:descriptionArray]];
            break;
        }
        case 7: {
            NSDictionary *dict = (NSDictionary *)_dataDict[@"blueRemainder"];
            NSArray *valueArray = @[ dict[@"blue0"], dict[@"blue1"], dict[@"blue2"] ];
            NSArray *colorArray = @[ kRedColor, kBlueColor, kGreenColor ];
            NSArray *descriptionArray = @[ @"03 06 09 12 15",
                                           @"01 04 07 10 13 16",
                                           @"02 05 08 11 14"
                                           ];
            [cell.contentView addSubview:[self drawPieChartWithValueArray:valueArray
                                                            andColorArray:colorArray
                                                      andDescriptionArray:descriptionArray]];
            break;
        }
        default:
            break;
    }
    
    return cell;
}

#pragma mark - 饼图
- (PNPieChart *)drawPieChartWithArray:(NSArray *)dataArray {
    NSMutableArray *items = [NSMutableArray arrayWithCapacity:dataArray.count];
    int i = 0;
    for (NumberCombinations *numberCombinations in dataArray) {
        UIColor *color = kRGBColor(255.0f-i*5, 83.0f, 75.0f);
        PNPieChartDataItem *dataItem =
        [PNPieChartDataItem dataItemWithValue:numberCombinations.showNumber
                                        color:color
                                  description:numberCombinations.toString];
        i++;
        [items addObject:dataItem];
    }
    CGFloat width = self.view.bounds.size.width*0.8;
    CGFloat startXY = self.view.bounds.size.width*0.05;
    PNPieChart *pieChart = [[PNPieChart alloc] initWithFrame:CGRectMake(startXY,
                                                                        startXY,
                                                                        width,
                                                                        width)
                                                       items:[items copy]];
    pieChart.descriptionTextColor = [UIColor whiteColor];
    pieChart.descriptionTextFont  = [UIFont fontWithName:@"Avenir-Medium" size:9.0];
    [pieChart strokeChart];
    
    return pieChart;
}

// TODO: 这个方式是有问题的，就是数据特别少的情况下，会崩溃。不过那种情况是以后才用，暂时不会有问题。
- (PNPieChart *)drawHeadOrTailPieChartWithArray:(NSArray *)dataArray {
    NSMutableArray *items = [NSMutableArray arrayWithCapacity:dataArray.count];
    NSArray *colorArray = @[ kRedColor, kBlueColor, kGreenColor,
                             kOrangeColor, kYellowColor, kCyanColor ];
    for (int i = 0; i < 5; i++) {
        NumberCombinations *numberCombinations = dataArray[i];
        PNPieChartDataItem *dataItem =
        [PNPieChartDataItem dataItemWithValue:numberCombinations.showNumber
                                        color:colorArray[i]
                                  description:numberCombinations.toString];
        [items addObject:dataItem];
    }
    int other = 0;
    for (int i = 5; i < dataArray.count; i++) {
        NumberCombinations *numberCombinations = dataArray[i];
        other += numberCombinations.showNumber;
    }
    PNPieChartDataItem *otherItem = [PNPieChartDataItem dataItemWithValue:other
                                                                    color:colorArray[5]
                                                              description:@"其它"];
    [items addObject:otherItem];
    CGFloat width = self.view.bounds.size.width*0.8;
    CGFloat startXY = self.view.bounds.size.width*0.05;
    PNPieChart *pieChart = [[PNPieChart alloc] initWithFrame:CGRectMake(startXY,
                                                                        startXY,
                                                                        width,
                                                                        width)
                                                       items:[items copy]];
    pieChart.descriptionTextColor = [UIColor whiteColor];
    pieChart.descriptionTextFont  = [UIFont fontWithName:@"Avenir-Medium" size:9.0];
    [pieChart strokeChart];
    
    return pieChart;
}

- (PNPieChart *)drawPieChartWithValueArray:(NSArray *)valueArray
                             andColorArray:(NSArray *)colorArray
                       andDescriptionArray:(NSArray *)descriptionArray {
    
    NSUInteger count = valueArray.count;
    if (colorArray.count < count) {
        count = colorArray.count;
    }
    if (descriptionArray.count < count) {
        count = descriptionArray.count;
    }
    
    NSMutableArray *items = [NSMutableArray arrayWithCapacity:count];
    for (int i = 0; i < count; i++) {
        PNPieChartDataItem *dataItem =
        [PNPieChartDataItem dataItemWithValue:[valueArray[i] integerValue]
                                        color:colorArray[i]
                                  description:descriptionArray[i]];
        [items addObject:dataItem];
    }
    
    CGFloat width = self.view.bounds.size.width*0.8;
    CGFloat startXY = self.view.bounds.size.width*0.05;
    PNPieChart *pieChart = [[PNPieChart alloc] initWithFrame:CGRectMake(startXY,
                                                                        startXY,
                                                                        width,
                                                                        width)
                                                       items:[items copy]];
    pieChart.descriptionTextColor = [UIColor whiteColor];
    pieChart.descriptionTextFont  = [UIFont fontWithName:@"Avenir-Medium" size:9.0];
    [pieChart strokeChart];
    
    return pieChart;
}

#pragma mark - UITableViewDelegate
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView
           viewForSupplementaryElementOfKind:(NSString *)kind
                                 atIndexPath:(NSIndexPath *)indexPath {
    StatisticsCollectionReusableView *headerView =
        [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                                           withReuseIdentifier:kCollectionElementKindSectionHeaderIdentifier
                                                  forIndexPath:indexPath];
    headerView.backgroundColor = kRedColor;
    switch (indexPath.section) {
        case 0:
            headerView.titleLabel.text = @"红球";
            break;
        case 1:
            headerView.titleLabel.text = @"蓝球";
            break;
        case 2:
            headerView.titleLabel.text = @"头";
            break;
        case 3:
            headerView.titleLabel.text = @"尾";
            break;
        case 4:
            headerView.titleLabel.text = @"和值范围";
            break;
        case 5:
            headerView.titleLabel.text = @"连号概率";
            break;
        case 6:
            headerView.titleLabel.text = @"红球3区分布";
            break;
        case 7:
            headerView.titleLabel.text = @"蓝球012路分布";
            break;
        default:
            break;
    }
    
    return headerView;
}

#pragma mark - Getters
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds
                                             collectionViewLayout:self.collectionViewFlowLayout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        
        // 注册
        [self.collectionView registerClass:[UICollectionViewCell class]
                forCellWithReuseIdentifier:kCollectionViewCellIdentifier];
        [self.collectionView registerClass:[StatisticsCollectionReusableView class]
                forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                       withReuseIdentifier:kCollectionElementKindSectionHeaderIdentifier];
    }
    
    return _collectionView;
}

- (UICollectionViewFlowLayout *)collectionViewFlowLayout {
    if (!_collectionViewFlowLayout) {
        _collectionViewFlowLayout = [[UICollectionViewFlowLayout alloc] init];
        // 设置cell
        CGFloat width = self.view.bounds.size.width*0.9;
        _collectionViewFlowLayout.estimatedItemSize = CGSizeMake(width, width);
        _collectionViewFlowLayout.itemSize = CGSizeMake(width, width);
        _collectionViewFlowLayout.minimumLineSpacing = 5.0f;
        _collectionViewFlowLayout.minimumInteritemSpacing = 5.0f;
        
        // 设置头、尾
        _collectionViewFlowLayout.headerReferenceSize = CGSizeMake(CGRectGetWidth(self.view.bounds), 44);
        _collectionViewFlowLayout.footerReferenceSize = CGSizeZero;
    }
    
    return _collectionViewFlowLayout;
}

@end
