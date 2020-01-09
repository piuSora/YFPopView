//
//  YFPopView.m
//
//  Created by OS on 2018/3/29.
//  Copyright © 2018年 Piu. All rights reserved.
//
#import "YFPopView+Common.h"

#if TARGET_OS_IPHONE || TARGET_OS_TV
@interface YFPopView ()<UIGestureRecognizerDelegate>
@property (nonatomic, strong) UITapGestureRecognizer  *singleTap;
@end

@implementation YFPopView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        popViewFrame = frame;
        self.frame = frame;
        self.adjustedKeyboardEnable = false;
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:1.0/3.0];
        [self addGestureRecognizer:self.singleTap];
        [self loadPopView];
    }
    return self;
}

- (instancetype)initWithAnimationView:(__kindof UIView *)animationView{
    if (self = [super init]) {
        [self setAnimationView:animationView];
    }
    return self;
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch  {
    if (gestureRecognizer != self.singleTap) {
        return true;
    }
    if (!self.autoRemoveEnable) {
        return false;
    }
    if ([touch.view isDescendantOfView:self.animationView]) {
        return false;
    }
    return  true;
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
        self.frame = CGRectMake(self->popViewFrame.origin.x, self->popViewFrame.size.height - keyboardSize.height - self->popViewFrame.size.height, self->popViewFrame.size.width, self->popViewFrame.size.height);
    }];
    
}
- (void)keyboardWillBeHidden:(NSNotification*)aNotification{
    [self setFrame:CGRectMake(0, 0, popViewFrame.size.width, self->popViewFrame.size.height)];
}

#pragma mark - 展示

- (void)showPopViewOn:(YF_VIEW *)view{
    if (![self.gestureRecognizers containsObject:self.singleTap]) {
        [self addGestureRecognizer:self.singleTap];
    }
    if (self.adjustedKeyboardEnable) {
        [self registerForKeyboardNotifications];
    }
    [self _showPopViewOn:view];
}

#pragma mark - 移除

- (void)removeSelf{
    [self removeGestureRecognizer:self.singleTap];
    [self _removeSelf];
}

#pragma mark - setter & getter
- (UITapGestureRecognizer *)singleTap{
    if (!_singleTap) {
        _singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeSelf)];
        _singleTap.delegate = self;
    }
    return _singleTap;
}

- (void)setAnimationView:(YF_VIEW *)animationView{
    _animationView = animationView;
    [self _setAnimationView:animationView];
}

@end
#endif
