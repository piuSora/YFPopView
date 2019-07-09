//
//  YFPopView.h
//
//  Created by OS on 2018/3/29.
//  Copyright © 2018年 Piu. All rights reserved.
//
#import <UIKit/UIKit.h>

typedef void(^OnRemoveBlock)(void);

typedef NS_ENUM(NSUInteger, YFPopViewAnimationStyle) {
    YFPopViewAnimationStyleTopToBottom = 0,//从上之下 *默认
    YFPopViewAnimationStyleBottomToTop,
    YFPopViewAnimationStyleLeftToRight,
    YFPopViewAnimationStyleRightToLeft,
    YFPopViewAnimationStyleFade,//淡入淡出
    YFPopViewAnimationStyleScale,//缩放
};

@interface YFPopView : UIView

/*!
 @method
 @brief xib创建的实例化方法
 @param nibName    xib名字
 @return 实例化对象
 */
+ (instancetype)instanceViewWithNibName:(NSString *)nibName;

/*!
 @method
 @brief code创建的实例化方法
 @return 实例化对象
 */
- (instancetype)init;

/*!
 @method
 @brief 移除弹窗
 */
- (void)removeSelf;

/*!
 @method
 @param view    展示弹窗的view
 @brief 显示弹窗
 */
- (void)showPopViewOn:(UIView *)view;


/**
 用于执行动画的view 在创建子类时传入需要执行动画的view
 */
@property (strong, nonatomic) UIView *animatedView;

/**
 动画效果 默认开启
 */
@property (assign, nonatomic) BOOL animatedEnable;

/**
 是否开启键盘调整 默认关闭
 */
@property (assign, nonatomic) BOOL adjustedKeyboardEnable;

/**
 动画时间 默认0.3s
 */
@property (assign, nonatomic) NSTimeInterval duration;

/**
 动画风格
 */
@property (assign, nonatomic) YFPopViewAnimationStyle animationStyle;

/**
 remove回调
 */
@property (nonatomic, strong) OnRemoveBlock onRemove;


@end
