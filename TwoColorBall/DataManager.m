//
//  DataManager.m
//  TwoColorBall
//
//  Created by 刘明 on 2016/12/22.
//  Copyright © 2016年 刘明. All rights reserved.
//

#define kWinningInfoLocalDocumentPath @"/Library/Caches/tbc_winnings.plist"

#import "DataManager.h"
#import "Winning.h"
#import "WinningList.h"
#import <AFNetworking/AFNetworking.h>

@implementation DataManager

#pragma mark - 从本地文档获取数据

/**
 * 从本地文档获取所有获奖信息数据。
 * @return 获奖数据数组。
 */
- (NSArray *)readAllWinningListInFile {
	if (![self documentExists]) {
		[self copyFile];
	}
	NSString *loadPath = [NSHomeDirectory() stringByAppendingString:kWinningInfoLocalDocumentPath];
	NSMutableData *loadData = [NSMutableData dataWithContentsOfFile:loadPath];
	NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:loadData];
	WinningList *winningInfo = [unarchiver decodeObjectForKey:@"winningInfo"];

	return [winningInfo.list copy];
}

/**
 * 逆序读取所有数据。主要用在走势图。
 * @return 逆序获奖数据数组。
 */
- (NSArray *)readAllWinningListInFileUseReverse {
	return [[[self readAllWinningListInFile] reverseObjectEnumerator] allObjects];
}

/**
 * 最新一条获奖信息。
 * @return 一条获奖信息。
 */
- (Winning *)readLatestWinningInFile {
	NSArray *winningList = [self readAllWinningListInFile];
	return winningList[0];
}


#pragma mark - 网络获取最新数据
// 更新网络数据
- (void)updateWinningInfoUseNetworking {
    if (![self documentExists]) {
        [self copyFile];
    }
    [self getLatestWinningInfoUseNetworking];
    [self repairBadDocument]; // 可能需要修复损坏文档
}

- (void)getLatestWinningInfoUseNetworking {
	Winning *winning = [self readLatestWinningInFile];
	NSUInteger nextYear = [self calculateYear];

	NSString *basePath = @"http://kaijiang.zhcw.com/lishishuju/jsp/ssqInfoList.jsp?czId=1";
	AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
	// 申明请求的数据是http类型
	sessionManager.requestSerializer = [AFHTTPRequestSerializer serializer];
	// 申明返回的结果是http类型
	sessionManager.responseSerializer = [AFHTTPResponseSerializer serializer];
	// 增加支持html
	sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",
																	  @"text/plain", nil];
	// 设置超时时间
	[sessionManager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
	sessionManager.requestSerializer.timeoutInterval = 15.f;
	[sessionManager.requestSerializer didChangeValueForKey:@"timeoutInterval"];

	NSString *customPath = [NSString stringWithFormat:@"&beginIssue=%@&endIssue=%d001", winning.term, nextYear];
	NSString *urlPath = [NSString stringWithFormat:@"%@%@", basePath, customPath];
	[sessionManager GET:urlPath
			 parameters:nil
			   progress:nil
				success:^(NSURLSessionDataTask *_Nonnull task, id _Nullable responseObject) {
					NSString *htmlContent = [[NSString alloc] initWithData:responseObject
																  encoding:NSUTF8StringEncoding
					];
					WinningList *winningList = [[WinningList alloc] initWithHtmlContent:htmlContent];
					[self writeWinningInfoToFile:winningList.list];
				}
				failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error) {
					DLog(@"内容获取失败：%@", error);
				}];
}

/**
 *  重新获取所有数据。因为是异步获取网络数据，需要注意，读取的本地文档的时候，可能还没有加载完所有的数据。
 *  因此必须在加载完后再使用DataManager里面的方法读取数据。所以这个方法设为私有。只在特定环境下使用。
 *  需要时间挺长的呢。需要个进度指示器来使用。
 */
- (void)resetAllWinningInfoUseNetworking {
	NSString *basePath = @"http://kaijiang.zhcw.com/lishishuju/jsp/ssqInfoList.jsp?czId=1";
	AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
	// 申明请求的数据是http类型
	sessionManager.requestSerializer = [AFHTTPRequestSerializer serializer];
	// 申明返回的结果是http类型
	sessionManager.responseSerializer = [AFHTTPResponseSerializer serializer];
	// 增加支持html
	sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", @"text/plain", nil];

	NSInteger nextYear = [self calculateYear];
	for (int i = 2003; i < nextYear; i++) {
		NSString *customPath = [NSString stringWithFormat:@"&beginIssue=%d001&endIssue=%d001", i, i + 1];
		NSString *urlPath = [NSString stringWithFormat:@"%@%@", basePath, customPath];
		[sessionManager GET:urlPath
				 parameters:nil
				   progress:nil
					success:^(NSURLSessionDataTask *_Nonnull task, id _Nullable responseObject) {
						NSString *htmlContent = [[NSString alloc] initWithData:responseObject
																	  encoding:NSUTF8StringEncoding
						];
						WinningList *winningList = [[WinningList alloc] initWithHtmlContent:htmlContent];
						[self writeWinningInfoToFile:winningList.list];
					}
					failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error) {
						DLog(@"内容获取失败：%@", error);
					}];
	}
}

