//
//  PopViewController.m
//  YFDemo
//
//  Created by OS on 2018/8/2.
//  Copyright © 2018年 Piu. All rights reserved.
//

#import "PopViewController.h"
#import "PopInputingView.h"
#import "PopLabelView.h"

@interface PopViewController ()

@end

@implementation PopViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (IBAction)popViewAction:(UIButton *)sender {
    // code
    PopLabelView *labelView = [[PopLabelView alloc] init];
    // xib
    PopInputingView *inputingView = [PopInputingView instanceViewWithNibName:@"PopInputingView"];
    inputingView.animatedView = inputingView.bottomView;
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    
    switch (sender.tag) {
        case 100:{//top to bottom
            labelView.animationStyle = YFPopViewAnimationStyleTopToBottom;
            [labelView showPopViewOn:keyWindow];
        }
            break;
        case 200:{//bottom to top
            inputingView.animationStyle = YFPopViewAnimationStyleBottomToTop;
            [inputingView showPopViewOn:keyWindow];
        }
            break;
        case 300:{//left to right
            labelView.animationStyle = YFPopViewAnimationStyleLeftToRight;
            [labelView showPopViewOn:keyWindow];
        }
            break;
        case 400:{//right to left
            labelView.animationStyle = YFPopViewAnimationStyleRightToLeft;
            [labelView showPopViewOn:keyWindow];
        }
            break;
        case 500:{//scale
            labelView.animationStyle = YFPopViewAnimationStyleScale;
            [labelView showPopViewOn:keyWindow];
        }
            break;
        case 600:{//fade
            labelView.animationStyle = YFPopViewAnimationStyleFade;
            [labelView showPopViewOn:keyWindow];
        }
        default:
            break;
    }
}


@end
