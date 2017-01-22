//
//  TrendView.h
//  TwoColorBall
//
//  Created by 刘明 on 2016/12/31.
//  Copyright © 2016年 刘明. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TrendBaseView.h"

@interface TrendView : UIView

@property (nonatomic, strong) UILabel *termLabel;
@property (nonatomic, strong) TrendBaseView *trendBaseView;
@property (nonatomic) NSUInteger state;

@end