// 把获奖信息列表写入到本地文档。
- (BOOL)writeWinningInfoToFile:(NSArray *)winningList {
	Winning *lastWinning = [self readLatestWinningInFile];
	Winning *newLastWinning = [winningList firstObject];

	// 没有新数据，没必要更新
	if ([lastWinning.term integerValue] >= [newLastWinning.term integerValue]) {
		return FALSE;
	}

	NSMutableArray *moreWinningInfo = [[NSMutableArray alloc] initWithCapacity:200];
	if ([self documentExists]) {
		NSArray *oldWinningList = [self readAllWinningListInFile];
		[moreWinningInfo addObjectsFromArray:oldWinningList];
	}
	// 遍历，重复的信息不存储。
	for (Winning *winning in winningList) {
		if (![moreWinningInfo containsObject:winning]) {
			[moreWinningInfo addObject:winning];
		}
	}
	NSArray *sortArray = [[moreWinningInfo sortedArrayUsingSelector:@selector(compare:)] copy];

	// 把数组里数据写入到文件
	WinningList *newWinningInfo = [[WinningList alloc] initWithWinningList:sortArray];
	NSString *savePath = [NSHomeDirectory() stringByAppendingString:kWinningInfoLocalDocumentPath];
	NSMutableData *saveData = [NSMutableData data];
	NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:saveData];
	[archiver encodeObject:newWinningInfo forKey:@"winningInfo"];
	[archiver finishEncoding];
	BOOL success = [saveData writeToFile:savePath atomically:YES];
	if (!success) {
		DLog(@"存档失败, %@", savePath);
		return FALSE;
	}

	return TRUE;

}


#pragma mark - 私有方法

/**
 *  计算今年，然后+1，用于网络提取获奖数据确定范围。
 *
 *  @return 今年+1
 */
- (NSUInteger)calculateYear {
	NSDate *currentDate = [NSDate date];
	NSCalendar *calendar = [NSCalendar currentCalendar];
	NSDateComponents *components = [calendar components:NSCalendarUnitYear fromDate:currentDate];
	NSUInteger nextYear = (NSUInteger) ([components year] + 1);

	return nextYear;
}

// 从程序里拷贝文件（旧数据）到本地文件，拷贝文档到/Documents。
- (BOOL)copyFile {
	NSString *loadPath = [NSHomeDirectory() stringByAppendingString:kWinningInfoLocalDocumentPath];
	NSFileManager *fileManager = [NSFileManager defaultManager];
	if (![fileManager fileExistsAtPath:loadPath]) {
		// 拷贝已有的数据文件到本地文件。
		NSString *dataPath = [[[NSBundle mainBundle] bundlePath] stringByAppendingString:@"/winnings.plist"];
		NSError *error;
		if ([fileManager copyItemAtPath:dataPath toPath:loadPath error:&error]) {
			DLog(@"拷贝文件成功");
			return YES;
		} else {
			DLog(@"%@", error);
			return NO;
		}
	}
	return YES;
}

/**
 *  删除本地文件。
 */
- (void)removeFile {
	NSFileManager *fileManager = [NSFileManager defaultManager];
	if ([fileManager fileExistsAtPath:kWinningInfoLocalDocumentPath]) {
		NSError *error;
		if ([fileManager removeItemAtPath:kWinningInfoLocalDocumentPath error:&error]) {
			DLog(@"文件删除成功");
		} else {
			DLog(@"%@", error);
		}
	}
}

// 判断文档（winnings.plist）是否存在。
- (BOOL)documentExists {
	NSString *loadPath = [NSHomeDirectory() stringByAppendingString:kWinningInfoLocalDocumentPath];
	NSFileManager *fileManager = [NSFileManager defaultManager];
	return [fileManager fileExistsAtPath:loadPath];

}

// 修复损坏文档。
- (void)repairBadDocument {
	BOOL isBadDocument = NO; // 文档出现损坏
	Winning *winning = [self readLatestWinningInFile];
	if (winning == nil) {
		isBadDocument = YES;
	}
	if (winning.term == nil || [winning.term isEqualToString:@""]) {
		isBadDocument = YES;
	}
	if (winning.date == nil || [winning.term isEqualToString:@""]) {
		isBadDocument = YES;
	}
	if (winning.reds == nil || winning.blues == nil) {
		isBadDocument = YES;
	}

	if (isBadDocument) {
		DLog(@"文档损坏，修复");
		[self removeFile];
		[self copyFile];
		[self getLatestWinningInfoUseNetworking];
	}
}

@end
