//
//  YFPopUtils.h
//  YFPopView_iOS
//
//  Created by 呼哈哈 on 2020/1/6.
//  Copyright © 2020 piu. All rights reserved.
//

#import <Foundation/Foundation.h>


#if TARGET_OS_IPHONE || TARGET_OS_TV
    #import <UIKit/UIKit.h>
    #define YF_VIEW UIView
    #define YF_NEED_LAYOUT(view) [view layoutIfNeeded];
#elif TARGET_OS_MAC
    #import <AppKit/AppKit.h>
    #define YF_VIEW NSView
    #define YF_COLOR NSColor
    #define YF_NEED_LAYOUT(view) [view layoutSubtreeIfNeeded];
#endif

static inline void yf_setAnchorPoint(YF_VIEW *view,CGPoint anchor){
    CGPoint newPoint = CGPointMake(view.bounds.size.width * anchor.x, view.bounds.size.height * anchor.y);
    CGPoint oldPoint = CGPointMake(view.bounds.size.width * view.layer.anchorPoint.x, view.bounds.size.height * view.layer.anchorPoint.y);
    newPoint = CGPointApplyAffineTransform(newPoint, view.layer.affineTransform);
    oldPoint = CGPointApplyAffineTransform(oldPoint, view.layer.affineTransform);
    
    CGPoint position = view.layer.position;
    position.x -= oldPoint.x;
    position.x += newPoint.x;
    
    position.y -= oldPoint.y;
    position.y += newPoint.y;
    
    view.layer.position = position;
    view.layer.anchorPoint = anchor;
}
