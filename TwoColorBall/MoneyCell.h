//
//  moneyCell.h
//  TwoColorBall
//
//  Created by 刘明 on 2016/12/28.
//  Copyright © 2016年 刘明. All rights reserved.
//

#import <UIKit/UIKit.h>


/**
 *  奖池状况
 */
@interface MoneyCell : UITableViewCell

@property (nonatomic, strong) UILabel *poolLabel;
@property (nonatomic, strong) UILabel *poolMoneyLabel;
@property (nonatomic, strong) UILabel *salesLabel;
@property (nonatomic, strong) UILabel *salesMoneyLabel;

+ (CGFloat)heightOfCell;

@end
