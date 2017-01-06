//
//  BallButton.m
//  TwoColorBall
//
//  Created by 刘明 on 2016/12/31.
//  Copyright © 2016年 刘明. All rights reserved.
//

#import "BallButtonView.h"

@implementation BallButtonView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _ballButton = [UIButton buttonWithType:UIButtonTypeCustom];
        CGFloat width = frame.size.width;
        _ballButton.frame = CGRectMake(width*0.1, width*0.1, width*0.8, width*0.8);
        _ballButton.titleLabel.font = [UIFont systemFontOfSize:12.0f];
        [_ballButton setBackgroundImage:[UIImage imageNamed:@"WhiteBallBackground"]
                               forState:UIControlStateNormal];
        [_ballButton setTitleColor:[UIColor whiteColor]
                          forState:UIControlStateSelected];
        [_ballButton addTarget:self
                        action:@selector(isSelected:)
              forControlEvents:UIControlEventTouchUpInside];
        _ballButton.adjustsImageWhenHighlighted = NO;
        [self addSubview:_ballButton];
    }
    
    return self;
}

/**
 *  主要用来变换。白底红字的球，点击后变成红底白字。
 *
 *  @param sender 操作对象
 */
- (void)isSelected:(id)sender {
    UIButton *button = (UIButton *) sender;
    _ballButton.selected = !button.selected;
}

/**
 *  是否是红色按钮。
 *
 *  @param isRed YES：红色按钮。NO：蓝色按钮。
 */
- (void)setIsRed:(BOOL)isRed {
    if (isRed) { // 红色按钮
        [_ballButton setTitleColor:kRedColor forState:UIControlStateNormal];
        [_ballButton setBackgroundImage:[UIImage imageNamed:@"RedBallBackground"]
                               forState:UIControlStateSelected];
    } else { // 蓝球按钮
        [_ballButton setTitleColor:kBlueColor forState:UIControlStateNormal];
        [_ballButton setBackgroundImage:[UIImage imageNamed:@"BlueBallBackground"]
                               forState:UIControlStateSelected];
    }
}

/**
 *  设置按钮文字内容。
 *
 *  @param text 内容。
 */
- (void)setText:(NSString *)text {
    [_ballButton setTitle:text forState:UIControlStateNormal];
    [_ballButton setTitle:text forState:UIControlStateSelected];
}

@end
