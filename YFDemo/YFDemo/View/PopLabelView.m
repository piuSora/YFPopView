//
//  PopLabelView.m
//  YFDemo
//
//  Created by OS on 2018/8/2.
//  Copyright © 2018年 Piu. All rights reserved.
//

#import "PopLabelView.h"

@implementation PopLabelView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, [UIScreen mainScreen].bounds.size.width - 100, 100)];
        label.font = [UIFont systemFontOfSize:16];
        label.text = @"YFPopView";
        label.backgroundColor = [UIColor whiteColor];
        label.textAlignment = NSTextAlignmentCenter;
        self.backgroundColor = UIColor.orangeColor;
        [self addSubview:label];
    }
    return self;
}

@end
