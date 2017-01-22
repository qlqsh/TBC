//
//  TCBFunctionCell.m
//  TwoColorBall
//
//  Created by 刘明 on 2016/12/22.
//  Copyright © 2016年 刘明. All rights reserved.
//

#import "FunctionCell.h"

@implementation FunctionCell

- (instancetype)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
	if (self) {
		self.layer.borderWidth = 0.5f;
		self.layer.borderColor = kRGBColor(230.0f, 230.0f, 230.0f).CGColor;
		self.layer.masksToBounds = YES;

		[self.contentView addSubview:self.iconView];
		[self.contentView addSubview:self.descriptionLabel];

		self.selectedBackgroundView = [[UIView alloc] initWithFrame:frame];
		self.selectedBackgroundView.backgroundColor = [UIColor groupTableViewBackgroundColor];
	}

	return self;
}


#pragma mark - 属性获取与设置

- (UILabel *)descriptionLabel {
	if (!_descriptionLabel) {
		CGFloat width = self.bounds.size.width;
		CGFloat height = (CGFloat) (self.bounds.size.height * 0.2);
		CGFloat locationY = (CGFloat) (self.bounds.size.height * 0.8);
		_descriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, locationY, width, height)];
		_descriptionLabel.textAlignment = NSTextAlignmentCenter;
		_descriptionLabel.textColor = kRGBColor(69.0f, 69.0f, 69.0f);
	}

	return _descriptionLabel;
}

- (UIView *)iconView {
	if (!_iconView) {
		CGFloat height = (CGFloat) (self.bounds.size.height * 0.8);
		CGFloat space = (CGFloat) (height * 0.1);
		CGFloat width = height - space * 2;
		height = width;
		_iconView = [[UIView alloc] initWithFrame:CGRectMake(space, space, width, height)];
		_iconView.backgroundColor = [UIColor grayColor];
		_iconView.layer.cornerRadius = _iconView.layer.frame.size.height / 2;
	}

	return _iconView;
}

- (void)setState:(NSInteger)state {
	switch (state) {
		case kIsWinning: {
			self.descriptionLabel.text = @"开奖公告";
			self.iconView.backgroundColor = kRedColor;
			[self.iconView addSubview:[self winningIconView]];
			break;
		}
		case kIsTrend: {
			self.descriptionLabel.text = @"走势图";
			self.iconView.backgroundColor = kBlueColor;
			[self.iconView addSubview:[self trendIconView]];
			break;
		}
		case kIsHistorySame: {
			self.descriptionLabel.text = @"历史同期";
			self.iconView.backgroundColor = kGreenColor;
			[self.iconView addSubview:[self historySameIconView]];
			break;
		}
		case kIsStatistics: {
			self.descriptionLabel.text = @"统计";
			self.iconView.backgroundColor = kOrangeColor;
			[self.iconView addSubview:[self statisticsIconView]];
			break;
		}
		case kIsConditionTrend: {
			self.descriptionLabel.text = @"相似走势";
			self.iconView.backgroundColor = kYellowColor;
			[self.iconView addSubview:[self conditionTrendIconView]];
			break;
		}
		case kIsCalculateMoney: {
			self.descriptionLabel.text = @"奖金计算";
			self.iconView.backgroundColor = kCyanColor;
			[self.iconView addSubview:[self claculateMoneyIconView]];
			break;
		}
		default:
			break;
	}
}


#pragma mark - 绘制子功能图标（开奖公告、走势、历史同期、统计、条件走势）

// 特定位置绘制一个圆。
- (void)drawCircleWithPosition:(CGPoint)position inView:(UIView *)view {
	UIGraphicsBeginImageContext(view.bounds.size);
	UIBezierPath *circlePath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(position.x, position.y, view.frame.size.width / 10, view.frame.size.height / 10)];
	[circlePath stroke];
	UIGraphicsEndImageContext();

	CAShapeLayer *circleLayer = [CAShapeLayer layer];
	circleLayer.path = circlePath.CGPath;
	circleLayer.strokeColor = [UIColor whiteColor].CGColor;
	circleLayer.fillColor = [UIColor whiteColor].CGColor;

	[view.layer addSublayer:circleLayer];
}

