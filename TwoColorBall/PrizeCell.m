//
//  PrizeCell.m
//  TwoColorBall
//
//  Created by 刘明 on 2016/12/28.
//  Copyright © 2016年 刘明. All rights reserved.
//

#import "PrizeCell.h"

/**
 *  中奖情况
 */
@implementation PrizeCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
		CGFloat width = kScreenWidth;
		_awardsLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, width / 3, 25.0f)];
		_awardsLabel.textAlignment = NSTextAlignmentCenter;
		_awardsLabel.font = [UIFont systemFontOfSize:16.0f];

		_winningAmountLabel = [[UILabel alloc] initWithFrame:CGRectMake(width / 3, 0.0f, width / 3, 25.0f)];
		_winningAmountLabel.textAlignment = NSTextAlignmentCenter;
		_winningAmountLabel.font = [UIFont systemFontOfSize:16.0f];

		_winningMoneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(width * 2 / 3, 0.0f, width / 3, 25.0f)];
		_winningMoneyLabel.textAlignment = NSTextAlignmentCenter;
		_winningMoneyLabel.font = [UIFont systemFontOfSize:16.0f];

		[self.contentView addSubview:_awardsLabel];
		[self.contentView addSubview:_winningAmountLabel];
		[self.contentView addSubview:_winningMoneyLabel];
	}

	return self;
}


#pragma mark - 类方法

+ (CGFloat)heightOfCell {
	return 25.0f;
}

@end
