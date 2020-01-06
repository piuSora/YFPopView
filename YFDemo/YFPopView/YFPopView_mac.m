//
//  YFPopView.m
//
//  Created by OS on 2018/3/29.
//  Copyright © 2018 Piu. All rights reserved.
//

#import "YFPopView.h"
#if TARGET_OS_IPHONE || TARGET_OS_TV
#elif TARGET_OS_MAC
#import "TAWeakProxy.h"
#import <QuartzCore/QuartzCore.h>
@interface YFPopView ()<CAAnimationDelegate>
{
    CGRect superViewFrame;
    CGRect subViewFrame;
    CGRect startFrame;
    CGRect endFrame;
    
    int removeLock;
}
@property (strong, nonatomic) NSView *animatedView;

@end

static NSString *animationShowKey = @"popview_show";
static NSString *animationRemoveKey = @"popview_remove";

@implementation YFPopView

- (instancetype)init{
    if (self = [super init]) {
        [self loadPopView];
    }
    return self;
}

//disable mouse click through, auto remove
- (void)mouseDown:(NSEvent *)event{
    if (!self.autoRemoveEnable || !removeLock) {
        return;
    }
    CGPoint point = [self convertPoint:event.locationInWindow toView:self.animatedView];
    if (point.x < 0 ||
        point.x > subViewFrame.size.width ||
        point.y < 0 ||
        point.y > subViewFrame.size.height) {
        [self removeSelf];
    }
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        superViewFrame = frame;
        self.frame = frame;
        [self loadPopView];
    }
    return self;
}

- (instancetype)initWithSubView:(__kindof NSView *)subView{
    if (self = [super init]) {
        [self addSubview:subView];
        [self loadPopView];
    }
    return self;
}

- (void)loadPopView{
    self.wantsLayer = true;
    self.layer.backgroundColor = [NSColor colorWithRed:0 green:0 blue:0 alpha:0.7].CGColor;
    removeLock = 0;
    self.layer.masksToBounds = true;
    self.duration = 0.3;
    self.autoRemoveEnable = true;
    self.animatedEnable = true;
    self.animationStyle = YFPopViewAnimationStyleFade;
}

