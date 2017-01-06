//
//  RuleCell1.h
//  TwoColorBall
//
//  Created by 刘明 on 2016/12/28.
//  Copyright © 2016年 刘明. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WinningBallView;

@interface RuleCell1 : UITableViewCell

@property (nonatomic, strong) UILabel *awardLabel;
@property (nonatomic, strong) UILabel *moneyLabel;
@property (nonatomic, strong) WinningBallView *winningBallView;
@property (nonatomic, strong) NSArray *states;

+ (CGFloat)heightOfCellWithWidth:(CGFloat)width;

@end
