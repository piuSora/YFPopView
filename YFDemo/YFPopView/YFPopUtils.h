//
//  YFPopUtils.h
//  YFPopView_iOS
//
//  Created by 呼哈哈 on 2020/1/6.
//  Copyright © 2020 邹一帆. All rights reserved.
//

#import <Foundation/Foundation.h>


#if TARGET_OS_IPHONE || TARGET_OS_TV
    #import <UIKit/UIKit.h>
    #define YF_VIEW UIView
#elif TARGET_OS_MAC
    #import <AppKit/AppKit.h>
    #define YF_VIEW NSView
static inline void setAnchorPoint(NSView *view,CGPoint anchor){
    view.wantsLayer = true;
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
#endif
