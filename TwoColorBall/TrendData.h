//
//  TrendData.h
//  TwoColorBall
//
//  Created by 刘明 on 2016/12/29.
//  Copyright © 2016年 刘明. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TrendData : NSObject

@property(nonatomic, readonly) NSArray *allTermAndBalls;            // 期号＋遗漏码和获奖球组合成的大多重数组。
@property(nonatomic, readonly) NSArray *allWinningBallArray;        // 获奖信息数组
@property(nonatomic, readonly) NSArray *allWinningBlueBallArray;    // 所有获奖蓝球的数组
@property(nonatomic, readonly) NSArray *allWinningRedsBallArray;    // 所有获奖红球（6个红球也是一数组）的数组

#pragma mark - 单例
+ (TrendData *)sharedData;

#pragma mark - 开放方法
- (NSArray *)ballArrayWithCustomNumber:(NSUInteger)number;
- (NSArray *)redsBallArrayWithCustomNumber:(NSUInteger)number;
- (NSArray *)blueBallArrayWithCustomNumber:(NSUInteger)number;
- (NSArray *)termAndBallsWithCustomNumber:(NSUInteger)number;

#pragma mark - 统计
// 包含（出现次数数组、最大连出数组、最大遗漏数组、平均遗漏数组）4个数组的数组
- (NSArray *)statisticsArrayWithNumber:(NSUInteger)number;

@end
