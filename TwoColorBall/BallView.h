//
//  BallView.h
//  TwoColorBall
//
//  Created by 刘明 on 2016/12/26.
//  Copyright © 2016年 刘明. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BallView : UIView

// 文字标签。球的数字内容（红：01-33、蓝：01-16）。也可以只显示普通数字内容。
@property (nonatomic, strong) UILabel *textLabel;
// 背景视图
@property (nonatomic, strong) UIView *backgroundView;

// 一些默认状态。（比如：白字红球背景）
@property (nonatomic) NSUInteger state;

@end
