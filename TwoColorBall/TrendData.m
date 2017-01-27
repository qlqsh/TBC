//
//  TrendData.m
//  TwoColorBall
//
//  Created by 刘明 on 2016/12/29.
//  Copyright © 2016年 刘明. All rights reserved.
//
//  走势的数据。需要：出现次数、平均遗漏、最大遗漏、最大连出，4个统计数据。和1个遗漏数。

#import "TrendData.h"
#import "Ball.h"
#import "DataManager.h"
#import "Winning.h"

@implementation TrendData


#pragma mark - 初始化

- (instancetype)init {
	if (self = [super init]) {
		DataManager *dataManager = [[DataManager alloc] init];
		NSArray *allWinning = [dataManager readAllWinningListInFileUseReverse];
		NSUInteger count = allWinning.count;
		NSMutableArray *allWinningBallArray = [NSMutableArray arrayWithCapacity:count];
		NSMutableArray *allTerm = [NSMutableArray arrayWithCapacity:count];
		NSMutableArray *allWinningBlueBallArray = [NSMutableArray arrayWithCapacity:count];
		NSMutableArray *allWinningRedsBallArray = [NSMutableArray arrayWithCapacity:count];
		for (Winning *winning in allWinning) {
			NSMutableArray *ball = [NSMutableArray arrayWithCapacity:7];
			[ball addObjectsFromArray:winning.reds];
			[ball addObjectsFromArray:winning.blues];
			[allWinningBallArray addObject:[ball copy]];
			[allTerm addObject:winning.term];
			[allWinningBlueBallArray addObject:winning.blues];
			[allWinningRedsBallArray addObject:winning.reds];
		}

		_allWinningBallArray = [allWinningBallArray copy];
		_allWinningBlueBallArray = [allWinningBlueBallArray copy];
		_allWinningRedsBallArray = [allWinningRedsBallArray copy];

		NSArray *allBalls = [self trendAllBall];
		NSMutableArray *allTermAndBalls = [NSMutableArray arrayWithCapacity:allBalls.count];
		for (NSUInteger i = 0; i < allBalls.count; i++) {
			NSString *term = allTerm[i];
			NSArray *balls = allBalls[i];
			NSMutableArray *termAndBalls = [@[term] mutableCopy];
			[termAndBalls addObject:balls];
			[allTermAndBalls addObject:termAndBalls];
		}
		_allTermAndBalls = [allTermAndBalls copy];
	}

	return self;
}


#pragma mark - 自定义数量的数据

//- (NSArray *)ballArrayWithCustomNumber:(NSUInteger)number {
//	return [_allWinningBallArray subarrayWithRange:NSMakeRange(_allWinningBallArray.count - number, number)];
//}
//
//- (NSArray *)redsBallArrayWithCustomNumber:(NSUInteger)number {
//	return [_allWinningRedsBallArray subarrayWithRange:NSMakeRange(_allWinningRedsBallArray.count - number, number)];
//}
//
//- (NSArray *)blueBallArrayWithCustomNumber:(NSUInteger)number {
//	return [_allWinningBlueBallArray subarrayWithRange:NSMakeRange(_allWinningBlueBallArray.count - number, number)];
//}

- (NSArray *)termAndBallsWithCustomNumber:(NSUInteger)number {
	return [_allTermAndBalls subarrayWithRange:NSMakeRange(_allTermAndBalls.count - number, number)];
}


#pragma mark - 根据获奖数据，转换为一个遗漏值与获奖号码混杂的多重数组。

// 统计红球
- (NSArray *)statisticsRedBall {
	NSMutableArray *redArray = [NSMutableArray arrayWithCapacity:_allWinningRedsBallArray.count];
	for (NSArray *reds in _allWinningRedsBallArray) {
		[redArray addObject:reds];
	}

	return [self statisticsBallWithArray:[redArray copy] ballNumber:33];
}

