//
//  SimpleWinning.m
//  TwoColorBall
//
//  Created by 刘明 on 2016/12/27.
//  Copyright © 2016年 刘明. All rights reserved.
//

#import "SimpleWinning.h"
#import "NumberCombinations.h"

/**
 *  简单获奖信息（包含较少的信息内容：期号、时间、红球、蓝球）。
 */
@implementation SimpleWinning


#pragma mark - 初始化

- (instancetype)initWithTerm:(NSString *)term
					 andReds:(NSArray *)reds
					andBlues:(NSArray *)blues
					 andDate:(NSString *)date {
	if (self = [super init]) {
		_term = term;
		_reds = [[NumberCombinations alloc] initWithArray:reds];
		_blues = [[NumberCombinations alloc] initWithArray:blues];
		_date = date;
	}

	return self;
}


#pragma mark - 方法

// 红球是否包含 numberString 里的号码
- (BOOL)contains:(NSString *)numberString {
	return [_reds contains:numberString];
}


#pragma mark - 覆写

- (NSString *)description {
	return [NSString stringWithFormat:@"{\n\t期号：\t\t%@\n\t红球：\t\t%@\n\t蓝球：\t\t%@\n\t开奖时间：\t%@\n}", _term, _reds.toString, _blues.toString, _date];
}

@end
