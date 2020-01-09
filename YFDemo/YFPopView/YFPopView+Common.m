//
//  YFPopView+Common.m
//  YFPopView_iOS
//
//  Created by 呼哈哈 on 2020/1/8.
//  Copyright © 2020 piu. All rights reserved.
//

#import "YFPopView+Common.h"
#import <QuartzCore/QuartzCore.h>

@implementation YFPopView (Common)

#pragma mark - callback
- (void)loadPopView{
    removeLock = 0;
    self.layer.masksToBounds = true;
    self.autoRemoveEnable = true;
    self.duration = 0.3;
    self.animatedEnable = true;
    self.animationStyle = YFPopViewAnimationStyleFade;
}

- (void)_setAnimationView:(YF_VIEW *)view{
    endAlpha = self.animationView.layer.opacity;
    [self addSubview:view];
}

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

- (void)_showPopViewOn:(YF_VIEW *)view{
    removeLock = 1;
    [self willShowCallBack];
    if (!self.superview) {
        [view addSubview:self];
    }
    if (CGRectEqualToRect(CGRectZero, popViewFrame)) {
        popViewFrame = view.bounds;
    }
    self.frame = popViewFrame;
    [self settingSubViewsWithAnimated:self.animatedEnable Duration:self.duration];
}

#pragma mark - 设置动画

- (void)settingSubViewsWithAnimated:(BOOL)animated Duration:(NSTimeInterval)duration{
    if (animated) {
        YF_NEED_LAYOUT(self);
        if (CGRectEqualToRect(CGRectZero, subViewFrame)) {
            subViewFrame = self.animationView.frame;
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
#if TARGET_OS_IPHONE || TARGET_OS_TV
- (void)prepareAnimationFromTopToBottom{
    startFrame = CGRectMake(subViewFrame.origin.x, -subViewFrame.size.height, subViewFrame.size.width, subViewFrame.size.height);
    endFrame = subViewFrame;
}
- (void)prepareAnimationFromBottomToTop{
    startFrame = CGRectMake(subViewFrame.origin.x, popViewFrame.size.height, subViewFrame.size.width, subViewFrame.size.height);
    endFrame = subViewFrame;
}
#elif TARGET_OS_MAC
- (void)prepareAnimationFromTopToBottom{
    startFrame = CGRectMake(subViewFrame.origin.x, popViewFrame.size.height, subViewFrame.size.width, subViewFrame.size.height);
    endFrame = subViewFrame;
}
- (void)prepareAnimationFromBottomToTop{
    startFrame = CGRectMake(subViewFrame.origin.x, -subViewFrame.size.height, subViewFrame.size.width, subViewFrame.size.height);
    endFrame = subViewFrame;
}
#endif

- (void)prepareAnimationFromLeftToRight{
    startFrame = CGRectMake(- subViewFrame.size.width, subViewFrame.origin.y, subViewFrame.size.width, subViewFrame.size.height);
    endFrame = subViewFrame;
}
- (void)prepareAnimationFromRightToLeft{
    startFrame = CGRectMake(popViewFrame.size.width, subViewFrame.origin.y, subViewFrame.size.width, subViewFrame.size.height);
    endFrame = subViewFrame;
}
- (void)executeAnimationIsShow:(BOOL)show{
    NSString *keyPath;
    NSValue *fromValue,*toValue,*presentValue;
    NSString *animationKey = animationShowKey;
    NSTimeInterval realDuration = self.duration;
    yf_setAnchorPoint(self.animationView, CGPointMake(0, 0));
    if (self.animationStyle < 10) {
        self.animationView.frame = startFrame;
        if (startFrame.origin.y != endFrame.origin.y) {
            keyPath = @"position";
            fromValue = @(startFrame.origin);
            toValue = @(endFrame.origin);
        }else{
            keyPath = @"position";
            fromValue = @(startFrame.origin);
            toValue = @(endFrame.origin);
        }
        CGPoint presentPosition = self.animationView.layer.presentationLayer.position;
        presentValue = @(presentPosition);
    }else if (self.animationStyle == YFPopViewAnimationStyleFade){
        keyPath = @"opacity";
        presentValue = @(self.animationView.layer.presentationLayer.opacity);
        fromValue = @0;
        toValue = @(endAlpha);
    }else{
        keyPath = @"transform";
        presentValue = [NSValue valueWithCATransform3D:self.animationView.layer.presentationLayer.transform];
        CATransform3D tr = CATransform3DTranslate(CATransform3DIdentity, self.animationView.bounds.size.width / 2, self.animationView.bounds.size.height / 2, 0);
        tr = CATransform3DScale(tr, 0.001, 0.001, 1);
        tr = CATransform3DTranslate(tr, -self.animationView.bounds.size.width / 2, -self.animationView.bounds.size.height / 2, 0);
        fromValue = [NSValue valueWithCATransform3D:tr];
        toValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
    }
    if (!show) {
        CGFloat ratio = 0;
        CALayer *presentLayer = self.animationView.layer.presentationLayer;
        if (self.animationStyle < 10) {
            self.animationView.frame = endFrame;
            CGPoint presentPosition = presentLayer.position;
            if (presentPosition.x != startFrame.origin.x) {
                ratio = fabs(presentPosition.x - startFrame.origin.x) / fabs(endFrame.origin.x - startFrame.origin.x);
            }else{
                ratio = fabs(presentPosition.y - startFrame.origin.y) / fabs(endFrame.origin.y - startFrame.origin.y);
            }
        }else if (presentLayer.opacity != endAlpha) {
            ratio = presentLayer.opacity / endAlpha;
        }else if (!CATransform3DEqualToTransform(presentLayer.transform, CATransform3DIdentity)) {
            ratio = [[presentLayer valueForKeyPath:@"transform.scale"] floatValue];
        }
        toValue = fromValue;
        fromValue = presentValue;
        realDuration = ratio * self.duration;
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
    self.animationView.layer.contentsCenter  = self.layer.presentationLayer.contentsCenter;
    [self.animationView.layer removeAllAnimations];
    [self.animationView.layer addAnimation:animation forKey:animationKey];
}

- (void)removeSelfWithAnimated:(BOOL)animated{
    if (animated) {
        [self executeAnimationIsShow:false];
    }else{
        [self didRemove];
    }
}

- (void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    popViewFrame = frame;
}

- (void)didRemove{
    if (removeLock) {
        return;
    }
    [self didDismissCallBack];
    [self removeFromSuperview];
}

- (void)_removeSelf{
    removeLock = 0;
    [self willDismissCallBack];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self removeSelfWithAnimated:self.animatedEnable];
}

#pragma mark - CABasicAnimation Delegate

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    if ([anim isEqual:[self.animationView.layer animationForKey:animationShowKey]]) {
        if (self.animationStyle < 10) {
            self.animationView.frame = endFrame;
        }
        [self didShowCallBack];
    }else if([anim isEqual:[self.animationView.layer animationForKey:animationRemoveKey]]){
        if (self.animationStyle < 10) {
            self.animationView.frame = startFrame;
        }
        [self didRemove];
    }
}

@end
