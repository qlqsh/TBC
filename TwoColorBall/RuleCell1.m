//
//  RuleCell1.m
//  TwoColorBall
//
//  Created by 刘明 on 2016/12/28.
//  Copyright © 2016年 刘明. All rights reserved.
//

#import "RuleCell1.h"
#import "WinningBallView.h"
#import "BallView.h"

@implementation RuleCell1

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
		CGFloat width = kScreenWidth;
		CGFloat height = [RuleCell1 heightOfCellWithWidth:width];
		_awardLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, (CGFloat) (width * 0.2), height)];
		_awardLabel.textAlignment = NSTextAlignmentCenter;
		_awardLabel.font = [UIFont systemFontOfSize:10.0f];
		[self.contentView addSubview:_awardLabel];

		_moneyLabel = [[UILabel alloc] initWithFrame:CGRectMake((CGFloat) (width * 0.2), 0.0f, (CGFloat) (width * 0.3), height)];
		_moneyLabel.textAlignment = NSTextAlignmentCenter;
		_moneyLabel.font = [UIFont systemFontOfSize:10.0f];
		[self.contentView addSubview:_moneyLabel];

		_winningBallView = [[WinningBallView alloc] initWithFrame:CGRectMake((CGFloat) (width * 0.5), 0.0f, (CGFloat) (width * 0.5), height)];
		[self.contentView addSubview:_winningBallView];
	}

	return self;
}


#pragma mark - 规则模式的特殊球状态

- (void)setStates:(NSArray *)states {
	if (states.count == 7) {
		_winningBallView.redBall1.state = (NSUInteger) [states[0] integerValue];
		_winningBallView.redBall2.state = (NSUInteger) [states[1] integerValue];
		_winningBallView.redBall3.state = (NSUInteger) [states[2] integerValue];
		_winningBallView.redBall4.state = (NSUInteger) [states[3] integerValue];
		_winningBallView.redBall5.state = (NSUInteger) [states[4] integerValue];
		_winningBallView.redBall6.state = (NSUInteger) [states[5] integerValue];
		_winningBallView.blueBall.state = (NSUInteger) [states[6] integerValue];
	}
}


#pragma mark - 类方法

+ (CGFloat)heightOfCellWithWidth:(CGFloat)width {
	return [WinningBallView heightOfCellWithWidth:width] / 2;
}

@end
