//
//  CommonMethod.h
//  TwoColorBall
//
//  Created by 刘明 on 2016/12/23.
//  Copyright © 2016年 刘明. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommonMethod : NSObject

// 根据提供的日期判断星期几。
+ (NSInteger)calendarWeekdayWithYear:(NSInteger)year andMonth:(NSInteger)month andDay:(NSInteger)day;
+ (NSInteger)calendarWeekdayWithString:(NSString *)dateString;

@end