// 统计蓝球
- (NSArray *)statisticsBlueBall {
	NSMutableArray *blueArray = [NSMutableArray arrayWithCapacity:_allWinningBlueBallArray.count];
	for (NSArray *blues in _allWinningBlueBallArray) {
		[blueArray addObject:blues];
	}

	return [self statisticsBallWithArray:[blueArray copy] ballNumber:16];
}

/**
 *  统计球的遗漏情况。
 *
 *  @param dataArray 获奖信息的部分球。比如：1个蓝球或6个红球，都放在数组里。
 *  @param number 总球数量。比如：红球是33个，蓝球是16个。如果是大乐透的话，红球是35个，蓝球是12个。
 *
 *  @return 遗漏值、获奖球混杂的数组。数组的是个2个数组嵌套的多重数组。嵌套形式是（红球）33列，存入数组，每列包括遗漏值和获奖的球。
 */
- (NSArray *)statisticsBallWithArray:(NSArray *)dataArray ballNumber:(NSUInteger)number {
	NSMutableArray *statisticsRedArray = [NSMutableArray arrayWithCapacity:number];
	for (int i = 0; i < number; ++i) {
		NSMutableArray *columnArray = [NSMutableArray arrayWithCapacity:dataArray.count];
		NSUInteger k = 1;
		for (NSUInteger j = 0; j < dataArray.count; ++j) {
			NSArray *balls = dataArray[j]; // 一组球（可能是1个蓝球，也可能是6个红球）
			NSString *ball;
			if (i >= 9) {
				ball = [NSString stringWithFormat:@"%d", i + 1];
			} else {
				ball = [NSString stringWithFormat:@"0%d", i + 1];
			}
			if (![balls containsObject:ball]) { // 球没出，累加遗漏。
				columnArray[j] = [[Ball alloc] initWithValue:k andIsBall:NO];
			} else { // 球出了，遗漏清零。
				k = 0;
				columnArray[j] = [[Ball alloc] initWithValue:(NSUInteger) [ball integerValue] andIsBall:YES];
			}
			k++;
		}
		[statisticsRedArray addObject:columnArray];
	}

	return [statisticsRedArray copy];
}

// 一个多重数组，用来保存多行的红、蓝球的遗漏和出现号码。主要使用在走势上。
- (NSArray *)trendBallGroupWithBallArray:(NSArray *)ballArray {
	NSArray *firstRowArray = ballArray[0];
	NSUInteger column = firstRowArray.count; // 列
	NSUInteger row = ballArray.count;     // 横行

	NSMutableArray *trendBallArray = [NSMutableArray arrayWithCapacity:column];
	for (int i = 0; i < column; i++) {
		[trendBallArray addObject:[NSMutableArray arrayWithCapacity:row]];
	}

	for (NSUInteger i = 0; i < row; ++i) {
		for (NSUInteger j = 0; j < column; ++j) {
			trendBallArray[j][i] = ballArray[i][j];
		}
	}

	return [trendBallArray copy];
}

// 把红球、蓝球2个数组合并。
- (NSArray *)trendAllBall {
	NSArray *redBallArray = [self trendBallGroupWithBallArray:[self statisticsRedBall]];
	NSArray *blueBallArray = [self trendBallGroupWithBallArray:[self statisticsBlueBall]];

	// 红球、蓝球获奖期数是一样。
	NSMutableArray *allBallArray = [NSMutableArray arrayWithCapacity:redBallArray.count];
	for (NSUInteger i = 0; i < redBallArray.count; i++) {
		NSMutableArray *allBalls = [NSMutableArray arrayWithArray:redBallArray[i]];
		[allBalls addObjectsFromArray:blueBallArray[i]];
		[allBallArray addObject:allBalls];
	}

	return [allBallArray copy];
}


#pragma mark - 统计（出现次数、最大连出、最大遗漏、平均遗漏）

- (NSArray *)numberOfOccurrencesWithNumber:(NSUInteger)number {
	NSArray *ballArray = [self subArrayOfAllBallsWithNumber:number];
	NSMutableArray *occurrencesNumberArray = [NSMutableArray arrayWithCapacity:ballArray.count];
	for (NSArray *anVRowBall in ballArray) {
		NSUInteger i = 0;
		for (Ball *ball in anVRowBall) {
			if (ball.isBall) {
				i++;
			}
		}
		[occurrencesNumberArray addObject:@(i)];
	}

	return [occurrencesNumberArray copy];
}

