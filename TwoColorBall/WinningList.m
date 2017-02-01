//
//  WinningList.m
//  TwoColorBall
//
//  Created by 刘明 on 2016/12/23.
//  Copyright © 2016年 刘明. All rights reserved.
//

#import "WinningList.h"
#import "Winning.h"
#import "TFHppleElements.h"

@implementation WinningList

/**
 *  分解大块html为小块html片段。
 *
 *  @param htmlContent 需要解析的html内容
 *
 *  @return 包含获奖信息列表的对象。
 */
- (instancetype)initWithHtmlContent:(NSString *)htmlContent {
	if (nil == htmlContent) {
		return nil;
	}

	NSArray *elements;
	NSMutableArray *winnings = [[NSMutableArray alloc] init];

	// 获奖信息html片段
	elements = [TFHppleElements search:@"//tbody//tr" specificContent:htmlContent];

	for (TFHppleElement *element in elements) {
		Winning *winning = [[Winning alloc] initWithContent:[element raw]];
		if (nil != winning) {
			[winnings addObject:winning];
		}
	}

	// 所有获奖信息
	if (self = [super init]) {
		_list = [winnings copy];
	}

	return self;
}

/**
 *  直接把获奖信息列表传递过来。不需要html解析。
 *
 *  @param list 获奖信息列表
 *
 *  @return 包含获奖信息列表的对象。
 */
- (instancetype)initWithWinningList:(NSArray *)list {
	if (self = [super init]) {
		_list = [list copy];
	}

	return self;
}


#pragma mark - 覆写方法

- (NSString *)description {
	NSMutableString *description = [[NSMutableString alloc] init];
	for (Winning *winning in _list) {
		[description appendFormat:@"%@", [winning description]];
	}

	return [description copy];
}


#pragma mark - 编、解码

- (void)encodeWithCoder:(NSCoder *)aCoder {
	[aCoder encodeObject:_list forKey:@"list"];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
	if (self = [super init]) {
		_list = [aDecoder decodeObjectForKey:@"list"];
	}

	return self;
}

@end
