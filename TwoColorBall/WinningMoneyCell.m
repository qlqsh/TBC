//
//  WinningMoneyCell.m
//  TwoColorBall
//
//  Created by 刘明 on 2017/1/20.
//  Copyright © 2017年 刘明. All rights reserved.
//

#import "WinningMoneyCell.h"

@implementation WinningMoneyCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
		_winningMoneyView = [[UITextView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, kScreenWidth, [WinningMoneyCell heightOfCell])];
		_winningMoneyView.textAlignment = NSTextAlignmentCenter;
		_winningMoneyView.textColor = kRedColor;
		_winningMoneyView.font = [UIFont systemFontOfSize:24.0f];
		[self.contentView addSubview:_winningMoneyView];
	}

	return self;
}

+ (CGFloat)heightOfCell {
	return 30.0f * 8;
}

@end
