//
//  TrendView.m
//  TwoColorBall
//
//  Created by 刘明 on 2016/12/31.
//  Copyright © 2016年 刘明. All rights reserved.
//

#import "TrendView.h"

#define kTermLabelWidth 65.0f
#define kDefaultWidth 25.0f

@implementation TrendView

- (instancetype)init {
    if (self = [super init]) {
        _termLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f,
                                                               kTermLabelWidth,
                                                               kDefaultWidth)];
        _termLabel.font = [UIFont systemFontOfSize:11.0f];
        _termLabel.textAlignment = NSTextAlignmentCenter;
        _termLabel.layer.borderWidth = 0.5f;
        _termLabel.layer.borderColor = kRGBColor(230.0f, 230.0f, 230.0f).CGColor;
        
        _trendBaseView = [[TrendBaseView alloc] initWithFrame:CGRectMake(_termLabel.frame.size.width,
                                                                         0.0f,
                                                                         [TrendBaseView widthOfView],
                                                                         kDefaultWidth)];
        [self addSubview:_termLabel];
        [self addSubview:_trendBaseView];
        [self redAndBlueLine];
    }
    
    return self;
}

#pragma mark - 设置
- (void)setState:(NSUInteger)state {
    _termLabel.backgroundColor = kRGBColor(235.0f, 231.0f, 219.0f);
    if (state%2 == 1) {
        _termLabel.backgroundColor = kRGBColor(246.0f, 240.0f, 240.0f);
    }
    _trendBaseView.state = state;
}

#pragma mark - 红蓝分割线
- (void)redAndBlueLine {
    CALayer *layer = [CALayer layer];
    
    layer.backgroundColor = [UIColor grayColor].CGColor;
    layer.frame = CGRectMake(kTermLabelWidth+kDefaultWidth*33, 0.0f, 1.0f, kDefaultWidth);
    
    [self.layer addSublayer:layer];
}
@end
