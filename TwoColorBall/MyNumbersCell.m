//
//  MyNumbersCell.m
//  TwoColorBall
//
//  Created by 刘明 on 2017/1/17.
//  Copyright © 2017年 刘明. All rights reserved.
//
//  我的号码单元：标签+我选择的号码

#import "MyNumbersCell.h"
#import "BallView.h"

@implementation MyNumbersCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style
			  reuseIdentifier:(NSString *)reuseIdentifier {
	if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {

	}

	return self;
}

#define kDefaultWidth kScreenWidth/7
#pragma mark - 属性获取与设置

- (void)setNumbersDictionary:(NSDictionary *)numbersDictionary {
	NSArray *reds = numbersDictionary[@"reds"];
	NSArray *blues = numbersDictionary[@"blues"];

	CGFloat ballWidth = (CGFloat) (kDefaultWidth);

	NSInteger i = 0;
	NSInteger j = 0;
	for (NSString *red in reds) {
		BallView *ballView = [[BallView alloc] initWithFrame:CGRectMake(i * ballWidth, j * ballWidth,
				ballWidth, ballWidth)];
		ballView.state = 2;
		ballView.textLabel.text = red;
		i++;
		if (i > 6) {
			j += 1;
			i = 0;
		}
		[self.contentView addSubview:ballView];
	}
	for (NSString *blue in blues) {
		BallView *ballView = [[BallView alloc] initWithFrame:CGRectMake(i * ballWidth, j * ballWidth,
				ballWidth, ballWidth)];
		ballView.state = 3;
		ballView.textLabel.text = blue;
		i++;
		if (i > 6) {
			j += 1;
			i = 0;
		}
		[self.contentView addSubview:ballView];
	}
}

+ (CGFloat)heightOfCellWithNumbersDictionary:(NSDictionary *)numbersDictionary {
	NSArray *reds = numbersDictionary[@"reds"];
	NSArray *blues = numbersDictionary[@"blues"];

	NSInteger total = reds.count + blues.count;

	if (total % 7 == 0) {
		return (CGFloat) (kDefaultWidth + (total / 7 - 1) * kDefaultWidth);
	} else {
		return (CGFloat) (kDefaultWidth + total / 7 * kDefaultWidth);
	}
}

@end
