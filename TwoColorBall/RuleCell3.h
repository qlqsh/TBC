//
//  RuleCell3.h
//  TwoColorBall
//
//  Created by 刘明 on 2016/12/28.
//  Copyright © 2016年 刘明. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WinningBallView;

@interface RuleCell3 : UITableViewCell

@property (nonatomic, strong) UILabel *awardLabel;
@property (nonatomic, strong) UILabel *moneyLabel;
@property (nonatomic, strong) WinningBallView *winningBallView1;
@property (nonatomic, strong) WinningBallView *winningBallView2;
@property (nonatomic, strong) WinningBallView *winningBallView3;
@property (nonatomic, strong) NSArray *states1;
@property (nonatomic, strong) NSArray *states2;
@property (nonatomic, strong) NSArray *states3;

+ (CGFloat)heightOfCellWithWidth:(CGFloat)width;

@end
