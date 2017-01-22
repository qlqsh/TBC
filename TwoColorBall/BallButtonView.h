//
//  BallButton.h
//  TwoColorBall
//
//  Created by 刘明 on 2016/12/31.
//  Copyright © 2016年 刘明. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BallButtonView : UIView

@property (nonatomic, strong, readonly) UIButton *ballButton;
@property (nonatomic) BOOL isRed; // 球按钮（YES：红球按钮、NO:蓝球按钮）
@property (nonatomic, copy) NSString *text; // 按钮文字

@end
