//
//  RuleCell2.m
//  TwoColorBall
//
//  Created by 刘明 on 2016/12/28.
//  Copyright © 2016年 刘明. All rights reserved.
//

#import "RuleCell2.h"
#import "WinningBallView.h"
#import "BallView.h"

@implementation RuleCell2

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
		CGFloat width = kScreenWidth;
		CGFloat height = [RuleCell2 heightOfCellWithWidth:width] / 2;
		_awardLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, (CGFloat) (width * 0.2), height)];
		_awardLabel.textAlignment = NSTextAlignmentCenter;
		_awardLabel.font = [UIFont systemFontOfSize:10.0f];
		[self.contentView addSubview:_awardLabel];

		_moneyLabel = [[UILabel alloc] initWithFrame:CGRectMake((CGFloat) (width * 0.2), 0.0f,
				(CGFloat) (width * 0.3), height)];
		_moneyLabel.textAlignment = NSTextAlignmentCenter;
		_moneyLabel.font = [UIFont systemFontOfSize:10.0f];
		[self.contentView addSubview:_moneyLabel];

		_winningBallView1 = [[WinningBallView alloc] initWithFrame:CGRectMake((CGFloat) (width * 0.5),
				0.0f, (CGFloat) (width * 0.5), height)];
		[self.contentView addSubview:_winningBallView1];

		_winningBallView2 = [[WinningBallView alloc] initWithFrame:CGRectMake((CGFloat) (width * 0.5),
				height, (CGFloat) (width * 0.5), height)];
		[self.contentView addSubview:_winningBallView2];
	}

	return self;
}


#pragma mark - 规则模式的特殊球状态

- (void)setStates1:(NSArray *)states1 {
	if (states1.count == 7) {
		_winningBallView1.redBall1.state = (NSUInteger) [states1[0] integerValue];
		_winningBallView1.redBall2.state = (NSUInteger) [states1[1] integerValue];
		_winningBallView1.redBall3.state = (NSUInteger) [states1[2] integerValue];
		_winningBallView1.redBall4.state = (NSUInteger) [states1[3] integerValue];
		_winningBallView1.redBall5.state = (NSUInteger) [states1[4] integerValue];
		_winningBallView1.redBall6.state = (NSUInteger) [states1[5] integerValue];
		_winningBallView1.blueBall.state = (NSUInteger) [states1[6] integerValue];
	}
}

- (void)setStates2:(NSArray *)states2 {
	if (states2.count == 7) {
		_winningBallView2.redBall1.state = (NSUInteger) [states2[0] integerValue];
		_winningBallView2.redBall2.state = (NSUInteger) [states2[1] integerValue];
		_winningBallView2.redBall3.state = (NSUInteger) [states2[2] integerValue];
		_winningBallView2.redBall4.state = (NSUInteger) [states2[3] integerValue];
		_winningBallView2.redBall5.state = (NSUInteger) [states2[4] integerValue];
		_winningBallView2.redBall6.state = (NSUInteger) [states2[5] integerValue];
		_winningBallView2.blueBall.state = (NSUInteger) [states2[6] integerValue];
	}
}


#pragma mark - 类方法

+ (CGFloat)heightOfCellWithWidth:(CGFloat)width {
	return [WinningBallView heightOfCellWithWidth:width];
}

@end
