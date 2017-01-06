//
//  Winning.m
//  TwoColorBall
//
//  Created by 刘明 on 2016/12/22.
//  Copyright © 2016年 刘明. All rights reserved.
//

#import "Winning.h"
#import "CommonMethod.h"
#import "TFHppleElements.h"

@implementation Winning
/**
 解析特定的html内容，提取双色球获奖信息。

 @param htmlContent html片段。
 @return 获奖信息对象。
 */
- (instancetype)initWithContent:(NSString *)htmlContent {
    if (nil == htmlContent) {
        return nil;
    }
    
    NSArray *elements;
    NSString *date, *week, *term, *reds, *blues, *sales, *pool;
    NSString *firstAmount, *firstMoney, *secondAmount, *secondMoney, *thirdAmount, *thirdMoney;
    
    // 时间、期号、红球、销售额、奖池、一等奖（注数、奖金）、二等奖（注数、奖金）、三等奖（注数、奖金）
    elements = [TFHppleElements search:@"//tr//td" specificContent:htmlContent];
    if (elements.count > 12) {
        date = [elements[1] text];
        term = [elements[2] text];
        reds = [[elements[3] text] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        sales = [elements[4] text];
        firstAmount = [elements[5] text];
        firstMoney = [elements[6] text];
        secondAmount = [elements[7] text];
        secondMoney = [elements[8] text];
        thirdAmount = [elements[9] text];
        thirdMoney = [elements[10] text];
        pool = [elements[11] text];
    } else {
        return nil;
    }
    
    NSInteger weekday = [CommonMethod calendarWeekdayWithString:date];
    switch (weekday) {
        case 3:
            week = @"周二";
            break;
        case 5:
            week = @"周四";
            break;
        case 1:
        default:
            week = @"周日";
            break;
    }
    
    // 蓝球
    elements = [TFHppleElements search:@"//tr//td//span" specificContent:htmlContent];
    if (elements.count == 1) {
        blues = [elements[0] text];
    }
    
    if (date == nil) {
        return nil;
    }
    if (term == nil) {
        return nil;
    }
    if (reds == nil) {
        return nil;
    }
    if (blues == nil) {
        return nil;
    }
    
    if (self = [super init]) {
        _date = [date copy];
        _week = [week copy];
        _term = [term copy];
        _reds = [reds componentsSeparatedByString:@" "];
        _blues = [blues componentsSeparatedByString:@" "];
        _moneyState = @{ @"sales":sales, @"pool":pool };
        _prizeState = @{ @"firstAmount":firstAmount, @"firstMoney":firstMoney,
                         @"secondAmount":secondAmount, @"secondMoney":secondMoney,
                         @"thirdAmount":thirdAmount, @"thirdMoney":thirdMoney };
    }
    
    return self;
}

#pragma mark - 覆写方法
- (NSString *)description {
    NSString *formatString = @"\n{\n \
        \t开奖日期：%@ \n \
        \t期号：%@ \n \
        \t红球：%@ \n \
        \t蓝球：%@ \n \
        \t销售额：%@ \n \
        \t奖池余额：%@ \n \
        \t一等奖（注数）：%@ \n \
        \t一等奖（奖金）：%@ \n \
        \t二等奖（注数）：%@ \n \
        \t二等奖（奖金）：%@ \n \
        \t三等奖（注数）：%@ \n \
        \t三等奖（奖金）：%@ \n \
    }\n";
    NSString *description = [NSString stringWithFormat:formatString, _date, _term, _reds, _blues,
                             _moneyState[@"sales"], _moneyState[@"pool"],
                             _prizeState[@"firstAmount"], _prizeState[@"firstMoney"],
                             _prizeState[@"secondAmount"], _prizeState[@"secondMoney"],
                             _prizeState[@"thirdAmount"], _prizeState[@"thirdMoney"]];

    return [description copy];
}

- (BOOL)isEqual:(id)object {
    Winning *winning = (Winning *)object;
    return [_term isEqualToString:winning.term];
}

#pragma mark - 比较方法
- (NSComparisonResult)compare:(Winning *)otherWinning {
    return [otherWinning.term compare:self.term];
}

#pragma mark - 编、解码
- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:_date forKey:@"date"];
    [aCoder encodeObject:_week forKey:@"week"];
    [aCoder encodeObject:_term forKey:@"term"];
    [aCoder encodeObject:_reds forKey:@"reds"];
    [aCoder encodeObject:_blues forKey:@"blues"];
    [aCoder encodeObject:_moneyState forKey:@"money"];
    [aCoder encodeObject:_prizeState forKey:@"prize"];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        _date = [aDecoder decodeObjectForKey:@"date"];
        _week = [aDecoder decodeObjectForKey:@"week"];
        _term = [aDecoder decodeObjectForKey:@"term"];
        _reds = [aDecoder decodeObjectForKey:@"reds"];
        _blues = [aDecoder decodeObjectForKey:@"blues"];
        _moneyState = [aDecoder decodeObjectForKey:@"money"];
        _prizeState = [aDecoder decodeObjectForKey:@"prize"];
    }
    
    return self;
}

@end