- (UIView *)winningIconView {
	UIView *iconView = [[UIView alloc] initWithFrame:_iconView.bounds];
	CGFloat centerX = iconView.frame.size.width / 2;
	CGFloat centerY = iconView.frame.size.height / 2;

	UIGraphicsBeginImageContext(iconView.bounds.size);
	UIBezierPath *linePath = [UIBezierPath bezierPath];
	[linePath moveToPoint:CGPointMake(centerX, centerY)];
	[linePath addQuadCurveToPoint:CGPointMake((CGFloat) (centerX * 0.5), (CGFloat) (centerY * 0.5))
					 controlPoint:CGPointMake(centerX * 1 / 3, centerY * 2 / 3)];
	[linePath addLineToPoint:CGPointMake((CGFloat) (centerX * 1.5), (CGFloat) (centerY * 0.5))];
	[linePath addQuadCurveToPoint:CGPointMake(centerX, centerY)
					 controlPoint:CGPointMake(centerX * 2 - centerX * 1 / 3, centerY * 2 / 3)];
	[linePath addLineToPoint:CGPointMake(centerX, (CGFloat) (centerY * 1.5))];
	[linePath addLineToPoint:CGPointMake((CGFloat) (centerX * 1.5), (CGFloat) (centerY * 1.5))];
	[linePath addLineToPoint:CGPointMake((CGFloat) (centerX * 0.5), (CGFloat) (centerY * 1.5))];
	[linePath addLineToPoint:CGPointMake(centerX, (CGFloat) (centerY * 1.5))];
	[linePath addLineToPoint:CGPointMake(centerX, centerY)];
	[linePath stroke];
	UIGraphicsEndImageContext();

	CAShapeLayer *lineLayer = [CAShapeLayer layer];
	lineLayer.path = linePath.CGPath;
	lineLayer.strokeColor = [UIColor whiteColor].CGColor;
	lineLayer.fillColor = [UIColor clearColor].CGColor;
	lineLayer.lineWidth = 2.0f;
	lineLayer.lineCap = kCALineCapRound;

	[iconView.layer addSublayer:lineLayer];

	return iconView;
}

- (UIView *)trendIconView {
	UIView *iconView = [[UIView alloc] initWithFrame:_iconView.bounds];
	CGFloat radius = iconView.frame.size.height / 10; // 半径

	[self drawCircleWithPosition:CGPointMake(radius * 2, (CGFloat) (radius * 6.5)) inView:iconView];
	[self drawCircleWithPosition:CGPointMake((CGFloat) (radius * 3.5), (CGFloat) (radius * 3.5)) inView:iconView];
	[self drawCircleWithPosition:CGPointMake((CGFloat) (radius * 5.5), (CGFloat) (radius * 5.5)) inView:iconView];
	[self drawCircleWithPosition:CGPointMake(radius * 7, (CGFloat) (radius * 2.5)) inView:iconView];

	UIGraphicsBeginImageContext(iconView.bounds.size);
	UIBezierPath *linePath = [UIBezierPath bezierPath];
	[linePath moveToPoint:CGPointMake(radius * 2 + radius / 2, (CGFloat) (radius * 6.5 + radius / 2))];
	[linePath addLineToPoint:CGPointMake((CGFloat) (radius * 3.5 + radius / 2), (CGFloat) (radius * 3.5 + radius / 2))];
	[linePath addLineToPoint:CGPointMake((CGFloat) (radius * 5.5 + radius / 2), (CGFloat) (radius * 5.5 + radius / 2))];
	[linePath addLineToPoint:CGPointMake(radius * 7 + radius / 2, (CGFloat) (radius * 2.5 + radius / 2))];
	[linePath stroke];
	UIGraphicsEndImageContext();

	CAShapeLayer *lineLayer = [CAShapeLayer layer];
	lineLayer.path = linePath.CGPath;
	lineLayer.strokeColor = [UIColor whiteColor].CGColor;
	lineLayer.fillColor = [UIColor clearColor].CGColor;
	lineLayer.lineWidth = 2.0f;
	lineLayer.lineCap = kCALineCapRound;

	[iconView.layer addSublayer:lineLayer];

	return iconView;
}

#define PI 3.14159265358979323846

