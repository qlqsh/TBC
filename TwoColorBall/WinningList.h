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


@end
