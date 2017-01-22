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
#import "BallList.h"

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

	return @{@"other": @(range_21_60 + range_141_183),
			@"range_61_80": @(range_61_80),
			@"range_81_100": @(range_81_100),
			@"range_101_120": @(range_101_120),
			@"range_121_140": @(range_121_140)
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

	return @{@"continuous_0": @(continuous_0),
			@"continuous_1": @(continuous_1),
			@"continuous_2": @(continuous_2),
			@"other": @(continuous_3 + continuous_4 + continuous_5),
	};
}

- (NSDictionary *)redThreeAreaCountInWinningCount:(NSUInteger)count {
	NSUInteger total_01_11 = 0;
	NSUInteger total_12_22 = 0;
	NSUInteger total_23_33 = 0;
	for (NumberCombinations *numberCombinations in [self redCountInWinningCount:count]) {
		NSInteger number = [numberCombinations.toString integerValue];
		if (number < 12) { // 01-11
			total_01_11 += numberCombinations.showNumber;
		} else if (number < 23) { // 12-22
			total_12_22 += numberCombinations.showNumber;
		} else { // 23-33
			total_23_33 += numberCombinations.showNumber;
		}
	}

	return @{@"redOneArea": @(total_01_11),
			@"redTwoArea": @(total_12_22),
			@"redThreeArea": @(total_23_33)
	};
}

