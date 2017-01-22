//
//  StatisticsCollectionReusableView.m
//  TwoColorBall
//
//  Created by 刘明 on 2016/12/27.
//  Copyright © 2016年 刘明. All rights reserved.
//

#import "StatisticsCollectionReusableView.h"

@implementation StatisticsCollectionReusableView

#pragma mark - 初始化

- (instancetype)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
	if (self) {
		[self addSubview:self.titleLabel];
	}

	return self;
}


#pragma mark - Getters

- (UILabel *)titleLabel {
	if (!_titleLabel) {
		_titleLabel = [[UILabel alloc] initWithFrame:self.bounds];
		_titleLabel.backgroundColor = kRedColor;
		_titleLabel.textColor = [UIColor whiteColor];
		_titleLabel.textAlignment = NSTextAlignmentCenter;
	}

	return _titleLabel;
}


@end