- (UIView *)historySameIconView {
	UIView *iconView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f,
			_iconView.bounds.size.width,
			_iconView.bounds.size.width)];
	CGFloat radius = iconView.frame.size.height / 2 - iconView.frame.size.height / 5; // 半径
	CGFloat centerX = iconView.frame.size.height / 2;
	CGFloat centerY = centerX;

	// 1、外部带缺口的圆样式
	UIGraphicsBeginImageContext(iconView.bounds.size);
	UIBezierPath *arcPath = [UIBezierPath bezierPath];
	[arcPath addArcWithCenter:CGPointMake(centerX, centerY) radius:radius startAngle:(CGFloat) (55 * PI / 180) endAngle:(CGFloat) (395 * PI / 180) clockwise:1];
	[arcPath stroke];
	UIGraphicsEndImageContext();

	CAShapeLayer *arcLayer = [CAShapeLayer layer];
	arcLayer.path = arcPath.CGPath;
	arcLayer.strokeColor = [UIColor whiteColor].CGColor;
	arcLayer.fillColor = [UIColor clearColor].CGColor;
	arcLayer.lineWidth = 2.0f;
	arcLayer.lineCap = kCALineCapRound;

	[iconView.layer addSublayer:arcLayer];

	// 2、内部时针样式
	UIGraphicsBeginImageContext(iconView.bounds.size);
	UIBezierPath *linePath = [UIBezierPath bezierPath];
	[linePath moveToPoint:CGPointMake(centerX, centerY * 5 / 8)];
	[linePath addLineToPoint:CGPointMake(centerX, centerY)];
	[linePath addLineToPoint:CGPointMake(centerX + centerX * 1 / 4, centerY + centerY * 1 / 4)];
	[arcPath stroke];
	UIGraphicsEndImageContext();

	CAShapeLayer *lineLayer = [CAShapeLayer layer];
	lineLayer.path = linePath.CGPath;
	lineLayer.strokeColor = [UIColor whiteColor].CGColor;
	lineLayer.fillColor = [UIColor clearColor].CGColor;
	lineLayer.lineWidth = 2.0f;
	lineLayer.lineCap = kCALineCapRound;

	[iconView.layer addSublayer:lineLayer];

	return iconView;
}

- (UIView *)statisticsIconView {
	UIView *iconView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, _iconView.bounds.size.width, _iconView.bounds.size.width)];
	CGFloat radius = iconView.frame.size.height / 2 - iconView.frame.size.height / 5; // 半径
	CGFloat centerX = iconView.frame.size.height / 2;
	CGFloat centerY = centerX;

	// 1、实心（3/4）圆
	UIGraphicsBeginImageContext(iconView.bounds.size);
	UIBezierPath *solidCirclePath = [UIBezierPath bezierPath];
	[solidCirclePath moveToPoint:CGPointMake(centerX, centerY)];
	[solidCirclePath addArcWithCenter:CGPointMake(centerX, centerY) radius:radius startAngle:(CGFloat) (360 * PI / 180) endAngle:(CGFloat) (270 * PI / 180) clockwise:1];
	[solidCirclePath addLineToPoint:CGPointMake(centerX, centerY)];
	[solidCirclePath stroke];
	UIGraphicsEndImageContext();

	CAShapeLayer *solidCircleLayer = [CAShapeLayer layer];
	solidCircleLayer.path = solidCirclePath.CGPath;
	solidCircleLayer.strokeColor = [UIColor whiteColor].CGColor;
	solidCircleLayer.fillColor = [UIColor whiteColor].CGColor;
	solidCircleLayer.lineWidth = 2.0f;
	solidCircleLayer.lineCap = kCALineCapRound;

	[iconView.layer addSublayer:solidCircleLayer];

	// 2、空心（1/4）圆
	UIGraphicsBeginImageContext(iconView.bounds.size);
	UIBezierPath *hollowCirclePath = [UIBezierPath bezierPath];
	[hollowCirclePath moveToPoint:CGPointMake(centerX + centerX * 1 / 10, centerY - centerY * 1 / 10)];
	[hollowCirclePath addArcWithCenter:CGPointMake(centerX + centerX * 1 / 10, centerY - centerY * 1 / 10)
								radius:radius
							startAngle:(CGFloat) (270 * PI / 180)
							  endAngle:(CGFloat) (360 * PI / 180)
							 clockwise:1];
	[hollowCirclePath addLineToPoint:CGPointMake(centerX + centerX * 1 / 10, centerY - centerY * 1 / 10)];
	[hollowCirclePath stroke];
	UIGraphicsEndImageContext();

	CAShapeLayer *hollowCirleLayer = [CAShapeLayer layer];
	hollowCirleLayer.path = hollowCirclePath.CGPath;
	hollowCirleLayer.strokeColor = [UIColor whiteColor].CGColor;
	hollowCirleLayer.fillColor = [UIColor clearColor].CGColor;
	hollowCirleLayer.lineWidth = 2.0f;
	hollowCirleLayer.lineCap = kCALineCapRound;

	[iconView.layer addSublayer:hollowCirleLayer];

	return iconView;
}

