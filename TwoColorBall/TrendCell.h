//
//  TrendCell.h
//  TwoColorBall
//
//  Created by 刘明 on 2016/12/29.
//  Copyright © 2016年 刘明. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TrendBaseView.h"

@interface TrendCell : UITableViewCell <UIScrollViewDelegate>
@property (nonatomic, strong) UIScrollView *cellScrollView;
@property (nonatomic) BOOL isNotification; // 辨别自己与其它Cell
@property (nonatomic, strong) NSNotification *notification;

@property (nonatomic, strong) UIView *childView;

+ (CGFloat)heightOfCell;
+ (CGFloat)widthOfCell;

@end
