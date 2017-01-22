//
//  ConditionCell.m
//  TwoColorBall
//
//  Created by 刘明 on 2017/1/13.
//  Copyright © 2017年 刘明. All rights reserved.
//
//  样式：一行视图（箭头+条件球视图）

#define kDefaultBallWidth   40.0f // 默认球视图大小
#define kDefaultBlank       10.0f // 留白

#import "ConditionCell.h"
#import "BallView.h"

@implementation ConditionCell

// 默认初始化
- (instancetype)initWithStyle:(UITableViewCellStyle)style
			  reuseIdentifier:(NSString *)reuseIdentifier {
	if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
	}

	return self;
}


#pragma mark - 子视图

- (UIView *)arrowView {
	UIView *arrowView = [[UIView alloc] initWithFrame:CGRectMake(kDefaultBlank, kDefaultBlank, kDefaultBallWidth, kDefaultBallWidth)];
	UIGraphicsBeginImageContext(arrowView.frame.size);
	UIBezierPath *linePath = [UIBezierPath bezierPath];
	[linePath moveToPoint:CGPointMake(kDefaultBallWidth / 4, kDefaultBallWidth / 4)];
	[linePath addLineToPoint:CGPointMake(kDefaultBallWidth * 3 / 4, kDefaultBallWidth / 2)];
	[linePath addLineToPoint:CGPointMake(kDefaultBallWidth / 4, kDefaultBallWidth * 3 / 4)];
	[linePath stroke];
	UIGraphicsEndImageContext();

	CAShapeLayer *lineLayer = [CAShapeLayer layer];
	lineLayer.path = linePath.CGPath;
	lineLayer.strokeColor = kRedColor.CGColor;
	lineLayer.fillColor = [UIColor clearColor].CGColor;
	lineLayer.lineWidth = 3.0f;
	lineLayer.lineCap = kCALineCapRound;

	[arrowView.layer addSublayer:lineLayer];

	return arrowView;
}


#pragma mark - 属性获取和设置

- (void)setConditionBalls:(NSArray *)conditionBalls {
	[self.contentView addSubview:[self arrowView]];

	CGFloat positionX = kDefaultBlank + self.arrowView.frame.size.width + kDefaultBlank;
	UIView *ballsView;
	if (conditionBalls.count == 0) {
		ballsView = [[UIView alloc] initWithFrame:CGRectMake(positionX,
				kDefaultBlank,
				kDefaultBallWidth * 2,
				kDefaultBallWidth)];
		UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f,
				0.0f,
				kDefaultBallWidth * 2,
				kDefaultBallWidth)];
		textLabel.text = @"空行";
		textLabel.textAlignment = NSTextAlignmentCenter;
		textLabel.textColor = kRGBColor(230.0f, 230.0f, 230.0f);
		textLabel.font = [UIFont systemFontOfSize:20.0f];
		[ballsView addSubview:textLabel];
	} else {
		ballsView = [[UIView alloc] initWithFrame:CGRectMake(positionX,
				kDefaultBlank,
				kDefaultBallWidth * conditionBalls.count,
				kDefaultBallWidth)];
		for (NSInteger i = 0; i < conditionBalls.count; i++) {
			BallView *ballView =
					[[BallView alloc] initWithFrame:CGRectMake(0.0f + kDefaultBallWidth * i,
							0.0f,
							kDefaultBallWidth,
							kDefaultBallWidth)];
			ballView.state = 2;
			ballView.textLabel.text = conditionBalls[(NSUInteger) i];
			[ballsView addSubview:ballView];
		}
	}

	ballsView.layer.borderWidth = 0.5f;
	ballsView.layer.borderColor = kRGBColor(230.0f, 230.0f, 230.0f).CGColor;
	ballsView.layer.cornerRadius = 5.0f;

	[self.contentView addSubview:ballsView];
}


#pragma mark - 公开类方法

+ (CGFloat)heightOfCell {
	return kDefaultBallWidth + kDefaultBlank * 2;
}

@end