- (NSDictionary *)blueRemainderCountInWinningCount:(NSUInteger)count {
	NSUInteger total_0 = 0;
	NSUInteger total_1 = 0;
	NSUInteger total_2 = 0;
	for (NumberCombinations *numberCombinations in [self blueCountInWinningCount:count]) {
		NSInteger number = [numberCombinations.toString integerValue];
		if (number % 3 == 0) {
			total_0 += numberCombinations.showNumber;
		} else if (number % 3 == 1) {
			total_1 += numberCombinations.showNumber;
		} else {
			total_2 += numberCombinations.showNumber;
		}
	}

	return @{@"blue0": @(total_0),
			@"blue1": @(total_1),
			@"blue2": @(total_2)
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
	if (termNumber >= 100) {
		termString = [NSString stringWithFormat:@"%lu", (unsigned long) termNumber];
	} else if (termNumber >= 10) {
		termString = [NSString stringWithFormat:@"0%lu", (unsigned long) termNumber];
	} else {
		termString = [NSString stringWithFormat:@"00%lu", (unsigned long) termNumber];
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


#pragma mark - 历史相似走势

// 包含（多重）指定数字的下一期获奖数据。可以说是从以往的走势图形中寻找与当前走势类似的图形，这个是立体的。
// 样式：@[ @"06", @"06 08" ]，需要第一个获奖列表包含06，第二个获奖列表包含06 08，然后找出第3个获奖列表。
- (NSArray *)nextWinningDataWithNumberCombinations:(NSArray *)multipleNumberCombinations {
	// 先把所有获奖数据拷贝到一个字典。
	NSMutableDictionary *allWinningDictionary =
			[NSMutableDictionary dictionaryWithCapacity:_allWinning.count];
	NSMutableArray *locationArray = [NSMutableArray arrayWithCapacity:_allWinning.count];
	NSUInteger location = 0;

	// 逆序一下，因为获奖信息保存的方式是从“新->旧”，现在需要转换到从“旧->新”。
	NSArray *reverseAllWinning = [[_allWinning reverseObjectEnumerator] allObjects];
	for (SimpleWinning *simpleWinning in reverseAllWinning) {
		allWinningDictionary[@(location)] = simpleWinning;
		[locationArray addObject:@(location)];
		location += 1;
	}

	NSArray *resultArray = [locationArray copy];
	for (NSArray *numberCombinationsArray in multipleNumberCombinations) {
		NSString *numberCombinations;
		if (numberCombinationsArray.count == 0) {
			numberCombinations = @"";
		} else {
			NSMutableString *numberMutableString = [NSMutableString stringWithCapacity:1];
			for (NSString *number in numberCombinationsArray) {
				[numberMutableString appendFormat:@"%@ ", number];
			}
			numberCombinations = [numberMutableString stringByTrimmingCharactersInSet:
															  [NSCharacterSet whitespaceAndNewlineCharacterSet]];
		}

		resultArray =
				[self winningDataLocationWithContainNumberCombinations:numberCombinations
													  andLocationArray:resultArray
											   andAllWinningDictionary:[allWinningDictionary copy]];
	}

	// 根据符合条件的数组下标获取获奖数组列表。
	NSMutableArray *winningDataWithNumberCombinations = [NSMutableArray array];
	for (NSNumber *number in resultArray) {
		location = (NSUInteger) [number integerValue];
		SimpleWinning *simpleWinning = allWinningDictionary[@(location)];
		if (simpleWinning != nil) {
			[winningDataWithNumberCombinations addObject:simpleWinning];
		}
	}

	return [winningDataWithNumberCombinations copy];
}

/**
 *  符合条件的获奖数据的坐标。
 *
 *  @param numberCombinations   条件。比如：“06”，指获奖号码中包含“06”；“06 08”，指获奖号码中必须同时包含“06”和“08”。依此类推。
 *  @param locationArray        需要检索的获奖数据的坐标列表。
 *  @param allWinningDictionary 所有获奖数据字典。可以通过坐标来获取获奖数据。
 *  @return 符合条件的获奖数据的坐标数组。
 */
- (NSArray *)winningDataLocationWithContainNumberCombinations:(NSString *)numberCombinations
											 andLocationArray:(NSArray *)locationArray
									  andAllWinningDictionary:(NSDictionary *)allWinningDictionary {
	// 条件为空，说明是无条件隔1期。
	BOOL unconditional = NO;
	if ([numberCombinations isEqualToString:@""]) {
		unconditional = YES;
	}

	NSMutableArray *winningDataLocation = [NSMutableArray array];
	// 遍历坐标。根据坐标找到获奖数据。
	for (NSNumber *number in locationArray) {
		NSUInteger location = (NSUInteger) [number integerValue];
		SimpleWinning *simpleWinning = allWinningDictionary[@(location)];
		if ([simpleWinning contains:numberCombinations] || unconditional) {
			[winningDataLocation addObject:@(location + 1)];
		}
	}

	return [winningDataLocation copy];
}


#pragma mark - 奖金计算

- (NSString *)calculateMoneyWithCurrentWinning:(Winning *)currentWinning
								  andMyNumbers:(NSArray *)myNumbers {
	NSMutableString *winningDescription = [NSMutableString string];
	NSMutableDictionary *awardDict = [NSMutableDictionary dictionaryWithCapacity:6];
	[awardDict setValue:@(0) forKey:@"first"];
	[awardDict setValue:@(0) forKey:@"second"];
	[awardDict setValue:@(0) forKey:@"third"];
	[awardDict setValue:@(0) forKey:@"fourth"];
	[awardDict setValue:@(0) forKey:@"fifth"];
	[awardDict setValue:@(0) forKey:@"sixth"];
	for (NSDictionary *myNumber in myNumbers) {
		NSDictionary *newAwardDict = [self calculateMoneyWithCurrentWinning:currentWinning
																andMyNumber:myNumber];
		NSArray *allKeys = [newAwardDict allKeys];
		for (NSString *key in allKeys) {
			NSInteger newValue = [newAwardDict[key] integerValue] + [awardDict[key] integerValue];
			[awardDict removeObjectForKey:key];
			[awardDict setValue:@(newValue) forKey:key];
		}
	}

	NSInteger firstMoney = [[self removeSpecialCharacter:@","
										   andNeedString:currentWinning.prizeState[@"firstMoney"]] integerValue];
	NSInteger secondMoney = [[self removeSpecialCharacter:@","
											andNeedString:currentWinning.prizeState[@"secondMoney"]] integerValue];
	NSInteger thirdMoney = [[self removeSpecialCharacter:@","
										   andNeedString:currentWinning.prizeState[@"thirdMoney"]] integerValue];
	NSInteger fourthMoney = 200;
	NSInteger fifthMoney = 10;
	NSInteger sixthMoney = 5;
	NSInteger totalMoney = 0;
	NSMutableString *awardDescription = [NSMutableString string];
	if ([awardDict[@"first"] integerValue] > 0) {
		NSInteger first = [awardDict[@"first"] integerValue];
		totalMoney += first * firstMoney;
		[awardDescription appendFormat:@"一等奖 %ld 注\n", (long) first];
	}
	if ([awardDict[@"second"] integerValue] > 0) {
		NSInteger second = [awardDict[@"second"] integerValue];
		totalMoney += second * secondMoney;
		[awardDescription appendFormat:@"二等奖 %ld 注\n", (long) second];
	}
	if ([awardDict[@"third"] integerValue] > 0) {
		NSInteger third = [awardDict[@"third"] integerValue];
		totalMoney += third * thirdMoney;
		[awardDescription appendFormat:@"三等奖 %ld 注\n", (long) third];
	}
	if ([awardDict[@"fourth"] integerValue] > 0) {
		NSInteger fourth = [awardDict[@"fourth"] integerValue];
		totalMoney += fourth * fourthMoney;
		[awardDescription appendFormat:@"四等奖 %ld 注\n", (long) fourth];
	}
	if ([awardDict[@"fifth"] integerValue] > 0) {
		NSInteger fifth = [awardDict[@"fifth"] integerValue];
		totalMoney += fifth * fifthMoney;
		[awardDescription appendFormat:@"五等奖 %ld 注\n", (long) fifth];
	}
	if ([awardDict[@"sixth"] integerValue] > 0) {
		NSInteger sixth = [awardDict[@"sixth"] integerValue];
		totalMoney += sixth * sixthMoney;
		[awardDescription appendFormat:@"六等奖 %ld 注\n", (long) sixth];
	}

	if (awardDescription.length > 0) { // 中奖了
		[winningDescription appendString:@"恭喜中奖！！！\n"];
		[winningDescription appendString:awardDescription];
		[winningDescription appendFormat:@"共计中奖 %ld 元", (long) totalMoney];
	} else {
		[winningDescription appendString:@"很遗憾您没有中奖，再接再厉吧！"];
	}

	return winningDescription;
}

- (NSString *)removeSpecialCharacter:(NSString *)character
					   andNeedString:(NSString *)needString {
	NSArray *stringArray = [needString componentsSeparatedByString:character];
	NSMutableString *resultString = [NSMutableString string];
	for (NSString *string in stringArray) {
		[resultString appendString:string];
	}

	return [resultString copy];
}

#define kIsNo       0   // 没有中奖
#define kIsFirst    1   // 1等奖
#define kIsSecond   2   // 2等奖
#define kIsThird    3
#define kIsFourth   4
#define kIsFifth    5
#define kIsSixth    6

- (NSDictionary *)calculateMoneyWithCurrentWinning:(Winning *)currentWinning
									   andMyNumber:(NSDictionary *)myNumber {
	NSMutableDictionary *awardDict = [NSMutableDictionary dictionaryWithCapacity:6];
	NSArray *reds = myNumber[@"reds"];
	NSArray *blues = myNumber[@"blues"];
	BallList *ballList = [[BallList alloc] initWithBalls:reds];
	NSArray *balls = [ballList combining:6];
	for (NSArray *redList in balls) {
		for (NSString *blue in blues) {
			NSInteger award = [self awardsWithAwardWinningNumber:@{
									   @"reds": currentWinning.reds,
									   @"blues": currentWinning.blues}
													 andMyNumber:@{
															 @"reds": redList,
															 @"blues": blue}];
			switch (award) {
				case kIsFirst: {
					[self updateAwardDictionaryWithDictionary:awardDict
										 andUpdateValueUseKey:@"first"];
					break;
				}
				case kIsSecond: {
					[self updateAwardDictionaryWithDictionary:awardDict
										 andUpdateValueUseKey:@"second"];
					break;
				}
				case kIsThird: {
					[self updateAwardDictionaryWithDictionary:awardDict
										 andUpdateValueUseKey:@"third"];
					break;
				}
				case kIsFourth: {
					[self updateAwardDictionaryWithDictionary:awardDict
										 andUpdateValueUseKey:@"fourth"];
					break;
				}
				case kIsFifth: {
					[self updateAwardDictionaryWithDictionary:awardDict
										 andUpdateValueUseKey:@"fifth"];
					break;
				}
				case kIsSixth: {
					[self updateAwardDictionaryWithDictionary:awardDict
										 andUpdateValueUseKey:@"sixth"];
					break;
				}
				case kIsNo:
				default:
					break;
			}
		}
	}

	return awardDict;
}

// 更新单注的中奖情况
- (void)updateAwardDictionaryWithDictionary:(NSMutableDictionary *)awardDict
					   andUpdateValueUseKey:(NSString *)key {
	NSInteger newValue = 1;
	if ([[awardDict allKeys] containsObject:key]) {
		newValue = [awardDict[key] integerValue] + 1;
		[awardDict removeObjectForKey:key];
	}
	[awardDict setValue:@(newValue) forKey:key];
}

// 判断一注号码是获得了几等奖
- (NSInteger)awardsWithAwardWinningNumber:(NSDictionary *)awardWinningNumber
							  andMyNumber:(NSDictionary *)myNumber {
	// 判断蓝球是否中了
	BOOL hasBlueBall = FALSE;
	for (NSString *blue in awardWinningNumber[@"blues"]) {
		if ([blue isEqualToString:myNumber[@"blues"]]) {
			hasBlueBall = TRUE;
		}
	}
	// 判断中了几个红球
	NSInteger hasRedCount = 0;
	for (NSString *red in awardWinningNumber[@"reds"]) {
		for (NSString *myRed in [myNumber[@"reds"] componentsSeparatedByString:@" "]) {
			if ([red isEqualToString:myRed]) {
				hasRedCount += 1;
			}
		}
	}

	// 判断是几等奖、1等奖
	if (hasRedCount == 6 && hasBlueBall) {
		return kIsFirst;
	}

	// 2等奖
	if (hasRedCount == 6) {
		return kIsSecond;
	}

	// 3等奖
	if (hasRedCount == 5 && hasBlueBall) {
		return kIsThird;
	}

	// 4等奖
	if (hasRedCount == 5) {
		return kIsFourth;
	}
	if (hasRedCount == 4 && hasBlueBall) {
		return kIsFourth;
	}

	// 5等奖
	if (hasRedCount == 4) {
		return kIsFifth;
	}
	if (hasRedCount == 3 && hasBlueBall) {
		return kIsFifth;
	}

	// 6等奖
	if (hasBlueBall) {
		return kIsSixth;
	}

	return kIsNo;
}

@end