// 九宫格样式，几个圆球。
- (UIView *)conditionTrendIconView {
	UIView *iconView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f,
			_iconView.bounds.size.width,
			_iconView.bounds.size.width)];
	CGFloat width = _iconView.bounds.size.width / 2 / 3;
	CGFloat positionX = (_iconView.bounds.size.width - width * 3) / 2;
	CGFloat positionY = positionX;

	[iconView.layer addSublayer:[self circelLayerWithFrame:CGRectMake(positionX,
			positionY,
			width,
			width)]];
	[iconView.layer addSublayer:[self circelLayerWithFrame:CGRectMake(positionX + width,
			positionY + width,
			width,
			width)]];
	[iconView.layer addSublayer:[self circelLayerWithFrame:CGRectMake(positionX,
			positionY + width * 2,
			width,
			width)]];
	[iconView.layer addSublayer:[self circelLayerWithFrame:CGRectMake(positionX + width * 2,
			positionY + width * 2,
			width,
			width)]];

	return iconView;
}

// 一个放大镜（🔍），里面是软妹币（¥）符号
- (UIView *)claculateMoneyIconView {
	UIView *iconView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f,
			_iconView.bounds.size.width,
			_iconView.bounds.size.width)];
	// 1、放大镜
	CGFloat radius = iconView.frame.size.width * 3 / 5 * 4 / 5 / 2;
	CGFloat centerX = iconView.frame.size.width * 1 / 5 + radius;
	CGFloat centerY = centerX;
	UIGraphicsBeginImageContext(iconView.bounds.size);
	UIBezierPath *magnifierPath = [UIBezierPath bezierPath];
	[magnifierPath moveToPoint:CGPointMake(centerX, centerY)];
	[magnifierPath addArcWithCenter:CGPointMake(centerX, centerY)
							 radius:radius
						 startAngle:(CGFloat) (45 * PI / 180)
						   endAngle:(CGFloat) (405 * PI / 180)
						  clockwise:1];
	[magnifierPath addLineToPoint:CGPointMake(iconView.frame.size.width * 4 / 5,
			iconView.frame.size.width * 4 / 5)];
	[magnifierPath stroke];
	UIGraphicsEndImageContext();

	CAShapeLayer *magnifierLayer = [CAShapeLayer layer];
	magnifierLayer.path = magnifierPath.CGPath;
	magnifierLayer.strokeColor = [UIColor whiteColor].CGColor;
	magnifierLayer.fillColor = [UIColor whiteColor].CGColor;
	magnifierLayer.lineWidth = 4.0f;
	magnifierLayer.lineCap = kCALineCapRound;

	[iconView.layer addSublayer:magnifierLayer];

	// 软妹币符号
	UILabel *moneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(centerX - radius,
			centerY - radius,
			radius * 2,
			radius * 2)];
	moneyLabel.text = @"¥";
	moneyLabel.textAlignment = NSTextAlignmentCenter;
	moneyLabel.textColor = kCyanColor;
	moneyLabel.font = [UIFont systemFontOfSize:50.0f * kScreenWidth / 320.0f];
	[iconView addSubview:moneyLabel];

	return iconView;
}

- (CAShapeLayer *)circelLayerWithFrame:(CGRect)frame {
	UIGraphicsBeginImageContext(frame.size);
	UIBezierPath *circle = [UIBezierPath bezierPathWithOvalInRect:frame];
	UIGraphicsEndImageContext();

	CAShapeLayer *circleLayer = [CAShapeLayer layer];
	circleLayer.path = circle.CGPath;
	circleLayer.fillColor = [UIColor whiteColor].CGColor;

	return circleLayer;
}

@end
