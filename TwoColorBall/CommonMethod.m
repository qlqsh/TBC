//
//  CommonMethod.m
//  TwoColorBall
//
//  Created by 刘明 on 2016/12/23.
//  Copyright © 2016年 刘明. All rights reserved.
//

#import "CommonMethod.h"

@implementation CommonMethod

#pragma mark - 计算周几
/**
 *  根据提供的日期判断星期几。
 *
 *  @param year  年
 *  @param month 月
 *  @param day   日
 *
 *  @return 星期几（1-7）
 */
+ (NSInteger)calendarWeekdayWithYear:(NSInteger)year andMonth:(NSInteger)month andDay:(NSInteger)day {
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    [dateComponents setDay:day];
    [dateComponents setMonth:month];
    [dateComponents setYear:year];
    
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDate *date = [gregorian dateFromComponents:dateComponents];
    NSDateComponents *weekdayComponents = [gregorian components:NSCalendarUnitWeekday fromDate:date];
    NSInteger weekday = [weekdayComponents weekday];
    
    return weekday;
}

// 通过日期字符串判断是星期几。
+ (NSInteger)calendarWeekdayWithString:(NSString *)dateString {
    if (dateString == nil || [dateString isEqualToString:@""]) {
        return 0;
    }
    NSArray *dateArray = [dateString componentsSeparatedByString:@"-"];
    if (dateArray.count != 3) {
        return 0;
    }
    
    return [CommonMethod calendarWeekdayWithYear:[dateArray[0] integerValue]
                                        andMonth:[dateArray[1] integerValue]
                                          andDay:[dateArray[2] integerValue]];
}

@end
