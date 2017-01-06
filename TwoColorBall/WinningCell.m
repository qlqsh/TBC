//
//  WinningCell.m
//  TwoColorBall
//
//  Created by 刘明 on 2016/12/24.
//  Copyright © 2016年 刘明. All rights reserved.
//

#import "WinningCell.h"
#import "WinningBallView.h"

#define kDefaultLabelHeight 20.0f
#define kDefaultSpace 5.0f

/**
 *  获奖单元。包括期号、时间、获奖号码。
 */
@implementation WinningCell

#pragma mark - 初始化（注册默认的是这个初始化）
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        CGFloat termWidth = self.frame.size.width;
        _termLabel = [[UILabel alloc] initWithFrame:CGRectMake(termWidth*0.05,
                                                               kDefaultSpace,
                                                               termWidth*0.4,
                                                               kDefaultLabelHeight)];
        _termLabel.font = [UIFont boldSystemFontOfSize:16.0f];
        
        _dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(termWidth*0.05+termWidth*0.4,
                                                               kDefaultSpace,
                                                               termWidth*0.5,
                                                               kDefaultLabelHeight)];
        _dateLabel.textAlignment = NSTextAlignmentRight;
        _dateLabel.font = [UIFont boldSystemFontOfSize:16.0f];
        
        CGFloat heightOfCell = [WinningBallView heightOfCellWithWidth:termWidth*0.9];
        _winningBallView = [[WinningBallView alloc] initWithFrame:CGRectMake(termWidth*0.05,
                                                                             kDefaultSpace*2+kDefaultLabelHeight,
                                                                             termWidth*0.9,
                                                                             heightOfCell)];
        
        [self.contentView addSubview:_termLabel];
        [self.contentView addSubview:_dateLabel];
        [self.contentView addSubview:_winningBallView];
    }
    
    return self;
}

#pragma mark - 类方法
+ (CGFloat)heightOfCellWithWidth:(CGFloat)width {
    return [WinningBallView heightOfCellWithWidth:width]+kDefaultLabelHeight+kDefaultSpace*3;
}

@end
