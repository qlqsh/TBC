//
//  WinningBallView.h
//  TwoColorBall
//
//  Created by 刘明 on 2016/12/26.
//  Copyright © 2016年 刘明. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BallView;

// 获奖视图（6红+1蓝）
@interface WinningBallView : UIView

@property (nonatomic, strong) NSArray *balls;

@property (nonatomic, strong) BallView *redBall1;
@property (nonatomic, strong) BallView *redBall2;
@property (nonatomic, strong) BallView *redBall3;
@property (nonatomic, strong) BallView *redBall4;
@property (nonatomic, strong) BallView *redBall5;
@property (nonatomic, strong) BallView *redBall6;
@property (nonatomic, strong) BallView *blueBall;

+ (CGFloat)heightOfCellWithWidth:(CGFloat)width; // 单元高度

@end
