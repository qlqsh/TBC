//
//  DataList.h
//  TwoColorBall
//
//  Created by 刘明 on 2017/1/19.
//  Copyright © 2017年 刘明. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BallList : NSObject

@property (nonatomic, strong) NSArray *balls;

- (instancetype)initWithBalls:(NSArray *)balls;

- (NSArray *)combining:(NSUInteger)number;

@end
