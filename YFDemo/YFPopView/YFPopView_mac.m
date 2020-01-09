//
//  YFPopView.m
//
//  Created by OS on 2018/3/29.
//  Copyright © 2018 Piu. All rights reserved.
//

#import "YFPopView+Common.h"
#if TARGET_OS_IPHONE || TARGET_OS_TV
#elif TARGET_OS_MAC
@interface YFPopView ()

@end

@implementation YFPopView

//disable mouse click through, auto remove
- (void)mouseDown:(NSEvent *)event{
    if (!self.autoRemoveEnable || !removeLock) {
        return;
    }
    CGPoint point = [self convertPoint:event.locationInWindow toView:self.animationView];
    if (point.x < 0 ||
        point.x > subViewFrame.size.width ||
        point.y < 0 ||
        point.y > subViewFrame.size.height) {
        [self removeSelf];
    }
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        popViewFrame = frame;
        self.frame = frame;
        self.wantsLayer = true;
        self.layer.backgroundColor = [NSColor colorWithRed:0 green:0 blue:0 alpha:0.7].CGColor;
        [self loadPopView];
    }
    return self;
}

- (instancetype)initWithAnimationView:(__kindof NSView *)animationView{
    if (self = [super init]) {
        [self setAnimationView:animationView];
    }
    return self;
}

#pragma mark - display

- (void)showPopViewOn:(YF_VIEW *)view{
    [self _showPopViewOn:view];
}

- (void)removeSelf{
    [self _removeSelf];
}

#pragma mark - setter & getter

- (void)setAnimationView:(NSView *)animationView{
    _animationView = animationView;
    self.animationView.wantsLayer = true;
    [self _setAnimationView:animationView];
}

@end
#endif
