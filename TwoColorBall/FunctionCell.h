//
//  TCBFunctionCell.h
//  TwoColorBall
//
//  Created by 刘明 on 2016/12/22.
//  Copyright © 2016年 刘明. All rights reserved.
//

#define kIsWinning  0
#define kIsTrend    1
#define kIsHistorySame  2
#define kIsStatistics   3
#define kIsConditionTrend   4
#define kIsCalculateMoney   5

#import <UIKit/UIKit.h>

// 功能单元
@interface FunctionCell : UICollectionViewCell

@property (nonatomic, strong) UIView *iconView; // 图标
@property (nonatomic, strong) UILabel *descriptionLabel; // 功能描述
@property (nonatomic) NSInteger state;

@end
