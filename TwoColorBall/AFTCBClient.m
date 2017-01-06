//
//  AFTCBClient.m
//  TwoColorBall
//
//  Created by 刘明 on 2016/12/23.
//  Copyright © 2016年 刘明. All rights reserved.
//

#import "AFTCBClient.h"

static NSString *const AFCHHBaseURLString = @"http://kaijiang.zhcw.com/lishishuju/jsp/";

@implementation AFTCBClient

+ (instancetype)sharedClient {
    static AFTCBClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[AFTCBClient alloc] initWithBaseURL:[NSURL URLWithString:AFCHHBaseURLString]];
        _sharedClient.responseSerializer = [AFHTTPResponseSerializer serializer];
        _sharedClient.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
        _sharedClient.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    });
    
    return _sharedClient;
}

@end
