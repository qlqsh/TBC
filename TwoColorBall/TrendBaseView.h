//
//  TrendBaseView.h
//  TwoColorBall
//
//  Created by 刘明 on 2016/12/30.
//  Copyright © 2016年 刘明. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TrendBaseView : UIView
@property (nonatomic, strong) NSArray *winningBalls;
@property (nonatomic, strong) NSArray *trendBalls;
@property (nonatomic, strong, readonly) NSArray *ballViews; // 球视图数组（33红球+16蓝球）
@property (nonatomic) NSUInteger state;
@property (nonatomic) BOOL hasMissing;

+ (CGFloat)heightOfView;
+ (CGFloat)widthOfView;

// 设置红、蓝球
- (void)setWinningReds:(NSArray *)reds andBlues:(NSArray *)blues;

@end
