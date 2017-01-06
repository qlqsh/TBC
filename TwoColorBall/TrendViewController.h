//
//  TrendViewController.h
//  TwoColorBall
//
//  Created by 刘明 on 2016/12/29.
//  Copyright © 2016年 刘明. All rights reserved.
//
//  TODO:   1、使用UITablView的其它地方还好。就是错位问题是个大问题。很违和。
//          2、使用UIView的话，又太浪费内存。
//          3、也许UICollectionView是个更好的选择。未来需要尝试一下。

#import <UIKit/UIKit.h>

@interface TrendViewController : UIViewController
@property (nonatomic, strong, readonly) NSArray *winningList;       // 获奖列表（走势整理后）
@property (nonatomic, strong, readonly) NSArray *statisticsArray;   // 统计数组
@end
