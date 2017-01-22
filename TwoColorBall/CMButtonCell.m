//
//  CMButtonCell.m
//  TwoColorBall
//
//  Created by 刘明 on 2017/1/16.
//  Copyright © 2017年 刘明. All rights reserved.
//
//  与 ConditionTrend 的 ButtonCell 基本一样，仅文字描述不同。只是从功能角度来说，不应该是同一个类。

#define kCenterSpace 5.0f
#define kEdgeSpace 10.0f

#import "CMButtonCell.h"

@implementation CMButtonCell

// 默认初始化
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
		[self.contentView addSubview:self.addButton];
		[self.contentView addSubview:self.clearButton];
		[self.contentView addSubview:self.calculateButton];

		CGFloat width = kScreenWidth / 3 - kEdgeSpace - kCenterSpace;
		CGFloat height = 30.0f;
		CGFloat startX = kEdgeSpace;
		self.addButton.frame = CGRectMake(startX, kCenterSpace * 2, width, height);
		startX += _addButton.frame.size.width + kCenterSpace + kCenterSpace;
		self.clearButton.frame = CGRectMake(startX, kCenterSpace * 2, width, height);
		startX += _clearButton.frame.size.width + kCenterSpace + kCenterSpace;
		self.calculateButton.frame = CGRectMake(startX, kCenterSpace * 2, width, height);
	}

	return self;
}


#pragma mark - 类方法

+ (CGFloat)heightOfCell {
	return 30.0f + kCenterSpace * 2 * 2;
}


#pragma mark - 属性获取
#define kButtonHeight 30.0f // 按钮默认高度
#define kButtonWidth kScreenWidth/3-kEdgeSpace-kCenterSpace

- (UIButton *)addButton {
	if (!_addButton) {
		_addButton = [UIButton buttonWithType:UIButtonTypeCustom];
		_addButton.frame = CGRectMake(kEdgeSpace, kCenterSpace, kButtonWidth, kButtonHeight);
		_addButton.layer.borderWidth = 0.5f;
		_addButton.layer.borderColor = kRGBColor(230.0f, 230.0f, 230.0f).CGColor;
		_addButton.layer.cornerRadius = kButtonHeight / 2;

		[_addButton setTitle:@"我的号码" forState:UIControlStateNormal];
		[_addButton setTitleColor:kRedColor forState:UIControlStateNormal];
	}

	return _addButton;
}

- (UIButton *)clearButton {
	if (!_clearButton) {
		_clearButton = [UIButton buttonWithType:UIButtonTypeCustom];
		_clearButton.layer.borderWidth = 0.5f;
		_clearButton.layer.borderColor = kRGBColor(230.0f, 230.0f, 230.0f).CGColor;
		_clearButton.layer.cornerRadius = kButtonHeight / 2;

		[_clearButton setTitle:@"清除" forState:UIControlStateNormal];
		[_clearButton setTitleColor:kRedColor forState:UIControlStateNormal];
	}

	return _clearButton;
}

- (UIButton *)calculateButton {
	if (!_calculateButton) {
		_calculateButton = [UIButton buttonWithType:UIButtonTypeCustom];
		_calculateButton.layer.borderWidth = 0.5f;
		_calculateButton.layer.borderColor = kRGBColor(230.0f, 230.0f, 230.0f).CGColor;
		_calculateButton.layer.cornerRadius = kButtonHeight / 2;

		[_calculateButton setTitle:@"计算奖金" forState:UIControlStateNormal];
		[_calculateButton setTitleColor:kRedColor forState:UIControlStateNormal];
	}

	return _calculateButton;
}

@end
