//
//  TrendStatisticsView.m
//  TwoColorBall
//
//  Created by 刘明 on 2016/12/31.
//  Copyright © 2016年 刘明. All rights reserved.
//

#import "TrendStatisticsView.h"

@implementation TrendStatisticsView

- (instancetype)init {
	if (self = [super initWithFrame:CGRectMake(0.0f, 0.0f, kTitleWidth + kLabelWidth * (33 + 16), kLabelWidth)]) {
		_titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, kTitleWidth, kLabelWidth)];
		_titleLabel.font = [UIFont systemFontOfSize:11.0f];
		_titleLabel.textAlignment = NSTextAlignmentCenter;
		_titleLabel.layer.borderWidth = 0.5f;
		_titleLabel.layer.borderColor = kRGBColor(230.0f, 230.0f, 230.0f).CGColor;
		[self addSubview:_titleLabel];

		NSMutableArray *labelArray = [NSMutableArray arrayWithCapacity:(33 + 16)];
		for (NSUInteger i = 1; i <= (33 + 16); i++) {
			UILabel *numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(kTitleWidth + kLabelWidth * (i - 1),
					0.0f,
					kLabelWidth,
					kLabelWidth)];
			numberLabel.layer.borderWidth = 0.5f;
			numberLabel.layer.borderColor = kRGBColor(230.0f, 230.0f, 230.0f).CGColor;
			numberLabel.textAlignment = NSTextAlignmentCenter;
			numberLabel.font = [UIFont systemFontOfSize:11.0f];
			[self addSubview:numberLabel];
			[labelArray addObject:numberLabel];
		}
		_labels = [labelArray copy];
	}

	return self;
}


#pragma mark - 设置

- (void)setStatisticses:(NSArray *)statisticses {
	if (statisticses.count == _labels.count) {
		for (NSUInteger i = 0; i < _labels.count; i++) {
			UILabel *numberLabel = _labels[i];
			numberLabel.text = [statisticses[i] description];
		}
	}
}

- (void)setState:(NSUInteger)state {
	UIColor *textColor = [UIColor grayColor];
	switch (state) {
		case 0: {
			textColor = [UIColor purpleColor];
			break;
		}
		case 1: {
			textColor = [UIColor cyanColor];
			break;
		}
		case 2: {
			textColor = [UIColor brownColor];
			break;
		}
		case 3: {
			textColor = [UIColor greenColor];
			break;
		}
		default:
			break;
	}
	_titleLabel.backgroundColor = kRGBColor(235.0f, 231.0f, 219.0f);
	_titleLabel.textColor = textColor;
	if (state % 2 == 1) {
		_titleLabel.backgroundColor = kRGBColor(246.0f, 240.0f, 240.0f);
	}

	for (UILabel *label in _labels) {
		label.textColor = textColor;
		label.backgroundColor = [UIColor whiteColor];
		if (state % 2 == 1) {
			label.backgroundColor = [UIColor groupTableViewBackgroundColor];
		}
	}
}

@end
