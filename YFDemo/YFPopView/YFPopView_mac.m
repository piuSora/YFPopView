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
    CGFloat endAlpha;
    
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
    endAlpha = self.animatedView.layer.opacity;
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
        [self executeAnimationIsShow:false];
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
        }
        [self executeAnimationIsShow:true];
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

- (void)executeAnimationIsShow:(BOOL)show{
    NSString *keyPath;
    NSValue *fromValue,*toValue,*presentValue;
    NSString *animationKey = animationShowKey;
    NSTimeInterval realDuration = self.duration;
    if (self.animationStyle < 10) {
        keyPath = @"position";
        CGPoint presentPosition = self.animatedView.layer.presentationLayer.position;
        presentValue = @(presentPosition);
        fromValue = [NSValue valueWithPoint:startFrame.origin];
        toValue = [NSValue valueWithPoint:endFrame.origin];
    }else if (self.animationStyle == YFPopViewAnimationStyleFade){
        keyPath = @"opacity";
        presentValue = @(self.animatedView.layer.presentationLayer.opacity);
        fromValue = @0;
        toValue = @(endAlpha);
    }else{
        keyPath = @"transform";
        presentValue = [NSValue valueWithCATransform3D:self.animatedView.layer.presentationLayer.transform];
        CATransform3D tr = CATransform3DTranslate(CATransform3DIdentity, self.animatedView.bounds.size.width / 2, self.animatedView.bounds.size.height / 2, 0);
        tr = CATransform3DScale(tr, 0.001, 0.001, 1);
        tr = CATransform3DTranslate(tr, -self.animatedView.bounds.size.width / 2, -self.animatedView.bounds.size.height / 2, 0);
        fromValue = [NSValue valueWithCATransform3D:tr];
        toValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
    }
    if (!show) {
        CGFloat ratio = 0;
        CALayer *presentLayer = self.animatedView.layer.presentationLayer;
        if (!CGPointEqualToPoint(presentLayer.position, startFrame.origin)) {
            CGPoint presentPosition = presentLayer.position;
            if (presentPosition.x != startFrame.origin.x) {
                ratio = fabs(presentPosition.x - startFrame.origin.x) / fabs(endFrame.origin.x - startFrame.origin.x);
            }else{
                ratio = fabs(presentPosition.y - startFrame.origin.y) / fabs(endFrame.origin.y - startFrame.origin.y);
            }
        }
        if (presentLayer.opacity != endAlpha) {
            ratio = presentLayer.opacity / endAlpha;
        }
        if (!CATransform3DEqualToTransform(presentLayer.transform, CATransform3DIdentity)) {
            ratio = [[presentLayer valueForKeyPath:@"transform.scale"] floatValue];
        }
        toValue = fromValue;
        fromValue = presentValue;
        realDuration = ratio * self.duration;
        [self.animatedView.layer removeAnimationForKey:animationShowKey];
        animationKey = animationRemoveKey;
    }
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:keyPath];
    animation.delegate = [TAWeakProxy weakProxyWithTarget:self];
    animation.fromValue = fromValue;
    animation.toValue = toValue;
    animation.duration = realDuration;
    animation.autoreverses = false;
    animation.fillMode = kCAFillModeForwards;
    animation.repeatCount = 0;
    animation.removedOnCompletion = false;
    [self.animatedView.layer addAnimation:animation forKey:animationKey];
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
