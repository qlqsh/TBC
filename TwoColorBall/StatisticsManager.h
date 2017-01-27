//
//  StatisticsManager.h
//  TwoColorBall
//
//  Created by 刘明 on 2016/12/27.
//  Copyright © 2016年 刘明. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Winning;

@interface StatisticsManager : NSObject

@property (nonatomic, strong) NSArray *allWinning;

#pragma mark - 统计（红、蓝、头、尾、和值范围、连号概率、红3区、蓝余3）

- (NSArray *)redCountInWinningCount:(NSUInteger)count;    // 红球出现情况
- (NSArray *)blueCountInWinningCount:(NSUInteger)count;   // 蓝球出现情况
- (NSArray *)headCountInWinningCount:(NSUInteger)count;   // 头号出现情况
- (NSArray *)tailCountInWinningCount:(NSUInteger)count;   // 尾号出现情况

- (NSDictionary *)valueOfSumInWinningCount:(NSUInteger)count;           // 和值（每差值10为1档）范围
- (NSDictionary *)continuousCountInWinningCount:(NSUInteger)count;      // 连号情况
- (NSDictionary *)redThreeAreaCountInWinningCount:(NSUInteger)count;    // 红3区情况
- (NSDictionary *)blueRemainderCountInWinningCount:(NSUInteger)count;   // 蓝余3情况


#pragma mark - 历史同期

- (NSArray *)historySame;


#pragma mark - 历史相似走势

- (NSArray *)nextWinningDataWithNumberCombinations:(NSArray *)multipleNumberCombinations;


#pragma mark - 历史相似走势（基础统计）
- (NSArray *)conditionTrendBaseStatistics;


#pragma mark - 奖金计算

- (NSString *)calculateMoneyWithCurrentWinning:(Winning *)currentWinning andMyNumbers:(NSArray *)myNumbers;

@end
