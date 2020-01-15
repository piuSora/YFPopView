//
//  TAWeakProxy.h
//  Tachyon
//
//  Created by 呼哈哈 on 2019/11/26.
//  Copyright © 2019 piu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>

NS_ASSUME_NONNULL_BEGIN

@interface TAWeakProxy : NSProxy <CAAnimationDelegate>

@property (nonatomic, weak, readonly) id target;
+ (instancetype)weakProxyWithTarget:(id)target;
- (instancetype)initWeakProxyWithTarget:(id)target;

@end

NS_ASSUME_NONNULL_END
