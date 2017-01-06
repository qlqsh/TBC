//
//  TrendBaseView.m
//  TwoColorBall
//
//  Created by 刘明 on 2016/12/30.
//  Copyright © 2016年 刘明. All rights reserved.
//

#import "TrendBaseView.h"
#import "BallView.h"
#import "Ball.h"

@implementation TrendBaseView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        NSMutableArray *ballViewArray = [NSMutableArray arrayWithCapacity:33+16];
        BallView *ballView = nil;
        for (NSUInteger i = 1; i <= (33+16); i++) {
            ballView = [[BallView alloc] initWithFrame:CGRectMake(kDefaultWidth*(i-1),
                                                                  0.0f,
                                                                  kDefaultWidth,
                                                                  kDefaultWidth)];
            ballView.textLabel.textColor = kRGBColor(230.0f, 230.0f, 230.0f);
            ballView.layer.borderWidth = 0.5f;
            ballView.layer.borderColor = kRGBColor(230.0f, 230.0f, 230.0f).CGColor;
            [self addSubview:ballView];
            [ballViewArray addObject:ballView];
        }
        _ballViews = [ballViewArray copy];
    }
    
    return self;
}

// 绘制网格
//- (void)drawGrid {
//    UIGraphicsBeginImageContext(self.bounds.size);
//    UIBezierPath *path = [UIBezierPath bezierPath];
//    CGPoint startPoint = CGPointMake(0.0f, 0.0f);
//    for (NSUInteger i = 0; i < (33+16); i++) {
//        CGPoint nextPoint = CGPointMake(i*kDefaultWidth, kDefaultWidth);
//        [path moveToPoint:startPoint];
//        [path addLineToPoint:nextPoint];
//        startPoint = nextPoint;
//    }
//    [path stroke];
//    UIGraphicsEndImageContext();
//    
//    CAShapeLayer *slayer = [CAShapeLayer layer];
//    slayer.path = path.CGPath;
//    slayer.strokeColor = kBlueColor.CGColor;
//    slayer.fillColor = [UIColor clearColor].CGColor;
//    slayer.lineWidth = 1.0f;
//    
//    [self.layer addSublayer:slayer];
//}

#pragma mark - 设置内容
// 设置红、蓝球
- (void)setWinningReds:(NSArray *)reds andBlues:(NSArray *)blues {
    for (NSString *red in reds) {
        NSUInteger value = [red integerValue];
        BallView *ballView = (BallView *)_ballViews[value-1];
        ballView.state = 2;
        ballView.textLabel.text = red;
    }
    for (NSString *blue in blues) {
        NSUInteger value = [blue integerValue];
        BallView *ballView = (BallView *)_ballViews[33+value-1];
        ballView.state = 3;
        ballView.textLabel.text = blue;
    }
}

- (void)setTrendBalls:(NSArray *)trendBalls {
    if (_ballViews.count == trendBalls.count) {
        NSUInteger ballCount = 0;
        for (NSUInteger i = 0; i < _ballViews.count; i++) {
            Ball *ball = (Ball *)trendBalls[i];
            BallView *ballView = (BallView *)_ballViews[i];
            if (ball.isBall) {
                ballCount += 1;
                NSString *valueString = [NSString stringWithFormat:@"%lu", (unsigned long)ball.value];
                if (ball.value < 10) {
                    valueString = [NSString stringWithFormat:@"0%lu", (unsigned long)ball.value];
                }
                ballView.textLabel.text = valueString;
                ballView.state = 2;
                if (ballCount > 6) {
                    ballView.state = 3;
                }
            } else {
                if (_hasMissing) {
                    ballView.textLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)ball.value];
                }
            }
        }
    }
}

- (void)setState:(NSUInteger)state {
    for (BallView *ballView in _ballViews) {
        ballView.backgroundColor = [UIColor whiteColor];
        if (state%2 == 1) {
            ballView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        }
    }
}

#pragma mark - 类方法
+ (CGFloat)heightOfView {
    return kDefaultWidth;
}

+ (CGFloat)widthOfView {
    return kDefaultWidth*(33+16);
}

@end
