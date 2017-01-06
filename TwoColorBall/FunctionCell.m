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

#pragma mark - Getters
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

#pragma mark - Setters
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
        default:
            break;
    }
}

#pragma mark - 绘制子功能图标（开奖公告、走势、历史同期、统计）
// 特定位置绘制一个圆。
- (void)drawCircleWithPosition:(CGPoint)position inView:(UIView *)view {
    UIGraphicsBeginImageContext(view.bounds.size);
    UIBezierPath *circlePath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(position.x, position.y, view.frame.size.width/10, view.frame.size.height/10)];
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
    double centerX = iconView.frame.size.width/2;
    double centerY = iconView.frame.size.height/2;
    
    UIGraphicsBeginImageContext(iconView.bounds.size);
    UIBezierPath *linePath = [UIBezierPath bezierPath];
    [linePath moveToPoint:CGPointMake(centerX, centerY)];
    [linePath addQuadCurveToPoint:CGPointMake(centerX*0.5, centerY*0.5)
                     controlPoint:CGPointMake(centerX*1/3, centerY*2/3)];
    [linePath addLineToPoint:CGPointMake(centerX*1.5, centerY*0.5)];
    [linePath addQuadCurveToPoint:CGPointMake(centerX, centerY)
                     controlPoint:CGPointMake(centerX*2-centerX*1/3, centerY*2/3)];
    [linePath addLineToPoint:CGPointMake(centerX, centerY*1.5)];
    [linePath addLineToPoint:CGPointMake(centerX*1.5, centerY*1.5)];
    [linePath addLineToPoint:CGPointMake(centerX*0.5, centerY*1.5)];
    [linePath addLineToPoint:CGPointMake(centerX, centerY*1.5)];
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
    double radius = iconView.frame.size.height/10; // 半径
    
    [self drawCircleWithPosition:CGPointMake(radius*2, radius*6.5) inView:iconView];
    [self drawCircleWithPosition:CGPointMake(radius*3.5, radius*3.5) inView:iconView];
    [self drawCircleWithPosition:CGPointMake(radius*5.5, radius*5.5) inView:iconView];
    [self drawCircleWithPosition:CGPointMake(radius*7, radius*2.5) inView:iconView];
    
    UIGraphicsBeginImageContext(iconView.bounds.size);
    UIBezierPath *linePath = [UIBezierPath bezierPath];
    [linePath moveToPoint:CGPointMake(radius*2+radius/2, radius*6.5+radius/2)];
    [linePath addLineToPoint:CGPointMake(radius*3.5+radius/2, radius*3.5+radius/2)];
    [linePath addLineToPoint:CGPointMake(radius*5.5+radius/2, radius*5.5+radius/2)];
    [linePath addLineToPoint:CGPointMake(radius*7+radius/2, radius*2.5+radius/2)];
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
    double radius = iconView.frame.size.height/2 - iconView.frame.size.height/5; // 半径
    double centerX = iconView.frame.size.height/2;
    double centerY = centerX;
    
    // 1、外部带缺口的圆样式
    UIGraphicsBeginImageContext(iconView.bounds.size);
    UIBezierPath *arcPath = [UIBezierPath bezierPath];
    [arcPath addArcWithCenter:CGPointMake(centerX, centerY)
                       radius:radius
                   startAngle:55*PI/180
                     endAngle:395*PI/180
                    clockwise:1];
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
    [linePath moveToPoint:CGPointMake(centerX, centerY*5/8)];
    [linePath addLineToPoint:CGPointMake(centerX, centerY)];
    [linePath addLineToPoint:CGPointMake(centerX+centerX*1/4, centerY+centerY*1/4)];
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
    UIView *iconView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f,
                                                                _iconView.bounds.size.width,
                                                                _iconView.bounds.size.width)];
    double radius = iconView.frame.size.height/2 - iconView.frame.size.height/5; // 半径
    double centerX = iconView.frame.size.height/2;
    double centerY = centerX;
    
    // 1、实心（3/4）圆
    UIGraphicsBeginImageContext(iconView.bounds.size);
    UIBezierPath *solidCirclePath = [UIBezierPath bezierPath];
    [solidCirclePath moveToPoint:CGPointMake(centerX, centerY)];
    [solidCirclePath addArcWithCenter:CGPointMake(centerX, centerY)
                               radius:radius
                           startAngle:360*PI/180
                             endAngle:270*PI/180
                            clockwise:1];
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
    [hollowCirclePath moveToPoint:CGPointMake(centerX+centerX*1/10, centerY-centerY*1/10)];
    [hollowCirclePath addArcWithCenter:CGPointMake(centerX+centerX*1/10, centerY-centerY*1/10)
                                radius:radius
                            startAngle:270*PI/180
                              endAngle:360*PI/180
                             clockwise:1];
    [hollowCirclePath addLineToPoint:CGPointMake(centerX+centerX*1/10, centerY-centerY*1/10)];
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

@end
