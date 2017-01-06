//
//  StatisticsManager.m
//  TwoColorBall
//
//  Created by 刘明 on 2016/12/15.
//  Copyright © 2016年 刘明. All rights reserved.
//

#import "StatisticsManager.h"
#import "DataManager.h"
#import "SimpleWinning.h"
#import "NumberCombinations.h"
#import "Winning.h"
#import "CommonMethod.h"

@implementation StatisticsManager

#pragma mark - 单例
+ (StatisticsManager *)sharedData {
    static StatisticsManager *sharedStatisticsManagerInstance = nil;
    
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedStatisticsManagerInstance = [[self alloc] init];
    });
    
    return sharedStatisticsManagerInstance;
}

- (instancetype)init {
    if (self = [super init]) {
        DataManager *dataManager = [DataManager sharedManager];
        NSArray *allWinning = [dataManager readAllWinningListInFile];
        
        NSMutableArray *allWinningData = [NSMutableArray arrayWithCapacity:allWinning.count];
        for (Winning *winning in allWinning) {
            // 期号、红球数组、蓝球、日期。组成一个类。
            SimpleWinning *simpleWinning = [[SimpleWinning alloc] initWithTerm:winning.term
                                                                       andReds:winning.reds
                                                                      andBlues:winning.blues
                                                                       andDate:winning.date];
            [allWinningData addObject:simpleWinning];
        }
        
        _allWinning = [allWinningData copy];
    }
    
    return self;
}

// 排序集
- (NSArray *)sortCountedSet:(NSCountedSet *)countedSet {
    NSMutableArray *sortArray = [NSMutableArray arrayWithCapacity:33];
    [countedSet enumerateObjectsUsingBlock:^(id _Nonnull obj, BOOL *_Nonnull stop) {
        NumberCombinations *numberCombinations = [[NumberCombinations alloc] initWithString:obj];
        numberCombinations.showNumber = [countedSet countForObject:obj];
        [sortArray addObject:numberCombinations];
    }];
    
    [sortArray sortUsingComparator:^NSComparisonResult(id _Nonnull obj1, id _Nonnull obj2) {
        NumberCombinations *numberCombinations1 = (NumberCombinations *) obj1;
        NumberCombinations *numberCombinations2 = (NumberCombinations *) obj2;
        return [numberCombinations1 compare:numberCombinations2];
    }];
    
    return [sortArray copy];
}

- (NSArray *)subArrayUseCount:(NSUInteger)count {
    if (count <= 0 || count > _allWinning.count) {
        return _allWinning;
    }
    return [_allWinning subarrayWithRange:NSMakeRange(0, count)];
}

#pragma mark - 统计（红、红3区、蓝、蓝3路、头、尾、和值范围、连号概率）
- (NSArray *)redCountInWinningCount:(NSUInteger)count {
    NSArray *subWinnings = [self subArrayUseCount:count];
    NSMutableArray *reds = [NSMutableArray arrayWithCapacity:subWinnings.count];
    for (SimpleWinning *simpleWinning in subWinnings) {
        [reds addObjectsFromArray:simpleWinning.reds.numbers];
    }
    
    NSCountedSet *redsSet = [[NSCountedSet alloc] initWithCapacity:33];
    for (NSString *red in reds) {
        [redsSet addObject:red];
    }
    
    return [self sortCountedSet:redsSet];
}

- (NSArray *)blueCountInWinningCount:(NSUInteger)count {
    NSArray *subWinnings = [self subArrayUseCount:count];
    NSMutableArray *blues = [NSMutableArray arrayWithCapacity:subWinnings.count];
    for (SimpleWinning *simpleWinning in subWinnings) {
        [blues addObjectsFromArray:simpleWinning.blues.numbers];
    }
    
    NSCountedSet *bluesSet = [[NSCountedSet alloc] initWithCapacity:16];
    for (NSString *blue in blues) {
        [bluesSet addObject:blue];
    }
    
    return [self sortCountedSet:bluesSet];
}

- (NSArray *)headCountInWinningCount:(NSUInteger)count {
    NSArray *subWinnings = [self subArrayUseCount:count];
    NSCountedSet *headCountedSet = [NSCountedSet setWithCapacity:33];
    for (SimpleWinning *simpleWinning in subWinnings) {
        NSString *head = [simpleWinning.reds.numbers firstObject];
        [headCountedSet addObject:head];
    }
    
    return [self sortCountedSet:headCountedSet];
}

- (NSArray *)tailCountInWinningCount:(NSUInteger)count {
    NSArray *subWinnings = [self subArrayUseCount:count];
    NSCountedSet *tailCountedSet = [NSCountedSet setWithCapacity:33];
    for (SimpleWinning *simpleWinning in subWinnings) {
        NSString *tail = [simpleWinning.reds.numbers lastObject];
        [tailCountedSet addObject:tail];
    }
    
    return [self sortCountedSet:tailCountedSet];
}

