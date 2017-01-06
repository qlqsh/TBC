//
//  Ball.m
//  TwoColorBall
//
//  Created by 刘明 on 16/7/16.
//  Copyright © 2016年 刘明. All rights reserved.
//

#import "Ball.h"

@implementation Ball

#pragma mark - 初始化
- (instancetype)initWithValue:(NSUInteger)value andIsBall:(BOOL)isBall {
    if (self = [super init]) {
        _value = value;
        _isBall = isBall;
    }

    return self;
}

#pragma mark - 覆写
- (NSString *)description {
    return [NSString stringWithFormat:@"%lu", (unsigned long) _value];
}

@end
