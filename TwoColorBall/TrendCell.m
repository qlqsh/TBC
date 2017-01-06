//
//  TrendCell.m
//  TwoColorBall
//
//  Created by 刘明 on 2016/12/29.
//  Copyright © 2016年 刘明. All rights reserved.
//

#import "TrendCell.h"

#define kTermLabelWidth 65.0f
#define kCellScrollNotification @"cellScrollNotification"

@implementation TrendCell

#pragma mark - 初始化
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createCellView];
    }
    
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

// 单元的内容视图是个滚动视图
- (void)createCellView {
    // 滚动视图设置
    CGRect screen = [UIScreen mainScreen].bounds;
    _cellScrollView = [[UIScrollView alloc] initWithFrame:screen];
    _cellScrollView.contentSize = CGSizeMake(kTermLabelWidth+[TrendBaseView widthOfView], kDefaultWidth);
    _cellScrollView.delegate = self;
    _cellScrollView.bounces = NO;                        // 不能弹动
    _cellScrollView.directionalLockEnabled = YES;        // 定向锁定
    _cellScrollView.showsHorizontalScrollIndicator = NO; // 隐藏水平滚动条
    [self.contentView addSubview:_cellScrollView];
    
    // 注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(scrollMove:)
                                                 name:kCellScrollNotification
                                               object:nil];
}

- (void)scrollMove:(NSNotification *)notification {
    NSDictionary *userInfo = notification.userInfo;
    NSObject *object = notification.object;
    float offsetX = [userInfo[@"offsetX"] floatValue];
    if (object != self) {
        _isNotification = YES;
        // 为了所有单元同步移动，所以不能有动画效果。
        [_cellScrollView setContentOffset:CGPointMake(offsetX, 0.0f) animated:NO];
    } else {
        _isNotification = NO;
    }
    object = nil;
}

#pragma mark - 单元大小
+ (CGFloat)heightOfCell {
    return kDefaultWidth;
}

+ (CGFloat)widthOfCell {
    return [TrendBaseView widthOfView]+kTermLabelWidth;
}

#pragma mark - UIScrollViewDelegate
// 有没有这个无所谓，效果没区别。但逻辑上应该存在。也就是说我正要移动当前单元格，所以这不是通知，是我手动。
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    _isNotification = NO;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (!_isNotification) {
        // 发送通知
        [[NSNotificationCenter defaultCenter] postNotificationName:kCellScrollNotification
                                                            object:self
                                                          userInfo:@{ @"offsetX" : @(scrollView.contentOffset.x) }];
    }
    
    NSArray *views = scrollView.subviews;
    UIView *first = views.lastObject;
    CGRect frame = first.frame;
    frame.origin.x = scrollView.contentOffset.x;
    first.frame = frame;
    _isNotification = NO;
}

@end
