//
//  YFPopView.m
//
//  Created by OS on 2018/3/29.
//  Copyright © 2018年 Piu. All rights reserved.
//

#import "YFPopView.h"
@interface YFPopView ()<UIGestureRecognizerDelegate>
{
    CGRect superViewFrame;
    CGRect subViewFrame;
    CGRect startFrame;
    CGRect endFrame;
    
    int removeLock;
}
@property (nonatomic, strong) UITapGestureRecognizer  *singleTap;
@property (strong, nonatomic) UIView *animatedView;

@end

@implementation YFPopView

- (instancetype)init{
    if (self = [super init]) {
        [self loadPopView];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        superViewFrame = frame;
        self.frame = frame;
        [self loadPopView];
    }
    return self;
}

- (instancetype)initWithSubView:(__kindof UIView *)subView{
    if (self = [super init]) {
        [self addSubview:subView];
        [self loadPopView];
    }
    return self;
}

- (void)loadPopView{
    removeLock = 0;
    self.layer.masksToBounds = true;
    [self addGestureRecognizer:self.singleTap];
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:1.0/3.0];
    self.adjustedKeyboardEnable = false;
    self.duration = 0.3;
    self.animatedEnable = true;
    self.animationStyle = YFPopViewAnimationStyleFade;
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch  {
    // 输出点击的view的类名
    // 若为UITableViewCellContentView（即点击了tableViewCell），则不截获Touch事件
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"] || [touch.view isDescendantOfView:self.animatedView]) {
        return NO;
    }
    return  YES;
}

- (void)addSubview:(UIView *)view{
    self.animatedView = view;
    [super addSubview:view];
}

#pragma mark - 监听键盘
- (void)registerForKeyboardNotifications{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShown:)
                                                 name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
}
//键盘出现的时候计算键盘的高度大小
- (void)keyboardWillShown:(NSNotification*)aNotification{
    NSDictionary *info = [aNotification userInfo];
    CGFloat duration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    NSValue *value = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGSize keyboardSize = [value CGRectValue].size;
    
    [UIView animateWithDuration:duration animations:^{
        self.frame = CGRectMake(self->superViewFrame.origin.x, self->superViewFrame.size.height - keyboardSize.height - self->superViewFrame.size.height, self->superViewFrame.size.width, self->superViewFrame.size.height);
    }];
    
}
- (void)keyboardWillBeHidden:(NSNotification*)aNotification{
    [self setFrame:CGRectMake(0, 0, superViewFrame.size.width, self->superViewFrame.size.height)];
}
#pragma mark - callback

- (void)willShowCallBack{
    if (self.willShow) {
        self.willShow(self);
    }
}
- (void)willDismissCallBack{
    if (self.willDismiss) {
        self.willDismiss(self);
    }
}
- (void)didDismissCallBack{
    if (self.didDismiss) {
        self.didDismiss(self);
    }
}
- (void)didShowCallBack{
    if (self.didShow) {
        self.didShow(self);
    }
}

#pragma mark - 展示

- (void)showPopViewOn:(UIView *)view{
    removeLock = 1;
    [self willShowCallBack];
    if (self.willShow) {
        self.willShow(self);
    }
    if (!self.superview) {
        [view addSubview:self];
    }
    if (CGRectEqualToRect(CGRectZero, superViewFrame)) {
        superViewFrame = view.bounds;
    }
    self.frame = superViewFrame;
    if (![self.gestureRecognizers containsObject:self.singleTap]) {
        [self addGestureRecognizer:self.singleTap];
    }
    if (self.adjustedKeyboardEnable) {
        //注册键盘监听
        [self registerForKeyboardNotifications];
    }
    [self settingSubViewsWithAnimated:self.animatedEnable Duration:self.duration];
}

#pragma mark - 移除

- (void)removeSelf{
    removeLock = 0;
    [self willDismissCallBack];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self removeGestureRecognizer:self.singleTap];
    [self removeSelfWithAnimated:self.animatedEnable];
}

- (void)removeSelfWithAnimated:(BOOL)animated{
    if (animated) {
        if (self.animationStyle == YFPopViewAnimationStyleScale) {
            [self executeTransformAnimationIsShowing:NO];
            return;
        }else if (self.animationStyle == YFPopViewAnimationStyleFade){
            [self executeFadeAnimationIsShowing:NO];
            return;
        }
        [self executeAnimationIsShowing:NO];
    }else{
        [self didRemove];
    }
}

- (void)didRemove{
    if (removeLock) {
        return;
    }
    [self didDismissCallBack];
    [self removeFromSuperview];
}

