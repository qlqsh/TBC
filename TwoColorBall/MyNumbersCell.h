//
//  MyNumbersCell.h
//  TwoColorBall
//
//  Created by 刘明 on 2017/1/17.
//  Copyright © 2017年 刘明. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyNumbersCell : UITableViewCell

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) NSDictionary *numbersDictionary; // 号码字典

+ (CGFloat)heightOfCellWithNumbersDictionary:(NSDictionary *)numbersDictionary;

@end
