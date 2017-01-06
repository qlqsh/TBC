//
//  TrendStatisticsView.h
//  TwoColorBall
//
//  Created by 刘明 on 2016/12/31.
//  Copyright © 2016年 刘明. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TrendStatisticsView : UIView
@property (nonatomic, strong, readonly) UILabel *titleLabel;
@property (nonatomic, strong, readonly) NSArray *labels;
@property (nonatomic, strong) NSArray *statisticses;
@property (nonatomic) NSUInteger state;
@end
