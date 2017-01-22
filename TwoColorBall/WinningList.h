//
//  WinningList.h
//  TwoColorBall
//
//  Created by 刘明 on 2016/12/23.
//  Copyright © 2016年 刘明. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * 一组（多条）获奖（Winning）信息。
 */
@interface WinningList : NSObject <NSCoding>

@property (nonatomic, strong) NSArray *list;


#pragma mark - 初始化对象

- (instancetype)initWithHtmlContent:(NSString *)htmlContent;

- (instancetype)initWithWinningList:(NSArray *)list;


#pragma mark - 网络获取获奖信息html网页

+ (NSURLSessionDataTask *)getWinningListContentUseURLString:(NSString *)urlString
											  andParameters:(NSDictionary *)parameters
												  withBlock:(void (^)(NSArray *winnings, NSError *error))block;

@end
