//
//  YFPopView+Common.h
//  YFPopView_iOS
//
//  Created by 呼哈哈 on 2020/1/8.
//  Copyright © 2020 piu. All rights reserved.
//
#import "YFPopView.h"
#import "YFPopUtils.h"
#import "TAWeakProxy.h"

NS_ASSUME_NONNULL_BEGIN

static NSString *animationShowKey = @"popview_show";
static NSString *animationRemoveKey = @"popview_remove";

@interface YFPopView ()
{
    CGRect superViewFrame;
    CGRect subViewFrame;
    CGRect startFrame;
    CGRect endFrame;
    CGFloat endAlpha;
    
    int removeLock;
}
@end

@interface YFPopView (Common)

- (void)loadPopView;

- (void)removeSelfWithAnimated:(BOOL)animated;
- (void)_showPopViewOn:(YF_VIEW *)view;
- (void)_removeSelf;
- (void)_setAnimationView:(YF_VIEW *)view;

@end

NS_ASSUME_NONNULL_END