- (NSDictionary *)valueOfSumInWinningCount:(NSUInteger)count {
    NSArray *subWinnings = [self subArrayUseCount:count];
    NSUInteger range_21_60 = 0;
    NSUInteger range_61_80 = 0;
    NSUInteger range_81_100 = 0;
    NSUInteger range_101_120 = 0;
    NSUInteger range_121_140 = 0;
    NSUInteger range_141_183 = 0;
    
    for (SimpleWinning *simpleWinning in subWinnings) {
        NSArray *reds = simpleWinning.reds.numbers;
        NSUInteger total = 0;
        for (NSString *red in reds) {
            total += [red integerValue];
        }
        if (total > 140) {
            range_141_183 += 1;
        } else if (total > 120) {
            range_121_140 += 1;
        } else if (total > 100) {
            range_101_120 += 1;
        } else if (total > 80) {
            range_81_100 += 1;
        } else if (total > 60) {
            range_61_80 += 1;
        } else {
            range_21_60 += 1;
        }
    }
    
    return @{ @"other":@(range_21_60+range_141_183),
              @"range_61_80":@(range_61_80),
              @"range_81_100":@(range_81_100),
              @"range_101_120":@(range_101_120),
              @"range_121_140":@(range_121_140)
              };
}

- (NSDictionary *)continuousCountInWinningCount:(NSUInteger)count {
    NSArray *subWinnings = [self subArrayUseCount:count];
    NSUInteger continuous_0 = 0; // 没有连号
    NSUInteger continuous_1 = 0; // 1个连号
    NSUInteger continuous_2 = 0;
    NSUInteger continuous_3 = 0;
    NSUInteger continuous_4 = 0;
    NSUInteger continuous_5 = 0; // 最多5连号，6个球
    for (SimpleWinning *simpleWinning in subWinnings) {
        NSArray *reds = simpleWinning.reds.numbers;
        NSInteger previous = -1;
        NSUInteger continuous = 0;
        for (NSString *red in reds) {
            if ([red integerValue] - previous == 1) { // 连号
                continuous += 1;
            }
            previous = [red integerValue];
        }
        switch (continuous) {
            case 0:
                continuous_0++;
                break;
            case 1:
                continuous_1++;
                break;
            case 2:
                continuous_2++;
                break;
            case 3:
                continuous_3++;
                break;
            case 4:
                continuous_4++;
                break;
            case 5:
                continuous_5++;
                break;
            default:
                break;
        }
    }
    
    return @{ @"continuous_0":@(continuous_0),
              @"continuous_1":@(continuous_1),
              @"continuous_2":@(continuous_2),
              @"other":@(continuous_3+continuous_4+continuous_5),
              };
}

- (NSDictionary *)redThreeAreaCountInWinningCount:(NSUInteger)count {
    NSUInteger total_01_11 = 0;
    NSUInteger total_12_22 = 0;
    NSUInteger total_23_33 = 0;
    for (NumberCombinations *numberCombinations in [self redCountInWinningCount:count]) {
        NSUInteger number = [numberCombinations.toString integerValue];
        if (number < 12) { // 01-11
            total_01_11 += numberCombinations.showNumber;
        } else if (number < 23) { // 12-22
            total_12_22 += numberCombinations.showNumber;
        } else { // 23-33
            total_23_33 += numberCombinations.showNumber;
        }
    }
    
    return @{ @"redOneArea":@(total_01_11),
              @"redTwoArea":@(total_12_22),
              @"redThreeArea":@(total_23_33)
              };
}

- (NSDictionary *)blueRemainderCountInWinningCount:(NSUInteger)count {
    NSUInteger total_0 = 0;
    NSUInteger total_1 = 0;
    NSUInteger total_2 = 0;
    for (NumberCombinations *numberCombinations in [self blueCountInWinningCount:count]) {
        NSUInteger number = [numberCombinations.toString integerValue];
        if (number%3 == 0) {
            total_0 += numberCombinations.showNumber;
        } else if (number%3 == 1) {
            total_1 += numberCombinations.showNumber;
        } else {
            total_2 += numberCombinations.showNumber;
        }
    }
    
    return @{ @"blue0":@(total_0),
              @"blue1":@(total_1),
              @"blue2":@(total_2)
              };
}


#pragma mark - 历史同期

/**
 *  历史同期。逆序(新->旧)。默认10期。目前只提供年的。
 *
 *  @return 根据年的不同找出历史出号。
 *
 *  高级：可以通过设置，选择同期(年、月、周、指定期数(10、20等))。月、周有难度，估计会比较难做。
 */
- (NSArray *)historySame {
    SimpleWinning *firstWinningData = [_allWinning firstObject];
    
    // 这里需要判断是+1，还是新的1年，重新回到001。
    NSUInteger termNumber = (NSUInteger) [[firstWinningData.term substringFromIndex:4] integerValue];
    if (termNumber >= 152) { // 最后的几期
        NSArray *dateArray = [firstWinningData.date componentsSeparatedByString:@"-"];
        NSUInteger day = (NSUInteger) [[dateArray lastObject] integerValue];
        if (day + 2 > 31) { // 新的一年
            termNumber = 1;
        } else {
            if ((day + 3 > 31) && [CommonMethod calendarWeekdayWithString:firstWinningData.date] == 5) {
                termNumber = 1;
            } else {
                termNumber = termNumber + 1;
            }
        }
    } else {
        termNumber = termNumber + 1;
    }
    
    NSString *termString;
    if (termNumber > 100) {
        termString = [NSString stringWithFormat:@"%lu", (unsigned long)termNumber];
    } else if (termNumber > 10) {
        termString = [NSString stringWithFormat:@"0%lu", (unsigned long)termNumber];
    } else {
        termString = [NSString stringWithFormat:@"00%lu", (unsigned long)termNumber];
    }
    
    // 历史同期
    NSMutableArray *historySame = [NSMutableArray array];
    for (SimpleWinning *simpleWinning in _allWinning) {
        if ([[simpleWinning.term substringFromIndex:4] isEqualToString:termString]) {
            [historySame addObject:simpleWinning];
        }
    }
    
    return historySame;
}

@end
