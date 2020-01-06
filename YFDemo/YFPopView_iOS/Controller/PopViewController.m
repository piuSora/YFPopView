//
//  PopViewController.m
//  YFDemo
//
//  Created by OS on 2018/8/2.
//  Copyright © 2018年 Piu. All rights reserved.
//

#import "PopViewController.h"
#import "PopLabelView.h"
#import "YFPopView.h"
#import <Masonry/Masonry.h>

@interface PopViewController ()

@end

@implementation PopViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (IBAction)popViewAction:(UIButton *)sender {
//    PopLabelView *labelView = [[PopLabelView alloc] initWithFrame:CGRectMake(40, 200, [UIScreen mainScreen].bounds.size.width - 80, 120)];
    PopLabelView *labelView = [PopLabelView new];
    YFPopView *popView = [[YFPopView alloc] initWithSubView:labelView];
    [labelView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo([UIScreen mainScreen].bounds.size.width - 80);
        make.height.mas_equalTo(120);
        make.center.mas_equalTo(popView);
    }];
    popView.willShow = ^(YFPopView *popView) {
        NSLog(@"pop view will show");
    };
    popView.didShow = ^(YFPopView *popView) {
        NSLog(@"pop view did show");
    };
    popView.willDismiss = ^(YFPopView *popView) {
        NSLog(@"pop view will dismiss");
    };
    popView.didDismiss = ^(YFPopView *popView) {
        NSLog(@"pop view did dismiss");
    };
    
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    switch (sender.tag) {
        case 100:{//top to bottom
            popView.animationStyle = YFPopViewAnimationStyleTopToBottom;
            [popView showPopViewOn:keyWindow];
        }
            break;
        case 200:{//bottom to top
            popView.animationStyle = YFPopViewAnimationStyleBottomToTop;
            [popView showPopViewOn:keyWindow];
        }
            break;
        case 300:{//left to right
            popView.animationStyle = YFPopViewAnimationStyleLeftToRight;
            [popView showPopViewOn:keyWindow];
        }
            break;
        case 400:{//right to left
            popView.animationStyle = YFPopViewAnimationStyleRightToLeft;
            [popView showPopViewOn:keyWindow];
        }
            break;
        case 500:{//scale
            popView.animationStyle = YFPopViewAnimationStyleScale;
            [popView showPopViewOn:keyWindow];
        }
            break;
        case 600:{//fade
            popView.animationStyle = YFPopViewAnimationStyleFade;
            [popView showPopViewOn:keyWindow];
        }
            break;
        default:
            break;
    }
}


@end