- (void)addSubview:(NSView *)view{
    self.animatedView = view;
    self.animatedView.wantsLayer = true;
    self.wantsLayer = true;
    [super addSubview:view];
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

#pragma mark - display

- (void)showPopViewOn:(NSView *)view{
    removeLock = 1;
    [self willShowCallBack];
    if (!self.superview) {
        [view addSubview:self];
    }
    if (CGRectEqualToRect(CGRectZero, superViewFrame)) {
        superViewFrame = view.bounds;
    }
    self.frame = superViewFrame;
    [self settingSubViewsWithAnimated:self.animatedEnable Duration:self.duration];
}

#pragma mark - remove

- (void)removeSelf{
    removeLock = 0;
    [self willDismissCallBack];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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

#pragma mark - setting animation

- (void)settingSubViewsWithAnimated:(BOOL)animated Duration:(NSTimeInterval)duration{
    if (animated) {
        [self layoutSubtreeIfNeeded];
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
    }else{
        [self didShowCallBack];
    }
}

- (void)prepareAnimationFromTopToBottom{
    startFrame = CGRectMake(subViewFrame.origin.x, superViewFrame.size.height, subViewFrame.size.width, subViewFrame.size.height);
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
    startFrame = CGRectMake(subViewFrame.origin.x, -subViewFrame.size.height, subViewFrame.size.width, subViewFrame.size.height);
    endFrame = subViewFrame;
}

- (void)executeAnimationIsShowing:(BOOL)isShowing{
    if (isShowing) {
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
        animation.delegate = [TAWeakProxy weakProxyWithTarget:self];
        animation.fromValue = [NSValue valueWithPoint:startFrame.origin];
        animation.toValue = [NSValue valueWithPoint:endFrame.origin];
        animation.duration = self.duration;
        animation.autoreverses = false;
        animation.fillMode = kCAFillModeForwards;
        animation.repeatCount = 0;
        animation.removedOnCompletion = false;
        [self.animatedView.layer addAnimation:animation forKey:animationShowKey];
    }else{
        CGFloat ratio = 0;
        CGPoint presentPosition = self.animatedView.layer.presentationLayer.position;
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
        TAWeakProxy *proxy = [TAWeakProxy weakProxyWithTarget:self];
        animation.delegate = proxy;
        animation.fromValue = [NSValue valueWithPoint:presentPosition];
        animation.toValue = [NSValue valueWithPoint:startFrame.origin];
        if (presentPosition.x != startFrame.origin.x) {
            ratio = fabs(presentPosition.x - startFrame.origin.x) / fabs(endFrame.origin.x - startFrame.origin.x);
        }else{
            ratio = fabs(presentPosition.y - startFrame.origin.y) / fabs(endFrame.origin.y - startFrame.origin.y);
        }
        animation.duration = self.duration * ratio;
        animation.autoreverses = false;
        animation.fillMode = kCAFillModeForwards;
        animation.removedOnCompletion = false;
        animation.repeatCount = 0;
        //must remove last animation
        [self.animatedView.layer removeAnimationForKey:animationShowKey];
        [self.animatedView.layer addAnimation:animation forKey:animationRemoveKey];
    }
}

- (void)executeFadeAnimationIsShowing:(BOOL)isShowing{
    if (isShowing) {
        self.animatedView.alphaValue = 0;
        [NSAnimationContext runAnimationGroup:^(NSAnimationContext * _Nonnull context) {
            [context setDuration:self.duration];
            [self.animatedView.animator setAlphaValue:1];
        } completionHandler:^{
            [self didShowCallBack];
        }];
    }else{
        [self.animatedView setAlphaValue:1];
        [NSAnimationContext runAnimationGroup:^(NSAnimationContext * _Nonnull context) {
            [context setDuration:self.duration];
            [self.animatedView.animator setAlphaValue:0];
        } completionHandler:^{
            [self didRemove];
        }];
    }
}


- (void)executeTransformAnimationIsShowing:(BOOL)isShowing{
    if (isShowing) {
        //设置锚点失效，采用缩放的同时位移完成
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform"];
        CATransform3D tr = CATransform3DIdentity;
        tr = CATransform3DTranslate(tr, self.animatedView.bounds.size.width / 2, self.animatedView.bounds.size.height / 2, 0);
        tr = CATransform3DScale(tr, 0.001, 0.001, 1);
        tr = CATransform3DTranslate(tr, -self.animatedView.bounds.size.width / 2, -self.animatedView.bounds.size.height / 2, 0);
        animation.delegate = [TAWeakProxy weakProxyWithTarget:self];
        animation.duration = self.duration;
        animation.autoreverses = false;
        animation.repeatCount = 0;
        animation.removedOnCompletion = false;
        animation.fillMode = kCAFillModeForwards;
        animation.fromValue = [NSValue valueWithCATransform3D:tr];
        animation.toValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
        [self.animatedView.layer addAnimation:animation forKey:animationShowKey];
    }else{
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform"];
        CATransform3D tr = CATransform3DIdentity;
        tr = CATransform3DTranslate(tr, self.animatedView.bounds.size.width / 2, self.animatedView.bounds.size.height / 2, 0);
        tr = CATransform3DScale(tr, 0.001, 0.001, 1);
        tr = CATransform3DTranslate(tr, -self.animatedView.bounds.size.width / 2, -self.animatedView.bounds.size.height / 2, 0);
        animation.delegate = [TAWeakProxy weakProxyWithTarget:self];
        animation.duration = self.duration;
        animation.autoreverses = false;
        animation.repeatCount = 0;
        animation.removedOnCompletion = false;
        animation.fillMode = kCAFillModeForwards;
        animation.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
        animation.toValue = [NSValue valueWithCATransform3D:tr];
        [self.animatedView.layer addAnimation:animation forKey:animationRemoveKey];
//        [self.animatedView.layer removeAllAnimations];
    
    }
}

#pragma mark - CABasicAnimation Delegate

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    if ([anim isEqual:[self.animatedView.layer animationForKey:animationShowKey]]) {
        [self didShowCallBack];
    }else if([anim isEqual:[self.animatedView.layer animationForKey:animationRemoveKey]]){
        [self didRemove];
    }
}

#pragma mark - setter & getter

- (void)setAnimationStyle:(YFPopViewAnimationStyle)animationStyle{
    _animationStyle = animationStyle;
}

@end
#endif