#pragma mark - 设置动画

- (void)settingSubViewsWithAnimated:(BOOL)animated Duration:(NSTimeInterval)duration{
    if (animated) {
        [self layoutIfNeeded];
        if (CGRectEqualToRect(CGRectZero, subViewFrame)) {
            subViewFrame = self.animatedView.frame;
        }
        if (self.animationStyle == YFPopViewAnimationStyleBottomToTop) {
            [self prepareAnimationFromBottomToTop];
        }else if (self.animationStyle == YFPopViewAnimationStyleTopToBottom){
            [self prepareAnimationFromTopToBottom];
        }else if (self.animationStyle == YFPopViewAnimationStyleRightToLeft){
            [self prepareAnimationFromRightToLeft];
        }else if (self.animationStyle == YFPopViewAnimationStyleLeftToRight){
            [self prepareAnimationFromLeftToRight];
        }else if (self.animationStyle == YFPopViewAnimationStyleFade){
            [self executeFadeAnimationIsShowing:YES];return;
        }else if (self.animationStyle == YFPopViewAnimationStyleScale){
            [self executeTransformAnimationIsShowing:YES];return;
        }
        [self executeAnimationIsShowing:YES];
    }
}

- (void)prepareAnimationFromTopToBottom{
    startFrame = CGRectMake(subViewFrame.origin.x, -subViewFrame.size.height, subViewFrame.size.width, subViewFrame.size.height);
    endFrame = subViewFrame;
}
- (void)prepareAnimationFromLeftToRight{
    startFrame = CGRectMake(- subViewFrame.size.width, subViewFrame.origin.y, subViewFrame.size.width, subViewFrame.size.height);
    endFrame = subViewFrame;
}
- (void)prepareAnimationFromRightToLeft{
    startFrame = CGRectMake(superViewFrame.size.width, subViewFrame.origin.y, subViewFrame.size.width, subViewFrame.size.height);
    endFrame = subViewFrame;
}
- (void)prepareAnimationFromBottomToTop{
    startFrame = CGRectMake(subViewFrame.origin.x, superViewFrame.size.height, subViewFrame.size.width, subViewFrame.size.height);
    endFrame = subViewFrame;
}

//线性动画
- (void)executeAnimationIsShowing:(BOOL)isShowing{
    if (isShowing) {
        [self layoutIfNeeded];
        [self.animatedView setFrame:startFrame];
        [UIView animateWithDuration:self.duration animations:^{
            [self layoutIfNeeded];
            [self.animatedView setFrame:self->endFrame];
        }completion:^(BOOL finished) {
            [self didShowCallBack];
        }];
    }else{
        [self layoutIfNeeded];
        [self.animatedView setFrame:endFrame];
        [UIView animateWithDuration:self.duration animations:^{
            [self layoutIfNeeded];
            [self.animatedView setFrame:self->startFrame];
        }completion:^(BOOL finished) {
            [self didRemove];
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
        }completion:^(BOOL finished) {
            [self didShowCallBack];
        }];
    }else{
        [self layoutIfNeeded];
        [self.animatedView setAlpha:1];
        [UIView animateWithDuration:self.duration animations:^{
            [self layoutIfNeeded];
            [self.animatedView setAlpha:0];
        }completion:^(BOOL finished) {
            [self didRemove];
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
        }completion:^(BOOL finished) {
            [self didShowCallBack];
        }];
    }else{
        [self layoutIfNeeded];
        self.animatedView.layer.transform = CATransform3DMakeScale(1, 1, 1);
        [UIView animateWithDuration:self.duration animations:^{
            [self layoutIfNeeded];
            self.animatedView.layer.transform = CATransform3DMakeScale(0.001, 0.001, 1);
        }completion:^(BOOL finished) {
            [self didRemove];
        }];
    }
}

#pragma mark - setter & getter
- (UITapGestureRecognizer *)singleTap{
    if (!_singleTap) {
        _singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeSelf)];
        _singleTap.delegate = self;
    }
    return _singleTap;
}

@end

#import "YFPopView.h"

@implementation UIViewController (YFPopView)

- (void)showPopView:(__kindof UIView *)view{
    CGSize screenSize = UIScreen.mainScreen.bounds.size;
    CGSize viewSize = view.frame.size;
    view.frame = (CGRect){.origin = CGPointMake((screenSize.width - viewSize.width)/2.0, (screenSize.height - viewSize.height) / 2.0), .size = view.frame.size};
    YFPopView *popView = [[YFPopView alloc] initWithSubView:view];
    [popView showPopViewOn:UIApplication.sharedApplication.keyWindow];
}

@end
