//
//  Ball.h
//  TwoColorBall
//
//  Created by 刘明 on 16/7/16.
//  Copyright © 2016年 刘明. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Ball : NSObject

@property(nonatomic) NSUInteger value; // 数字值，可能是中奖号码，也可能是统计数字
@property(nonatomic) BOOL isBall;      // YES:中奖号码，NO:统计数字

- (instancetype)initWithValue:(NSUInteger)value andIsBall:(BOOL)isBall;

@end
