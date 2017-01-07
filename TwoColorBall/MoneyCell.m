//
//  moneyCell.m
//  TwoColorBall
//
//  Created by 刘明 on 2016/12/28.
//  Copyright © 2016年 刘明. All rights reserved.
//

#import "MoneyCell.h"

@implementation MoneyCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        CGFloat width = kScreenWidth;
        _poolLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, width/2, 20.0f)];
        _poolLabel.text = @"奖池滚存";
        _poolLabel.textAlignment = NSTextAlignmentCenter;
        _poolLabel.font = [UIFont systemFontOfSize:16.0f];
        
        _poolMoneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 20.0f, width/2, 20.0f)];
        _poolMoneyLabel.textAlignment = NSTextAlignmentCenter;
        _poolMoneyLabel.font = [UIFont systemFontOfSize:16.0f];
        
        _salesLabel = [[UILabel alloc] initWithFrame:CGRectMake(width/2, 0.0f, width/2, 20.0f)];
        _salesLabel.text = @"全国销量";
        _salesLabel.textAlignment = NSTextAlignmentCenter;
        _salesLabel.font = [UIFont systemFontOfSize:16.0f];
        
        _salesMoneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(width/2, 20.0f, width/2, 20.0f)];
        _salesMoneyLabel.textAlignment = NSTextAlignmentCenter;
        _salesMoneyLabel.font = [UIFont systemFontOfSize:16.0f];
        
        [self.contentView addSubview:_poolLabel];
        [self.contentView addSubview:_poolMoneyLabel];
        [self.contentView addSubview:_salesLabel];
        [self.contentView addSubview:_salesMoneyLabel];
    }
    
    return self;
}

#pragma mark - 类方法
+ (CGFloat)heightOfCell {
    return 40.0f;
}

@end
