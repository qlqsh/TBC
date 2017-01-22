//
//  ResultCell.h
//  TwoColorBall
//
//  Created by 刘明 on 2017/1/14.
//  Copyright © 2017年 刘明. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WinningBallView.h"

@interface ResultCell : UITableViewCell

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) WinningBallView *winningBallView;

+ (CGFloat)heightOfCell;

@end
