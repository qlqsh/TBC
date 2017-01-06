//
//  TrendBallButtonView.m
//  TwoColorBall
//
//  Created by 刘明 on 2016/12/31.
//  Copyright © 2016年 刘明. All rights reserved.
//

#import "TrendBallButtonView.h"
#import "BallButtonView.h"

#define kDefaultWidth 25.0f

@implementation TrendBallButtonView

- (instancetype)init {
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 65.0f, kDefaultWidth)];
    titleLabel.font = [UIFont systemFontOfSize:12.0f];
    titleLabel.text = @"选号";
    titleLabel.textColor = [UIColor magentaColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.layer.borderWidth = 0.5f;
    titleLabel.layer.borderColor = kRGBColor(230.0f, 230.0f, 230.0f).CGColor;
    
    CGFloat titleWidth = titleLabel.frame.size.width;
    NSMutableArray *selectedButtonArray = [NSMutableArray array];
    // 33个红球按钮
    for (int i = 1; i <= 33; i++) {
        BallButtonView *ballButtonView =
        [[BallButtonView alloc] initWithFrame:CGRectMake(titleWidth+kDefaultWidth*(i-1),
                                                         0.0f,
                                                         kDefaultWidth,
                                                         kDefaultWidth)];
        ballButtonView.layer.borderWidth = 0.5f;
        ballButtonView.layer.borderColor = kRGBColor(230.0f, 230.0f, 230.0f).CGColor;
        ballButtonView.isRed = YES;
        if (i < 10) {
            ballButtonView.text = [NSString stringWithFormat:@"0%d", i];
        } else {
            ballButtonView.text = [NSString stringWithFormat:@"%d", i];
        }
        
        [selectedButtonArray addObject:ballButtonView];
    }
    
    // 16个蓝球按钮
    for (int i = 1; i <= 16; i++) {
        BallButtonView *ballButtonView =
        [[BallButtonView alloc] initWithFrame:CGRectMake(titleWidth+kDefaultWidth*(33+i-1),
                                                         0.0f,
                                                         kDefaultWidth,
                                                         kDefaultWidth)];
        ballButtonView.layer.borderWidth = 0.5f;
        ballButtonView.layer.borderColor = kRGBColor(230.0f, 230.0f, 230.0f).CGColor;
        ballButtonView.isRed = NO;
        if (i < 10) {
            ballButtonView.text = [NSString stringWithFormat:@"0%d", i];
        } else {
            ballButtonView.text = [NSString stringWithFormat:@"%d", i];
        }
        
        [selectedButtonArray addObject:ballButtonView];
    }
    
    if (self = [super initWithFrame:CGRectMake(0.0f, 0.0f,
                                               titleWidth+kDefaultWidth*(33+16),
                                               kDefaultWidth)]) {
        [self addSubview:titleLabel];
        for (UIButton *button in selectedButtonArray) {
            [self addSubview:button];
        }
    }
    
    return self;
}

@end
