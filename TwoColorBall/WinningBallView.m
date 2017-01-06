//
//  WinningBallView.m
//  TwoColorBall
//
//  Created by 刘明 on 2016/12/26.
//  Copyright © 2016年 刘明. All rights reserved.
//

#import "WinningBallView.h"
#import "BallView.h"

@implementation WinningBallView

/**
 *  初始化获奖号码视图对象。
 */
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        CGFloat width = frame.size.width/7;
        _redBall1 = [[BallView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, width, width)];
        _redBall2 = [[BallView alloc] initWithFrame:CGRectMake(width, 0.0f, width, width)];
        _redBall3 = [[BallView alloc] initWithFrame:CGRectMake(width*2, 0.0f, width, width)];
        _redBall4 = [[BallView alloc] initWithFrame:CGRectMake(width*3, 0.0f, width, width)];
        _redBall5 = [[BallView alloc] initWithFrame:CGRectMake(width*4, 0.0f, width, width)];
        _redBall6 = [[BallView alloc] initWithFrame:CGRectMake(width*5, 0.0f, width, width)];
        _blueBall = [[BallView alloc] initWithFrame:CGRectMake(width*6, 0.0f, width, width)];
        
        _redBall1.state = 2;
        _redBall2.state = 2;
        _redBall3.state = 2;
        _redBall4.state = 2;
        _redBall5.state = 2;
        _redBall6.state = 2;
        _blueBall.state = 3;
        
        [self addSubview:_redBall1];
        [self addSubview:_redBall2];
        [self addSubview:_redBall3];
        [self addSubview:_redBall4];
        [self addSubview:_redBall5];
        [self addSubview:_redBall6];
        [self addSubview:_blueBall];
    }
    
    return self;
}

#pragma mark - 设置
- (void)setBalls:(NSArray *)balls {
    if (balls.count == 7) {
        _redBall1.textLabel.text = balls[0];
        _redBall2.textLabel.text = balls[1];
        _redBall3.textLabel.text = balls[2];
        _redBall4.textLabel.text = balls[3];
        _redBall5.textLabel.text = balls[4];
        _redBall6.textLabel.text = balls[5];
        _blueBall.textLabel.text = balls[6];
    }
}

#pragma mark - 类方法
+ (CGFloat)heightOfCellWithWidth:(CGFloat)width {
    return width/7.0f;
}

@end
