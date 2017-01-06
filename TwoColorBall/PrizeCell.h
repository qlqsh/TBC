//
//  PrizeCell.h
//  TwoColorBall
//
//  Created by 刘明 on 2016/12/28.
//  Copyright © 2016年 刘明. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PrizeCell : UITableViewCell

@property (nonatomic, strong) UILabel *awardsLabel;         // 奖项
@property (nonatomic, strong) UILabel *winningAmountLabel;  // 获奖人数
@property (nonatomic, strong) UILabel *winningMoneyLabel;   // 获奖金额

+ (CGFloat)heightOfCell;

@end
