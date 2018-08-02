//
//  PopLabelView.m
//  YFDemo
//
//  Created by OS on 2018/8/2.
//  Copyright © 2018年 Piu. All rights reserved.
//

#import "PopLabelView.h"

@implementation PopLabelView

- (instancetype)init{
    if (self = [super init]) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(50, 200, [UIScreen mainScreen].bounds.size.width - 100, 100)];
        label.font = [UIFont systemFontOfSize:16];
        label.text = @"YFPopView";
        label.backgroundColor = [UIColor whiteColor];
        label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:label];
        
        //核心代码
        self.animatedView = label;
    }
    return self;
}

@end
