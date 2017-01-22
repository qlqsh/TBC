//
//  Winning.h
//  TwoColorBall
//
//  Created by 刘明 on 2016/12/22.
//  Copyright © 2016年 刘明. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * 一条获奖信息。
 */
@interface Winning : NSObject <NSCoding>

@property (nonatomic, copy) NSString *date;      // 时间
@property (nonatomic, copy) NSString *week;      // 星期几（由时间计算）
@property (nonatomic, copy) NSString *term;      // 期号
@property (nonatomic, strong) NSArray *reds;     // 红球
@property (nonatomic, strong) NSArray *blues;    // 蓝球

/**
 * key: pool、sales
 */
@property (nonatomic, strong) NSDictionary *moneyState;

/**
 * key: firstAmount、firstMoney、secondAmount、secondMoney、thirdAmount、thirdMoney
 */
@property (nonatomic, strong) NSDictionary *prizeState;


#pragma mark - 初始化对象

- (instancetype)initWithContent:(NSString *)htmlContent;

@end
