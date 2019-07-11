//
//  YFPopView.h
//
//  Created by OS on 2018/3/29.
//  Copyright © 2018年 Piu. All rights reserved.
//
#import <UIKit/UIKit.h>
@class YFPopView;
typedef void(^WillDismissBlock)(YFPopView *popView);
typedef void(^DidDismissBlock)(YFPopView *popView);
typedef void(^WillShowBlock)(YFPopView *popView);
typedef void(^DidShowBlock)(YFPopView *popView);

typedef NS_ENUM(NSUInteger, YFPopViewAnimationStyle) {
    YFPopViewAnimationStyleTopToBottom = 0,//从上至下
    YFPopViewAnimationStyleBottomToTop,
    YFPopViewAnimationStyleLeftToRight,
    YFPopViewAnimationStyleRightToLeft,
    YFPopViewAnimationStyleFade,//淡入淡出 *默认
    YFPopViewAnimationStyleScale,//缩放
};

@interface YFPopView : UIView

/*!
 @method
 @brief code创建的实例化方法 需要设置subView的frame 如果用autoLayout在展示以前设置他的约束
 @param subView 自定义view
 @return 实例化对象
 */

- (instancetype)initWithSubView:(__kindof UIView *)subView;

/*!
 @method
 @brief 移除弹窗
 */
- (void)removeSelf;

/*!
 @method
 @param view 覆盖的view
 @brief 显示弹窗
 */
- (void)showPopViewOn:(UIView *)view;


/// 动画效果 默认开启
@property (assign, nonatomic) BOOL animatedEnable;
/// 是否开启键盘调整 默认关闭
@property (assign, nonatomic) BOOL adjustedKeyboardEnable;
/// 动画时间 默认0.3s
@property (assign, nonatomic) NSTimeInterval duration;
/// 动画风格
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

@interface UIViewController (YFPopView)
/*!
 @method
 @param view 自定义的customView
 @brief 全屏显示弹窗 屏幕中间 大小为view的size
 */
- (void)showPopView:(__kindof UIView *)view;

@end
