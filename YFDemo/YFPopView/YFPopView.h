//
//  YFPopView.h
//
//  Created by OS on 2018/3/29.
//  Copyright © 2018年 Piu. All rights reserved.
//
#import <Foundation/Foundation.h>

@class YFPopView;
typedef void(^WillDismissBlock)(YFPopView *popView);
typedef void(^DidDismissBlock)(YFPopView *popView);
typedef void(^WillShowBlock)(YFPopView *popView);
typedef void(^DidShowBlock)(YFPopView *popView);

typedef NS_ENUM(NSUInteger, YFPopViewAnimationStyle) {
    YFPopViewAnimationStyleTopToBottom = 0,
    YFPopViewAnimationStyleBottomToTop,
    YFPopViewAnimationStyleLeftToRight,
    YFPopViewAnimationStyleRightToLeft,
    YFPopViewAnimationStyleFade,//fade in fade out *default
    YFPopViewAnimationStyleScale,
};

#if TARGET_OS_IPHONE || TARGET_OS_TV
    #import <UIKit/UIKit.h>
    #define YF_VIEW UIView
#elif TARGET_OS_MAC
    #import <AppKit/AppKit.h>
    #define YF_VIEW NSView
#endif

@interface YFPopView : YF_VIEW

/*!
 @method
 @brief  initial method add a custom subView on popView, need to set up subView's frame or constraints
 @param subView the custom view
 @return instance object
 */

- (instancetype)initWithSubView:(__kindof YF_VIEW*)subView;

/*!
 @method
 @brief remove pop-up view
 */
- (void)removeSelf;

/*!
 @method
 @param view the pop-up view will cover on
 @brief show the pop-up view
 */
- (void)showPopViewOn:(YF_VIEW *)view;

#if TARGET_OS_IPHONE || TARGET_OS_TV
/// adjust subview's frame when keyboard show,default is off
@property (assign, nonatomic) BOOL adjustedKeyboardEnable;
#endif
/// enable animation,default is on
@property (assign, nonatomic) BOOL animatedEnable;
/// auto remove popView when click out range of the subview,default is on
@property (nonatomic, assign) BOOL autoRemoveEnable;
/// animation duration default is 0.3s
@property (assign, nonatomic) NSTimeInterval duration;
/// animation style default is Fade
@property (assign, nonatomic) YFPopViewAnimationStyle animationStyle;

/// call back when popup view will dismiss
@property (nonatomic, strong) WillDismissBlock willDismiss;
/// call back when popup view did dismiss
@property (nonatomic, strong) DidDismissBlock didDismiss;
/// call back when popup view will show
@property (nonatomic, strong) WillShowBlock willShow;
/// call back when popup view did show
@property (nonatomic, strong) DidShowBlock didShow;


@end