- (NSArray *)maxContinuousOccurrencesWithNumber:(NSUInteger)number {
	NSArray *ballArray = [self subArrayOfAllBallsWithNumber:number];
	NSMutableArray *maxContinuousOccurrencesArray = [NSMutableArray arrayWithCapacity:ballArray.count];
	for (NSArray *anVRowBall in ballArray) {
		NSUInteger max = 0;
		NSUInteger i = 0;
		for (Ball *ball in anVRowBall) {
			if (ball.isBall) {
				i++;
			} else {
				if (i > max) {
					max = i;
				}
				i = 0;
			}
		}
		[maxContinuousOccurrencesArray addObject:@(max)];
	}

	return [maxContinuousOccurrencesArray copy];
}

- (NSArray *)maxMissingWithNumber:(NSUInteger)number {
	NSArray *ballArray = [self subArrayOfAllBallsWithNumber:0];
	NSMutableArray *maxMissingArray = [NSMutableArray arrayWithCapacity:ballArray.count];
	for (NSArray *anVRowBall in ballArray) {
		NSUInteger max = 0;
		for (Ball *ball in anVRowBall) {
			if (!ball.isBall) {
				if (ball.value > max) {
					max = ball.value;
				}
			}
		}
		[maxMissingArray addObject:@(max)];
	}

	return [maxMissingArray copy];
}

- (NSArray *)averageMissingWithNumber:(NSUInteger)number {
	NSArray *ballArray = [self subArrayOfAllBallsWithNumber:0];
	NSMutableArray *averageMissingArray = [NSMutableArray arrayWithCapacity:ballArray.count];
	for (NSArray *anVRowBall in ballArray) {
		NSUInteger total = 0;
		NSUInteger max = 0;
		int i = 0;
		for (Ball *ball in anVRowBall) {
			if (!ball.isBall) {
				if (ball.value > max) {
					max = ball.value;
				}
			} else {
				i++;
				total += max;
				max = 0;
			}
		}
		if (i == 0) {
			[averageMissingArray addObject:@(0)];
		} else {
			[averageMissingArray addObject:@(total / i)];
		}
	}

	return [averageMissingArray copy];
}

// 把四个统计数组放入一个大数组
- (NSArray *)statisticsArrayWithNumber:(NSUInteger)number {
	NSArray *numberOfOccurrencesArray = [self numberOfOccurrencesWithNumber:number];
	NSArray *maxContinuousOccurrencesArray = [self maxContinuousOccurrencesWithNumber:number];
	NSArray *maxMissingArray = [self maxMissingWithNumber:number];
	NSArray *averageMissingArray = [self averageMissingWithNumber:number];

	NSMutableArray *statisticsArray = [NSMutableArray arrayWithCapacity:4];

	[statisticsArray addObject:numberOfOccurrencesArray];
	[statisticsArray addObject:maxContinuousOccurrencesArray];
	[statisticsArray addObject:maxMissingArray];
	[statisticsArray addObject:averageMissingArray];

	return [statisticsArray copy];
}

- (NSArray *)subArrayOfAllBallsWithNumber:(NSUInteger)number {
	NSMutableArray *vRowBallArray = [NSMutableArray arrayWithArray:[self statisticsRedBall]];
	[vRowBallArray addObjectsFromArray:[self statisticsBlueBall]];

	if (number == 0 || _allWinningBallArray.count < number) {
		return vRowBallArray;
	}

	NSMutableArray *vRowBallArraySubArray = [NSMutableArray arrayWithCapacity:vRowBallArray.count];
	for (NSArray *anVRowArray in vRowBallArray) {
		[vRowBallArraySubArray
				addObject:[anVRowArray subarrayWithRange:NSMakeRange(anVRowArray.count - number, number)]];
	}

	return [vRowBallArraySubArray copy];
}

@end
