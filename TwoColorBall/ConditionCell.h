//
//  ConditionCell.h
//  TwoColorBall
//
//  Created by 刘明 on 2017/1/13.
//  Copyright © 2017年 刘明. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ConditionCell : UITableViewCell

@property (nonatomic, strong) NSArray *conditionBalls; // 条件球数组

+ (CGFloat)heightOfCell;

@end
