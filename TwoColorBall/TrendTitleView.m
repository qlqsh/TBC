//
//  TrendTitleView.m
//  TwoColorBall
//
//  Created by 刘明 on 2016/12/31.
//  Copyright © 2016年 刘明. All rights reserved.
//

#import "TrendTitleView.h"

@implementation TrendTitleView

- (instancetype)init {
    if (self = [super initWithFrame:CGRectMake(0.0f, 0.0f, kTitleWidth+kLabelWidth*(33+16), kLabelWidth)]) {
        UIImageView *numIssue = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"NumIssue"]];
        [self addSubview:numIssue];
        
        for (NSUInteger i = 1; i <= 33; i++) {
            UILabel *redLabel = [[UILabel alloc] initWithFrame:CGRectMake(kTitleWidth+kLabelWidth*(i-1),
                                                                          0.0f,
                                                                          kLabelWidth,
                                                                          kLabelWidth)];
            NSString *valueString = [NSString stringWithFormat:@"%lu", (unsigned long)i];
            if (i < 10) {
                valueString = [NSString stringWithFormat:@"0%lu", (unsigned long)i];
            }
            redLabel.layer.borderWidth = 0.5f;
            redLabel.layer.borderColor = kRGBColor(230.0f, 230.0f, 230.0f).CGColor;
            redLabel.text = valueString;
            redLabel.textColor = kRGBColor(123.0f, 114.0f, 108.0f);
            redLabel.textAlignment = NSTextAlignmentCenter;
            redLabel.font = [UIFont boldSystemFontOfSize:16.0f];
            redLabel.backgroundColor = kRGBColor(236.0f, 231.0f, 219.0f);
            [self addSubview:redLabel];
        }
        
        for (NSUInteger i = 1; i <= 16; i++) {
            UILabel *blueLabel = [[UILabel alloc] initWithFrame:CGRectMake(kTitleWidth+kLabelWidth*(33+i-1),
                                                                           0.0f,
                                                                           kLabelWidth,
                                                                           kLabelWidth)];
            NSString *valueString = [NSString stringWithFormat:@"%lu", (unsigned long)i];
            if (i < 10) {
                valueString = [NSString stringWithFormat:@"0%lu", (unsigned long)i];
            }
            blueLabel.layer.borderWidth = 0.5f;
            blueLabel.layer.borderColor = kRGBColor(230.0f, 230.0f, 230.0f).CGColor;
            blueLabel.text = valueString;
            blueLabel.textColor = kRGBColor(123.0f, 114.0f, 108.0f);
            blueLabel.textAlignment = NSTextAlignmentCenter;
            blueLabel.font = [UIFont boldSystemFontOfSize:16.0f];
            blueLabel.backgroundColor = kRGBColor(236.0f, 231.0f, 219.0f);
            [self addSubview:blueLabel];
        }
    }
    
    return self;
}

@end
