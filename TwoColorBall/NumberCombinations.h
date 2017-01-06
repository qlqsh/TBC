//
//  NumberCombinations.h
//  TwoColorBall
//
//  Created by 刘明 on 2016/12/27.
//  Copyright © 2016年 刘明. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NumberCombinations : NSObject

@property(nonatomic, readonly, copy) NSArray *numbers;
@property(nonatomic, readonly, copy) NSDictionary *numbersCombiningDictionary;
@property(nonatomic, readonly, strong) NSNumber *sumValue; // 和值
@property(nonatomic, readonly, assign) BOOL hasContinuous; // 连号
@property(nonatomic, assign) NSUInteger showNumber; // 出现次数

- (instancetype)initWithArray:(NSArray *)numberArray;
- (instancetype)initWithString:(NSString *)numberString;

- (BOOL)contains:(NSString *)numberString;
- (NSString *)toString;
- (NSComparisonResult)compare:(NumberCombinations *)numberCombinations;

@end
