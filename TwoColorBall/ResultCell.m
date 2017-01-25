//
//  ResultCell.m
//  TwoColorBall
//
//  Created by 刘明 on 2017/1/14.
//  Copyright © 2017年 刘明. All rights reserved.
//

#import "ResultCell.h"

@implementation ResultCell

// 默认初始化
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
		[self.contentView addSubview:self.titleLabel];
		[self.contentView addSubview:self.winningBallView];
	}

	return self;
}


#pragma mark - 属性获取与设置

- (UILabel *)titleLabel {
	if (!_titleLabel) {
		_titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, (CGFloat) (kScreenWidth * 0.2),
				[ResultCell heightOfCell])];
		_titleLabel.font = [UIFont systemFontOfSize:14.0f];
		_titleLabel.textColor = [UIColor grayColor];
		_titleLabel.textAlignment = NSTextAlignmentCenter;
	}

	return _titleLabel;
}

- (WinningBallView *)winningBallView {
	if (!_winningBallView) {
		_winningBallView = [[WinningBallView alloc] initWithFrame:CGRectMake((CGFloat) (kScreenWidth * 0.2),
				0.0f, (CGFloat) (kScreenWidth * 0.8), [ResultCell heightOfCell])];
	}

	return _winningBallView;
}


#pragma mark - 公共类方法

+ (CGFloat)heightOfCell {
	return [WinningBallView heightOfCellWithWidth:(CGFloat) (kScreenWidth * 0.8)];
}

@end
