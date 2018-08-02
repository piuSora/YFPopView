//
//  YFPopView.m
//
//  Created by OS on 2018/3/29.
//  Copyright © 2018年 Piu. All rights reserved.
//

#import "YFPopView.h"
@interface YFPopView ()<UIGestureRecognizerDelegate>
{
    CGRect subViewFrame;
    UITapGestureRecognizer *singleTap;
    
    CGRect startFrame;
    CGRect endFrame;
}

@end

@implementation YFPopView

+ (instancetype )instanceViewWithNibName:(NSString *)nibName{
    NSArray *array = [[NSBundle mainBundle]loadNibNamed:nibName owner:nil options:nil];
    return array.firstObject;
}

- (void)awakeFromNib{
    [super awakeFromNib];
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setFrame:frame];
    }
    return self;
}

- (instancetype)init{
    if (self = [super init]) {
        [self setFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
        singleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(removeSelf)];
        [self addGestureRecognizer:singleTap];
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:1.0/3.0];
        self.adjustedKeyboardEnable = YES;
        self.duration = 0.3;
        self.animatedEnable = YES;
        self.animationStyle = YFPopViewAnimationStyleBottomToTop;
        singleTap.delegate = self;
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch  {
    // 输出点击的view的类名
    // 若为UITableViewCellContentView（即点击了tableViewCell），则不截获Touch事件
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"] || touch.view == self.animatedView) {
        return NO;
    }
    return  YES;
}

#pragma mark - 监听键盘
- (void)registerForKeyboardNotifications{
    //使用NSNotificationCenter 鍵盤出現時
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShown:)
                                                 name:UIKeyboardWillChangeFrameNotification object:nil];
    //使用NSNotificationCenter 鍵盤隐藏時
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
}
//实现当键盘出现的时候计算键盘的高度大小
- (void)keyboardWillShown:(NSNotification*)aNotification{
    NSDictionary *info = [aNotification userInfo];
    CGFloat duration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    NSValue *value = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGSize keyboardSize = [value CGRectValue].size;
    
    [UIView animateWithDuration:duration animations:^{
        self.frame = CGRectMake(self.frame.origin.x, [UIScreen mainScreen].bounds.size.height - keyboardSize.height - self.frame.size.height, self.frame.size.width, self.frame.size.height);
    }];
    
}
- (void)keyboardWillBeHidden:(NSNotification*)aNotification{
    [self setFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
}

#pragma mark - 展示

- (void)showPopViewOn:(UIView *)view{
    [view addSubview:self];
    if (self.adjustedKeyboardEnable) {
        //注册键盘监听
        [self registerForKeyboardNotifications];
    }
    [self settingSubViewsWithAnimated:self.animatedEnable Duration:self.duration];
}

#pragma mark - 移除

- (void)removeSelf{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self removeGestureRecognizer:singleTap];
    [self removeSelfWithAnimated:self.animatedEnable];
}

- (void)removeSelfWithAnimated:(BOOL)animated{
    if (animated) {
        if (self.animationStyle == YFPopViewAnimationStyleScale) {
            [self executeTransformAnimationIsShowing:NO];
            return;
        }
        else if (self.animationStyle == YFPopViewAnimationStyleFade){
            [self executeFadeAnimationIsShowing:NO];
            return;
        }
        [self executeAnimationIsShowing:NO];
    }
    else{
        [self removeFromSuperview];
    }
}

#pragma mark - 设置动画

