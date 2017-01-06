//
//  AFTCBClient.h
//  TwoColorBall
//
//  Created by 刘明 on 2016/12/23.
//  Copyright © 2016年 刘明. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>

@interface AFTCBClient : AFHTTPSessionManager

+ (instancetype)sharedClient;

@end
