//
//  SimpleWinning.h
//  TwoColorBall
//
//  Created by 刘明 on 2016/12/27.
//  Copyright © 2016年 刘明. All rights reserved.
//

#import <Foundation/Foundation.h>
@class NumberCombinations;

@interface SimpleWinning : NSObject

@property (nonatomic, copy) NSString *term; // 期号
@property (nonatomic, readonly, strong) NumberCombinations *reds;     // 红球
@property (nonatomic, readonly, strong) NumberCombinations *blues;    // 蓝球
@property (nonatomic, copy) NSString *date; // 开奖时间

- (instancetype)initWithTerm:(NSString *)term
                     andReds:(NSArray *)reds
                    andBlues:(NSArray *)blues
                     andDate:(NSString *)date;
- (BOOL)contains:(NSString *)numberString;

@end
