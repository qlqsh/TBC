//
//  DataManager.h
//  TwoColorBall
//
//  Created by 刘明 on 2016/12/22.
//  Copyright © 2016年 刘明. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Winning;

// 双色球获奖信息数据管理。数据从网络获取，存储在本地文档。位置：/Documents/winnings.plist
@interface DataManager : NSObject

+ (DataManager *)sharedManager;

#pragma mark - 开发方法
- (Winning *)readLatestWinningInFile;            // 本地文档最新获奖数据
- (NSArray *)readAllWinningListInFile;           // 本地文档所有获奖数据，主要方法，其它方法都要调用它。
- (NSArray *)readAllWinningListInFileUseReverse; // 本地文档所有获奖数据（逆序列表，走势图用）

@end
