//
//  WinningCell.h
//  TwoColorBall
//
//  Created by 刘明 on 2016/12/24.
//  Copyright © 2016年 刘明. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WinningBallView;

@interface WinningCell : UITableViewCell

@property (nonatomic, strong) UILabel *termLabel;
@property (nonatomic, strong) UILabel *dateLabel;
@property (nonatomic, strong) WinningBallView *winningBallView;

+ (CGFloat)heightOfCellWithWidth:(CGFloat)width;

@end