- (void)settingSubViewsWithAnimated:(BOOL)animated Duration:(NSTimeInterval)duration{
    if (animated) {
        [self layoutIfNeeded];
        subViewFrame = self.animatedView.frame;
        if (self.animationStyle == YFPopViewAnimationStyleBottomToTop) {
            [self settingSubViewsAnimationFromBottomToTop];
        }
        else if (self.animationStyle == YFPopViewAnimationStyleTopToBottom){
            [self settingSubViewsAnimationFromTopToBottom];
        }
        else if (self.animationStyle == YFPopViewAnimationStyleRightToLeft){
            [self settingSubViewsAnimationFromRightToLeft];
        }
        else if (self.animationStyle == YFPopViewAnimationStyleLeftToRight){
            [self settingSubViewsAnimationFromLeftToRight];
        }
        else if (self.animationStyle == YFPopViewAnimationStyleFade){
            [self executeFadeAnimationIsShowing:YES];
            return;
        }
        else if (self.animationStyle == YFPopViewAnimationStyleScale){
            [self executeTransformAnimationIsShowing:YES];
            return;
        }
        [self executeAnimationIsShowing:YES];
    }
}

- (void)settingSubViewsAnimationFromTopToBottom{
    startFrame = CGRectMake(subViewFrame.origin.x, -subViewFrame.size.height, subViewFrame.size.width, subViewFrame.size.height);
    endFrame = subViewFrame;
}
- (void)settingSubViewsAnimationFromLeftToRight{
    startFrame = CGRectMake(- subViewFrame.size.width, subViewFrame.origin.y, subViewFrame.size.width, subViewFrame.size.height);
    endFrame = subViewFrame;
}
- (void)settingSubViewsAnimationFromRightToLeft{
    startFrame = CGRectMake([UIScreen mainScreen].bounds.size.width, subViewFrame.origin.y, subViewFrame.size.width, subViewFrame.size.height);
    endFrame = subViewFrame;
}
- (void)settingSubViewsAnimationFromBottomToTop{
    startFrame = CGRectMake(subViewFrame.origin.x, [UIScreen mainScreen].bounds.size.height, subViewFrame.size.width, subViewFrame.size.height);
    endFrame = subViewFrame;
}

//线性动画
- (void)executeAnimationIsShowing:(BOOL)isShowing{
    if (!isShowing) {
        [self layoutIfNeeded];
        [self.animatedView setFrame:endFrame];
        [UIView animateWithDuration:self.duration animations:^{
            [self layoutIfNeeded];
            [self.animatedView setFrame:self->startFrame];
        }completion:^(BOOL finished) {
            [self removeFromSuperview];
        }];
    }
    else{
        [self layoutIfNeeded];
        [self.animatedView setFrame:startFrame];
        [UIView animateWithDuration:self.duration animations:^{
            [self layoutIfNeeded];
            [self.animatedView setFrame:self->endFrame];
        }];
    }
}
//淡入淡出动画
- (void)executeFadeAnimationIsShowing:(BOOL)isShowing{
    if (isShowing) {
        [self layoutIfNeeded];
        self.animatedView.alpha = 0;
        [UIView animateWithDuration:self.duration animations:^{
            [self layoutIfNeeded];
            self.animatedView.alpha = 1;
        }];
    }
    else{
        [self layoutIfNeeded];
        [self.animatedView setAlpha:1];
        [UIView animateWithDuration:self.duration animations:^{
            [self layoutIfNeeded];
            [self.animatedView setAlpha:0];
        }completion:^(BOOL finished) {
            [self removeFromSuperview];
        }];
    }
}
//缩放动画

- (void)executeTransformAnimationIsShowing:(BOOL)isShowing{
    if (isShowing) {
        [self layoutIfNeeded];
        self.animatedView.layer.transform = CATransform3DMakeScale(0.001, 0.001, 1);
        [UIView animateWithDuration:self.duration animations:^{
            [self layoutIfNeeded];
            self.animatedView.layer.transform = CATransform3DMakeScale(1, 1, 1);
        }];
    }
    else{
        [self layoutIfNeeded];
        self.animatedView.layer.transform = CATransform3DMakeScale(1, 1, 1);
        [UIView animateWithDuration:self.duration animations:^{
            [self layoutIfNeeded];
            self.animatedView.layer.transform = CATransform3DMakeScale(0.001, 0.001, 1);
        }completion:^(BOOL finished) {
            [self removeFromSuperview];
        }];
    }
}

@end
