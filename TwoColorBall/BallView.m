//
//  BallView.m
//  TwoColorBall
//
//  Created by 刘明 on 2016/12/26.
//  Copyright © 2016年 刘明. All rights reserved.
//

#define kBallIsBlank1 0 // 红字白球背景
#define kBallIsBlank2 1 // 蓝字白球背景
#define kBallIsRed 2    // 白字红球背景
#define kBallIsBlue 3   // 白字蓝球背景

#define kDefaultFontSize 20.0f  // 在40X40情况下的，默认字体大小。
#define kDefaultWidth 40.0f // 默认（宽）大小

#import "BallView.h"

@implementation BallView

- (instancetype)initWithFrame:(CGRect)frame {
	if (self = [super initWithFrame:frame]) {
		CGFloat width = frame.size.width;
		CGRect contentRect = CGRectMake((CGFloat) (width * 0.1), (CGFloat) (width * 0.1), (CGFloat) (width * 0.8), (CGFloat) (width * 0.8));
		_textLabel = [[UILabel alloc] initWithFrame:contentRect];
		_textLabel.textAlignment = NSTextAlignmentCenter;

		_backgroundView = [[UIView alloc] initWithFrame:contentRect];

//        // 好像系统默认字体是17。所以需要把字体设大一点。这个实现方式不好。换下面的一种。
//        _textLabel.adjustsFontSizeToFitWidth = YES;
//        _textLabel.font = [UIFont systemFontOfSize:100.0f];

		// 另一种我认为更好的实现方式：通过计算比例，然后X默认字体大小，计算合适字体大小。
		float fontSize = (float) (frame.size.width / kDefaultWidth * kDefaultFontSize);
		_textLabel.font = [UIFont systemFontOfSize:fontSize];

		_backgroundView.layer.cornerRadius = _backgroundView.frame.size.width / 2; // 圆形

		[self addSubview:_backgroundView];
		[self addSubview:_textLabel];
	}

	return self;
}


#pragma mark - 默认状态，可以自定义

- (void)setState:(NSUInteger)state {
	switch (state) {
		case kBallIsBlank1: {
			_textLabel.textColor = kRedColor;
			_backgroundView.layer.borderWidth = 0.5;
			_backgroundView.layer.borderColor = [UIColor grayColor].CGColor;
			_backgroundView.layer.backgroundColor = [UIColor whiteColor].CGColor;
			break;
		}
		case kBallIsBlank2: {
			_textLabel.textColor = kBlueColor;
			_backgroundView.layer.borderWidth = 0.5;
			_backgroundView.layer.borderColor = [UIColor grayColor].CGColor;
			_backgroundView.layer.backgroundColor = [UIColor whiteColor].CGColor;
			break;
		}
		case kBallIsRed: {
			_textLabel.textColor = [UIColor whiteColor];
			_backgroundView.layer.backgroundColor = kRedColor.CGColor;
			break;
		}
		case kBallIsBlue: {
			_textLabel.textColor = [UIColor whiteColor];
			_backgroundView.layer.backgroundColor = kBlueColor.CGColor;
			break;
		}
		default:
			break;
	}
}

@end
