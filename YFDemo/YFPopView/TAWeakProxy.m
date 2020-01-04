//
//  TAWeakProxy.m
//  Tachyon
//
//  Created by 呼哈哈 on 2019/11/26.
//  Copyright © 2019 piu. All rights reserved.
//

#import "TAWeakProxy.h"

@implementation TAWeakProxy

- (instancetype)initWeakProxyWithTarget:(id)target{
    _target = target;
    return self;
}

+ (instancetype)weakProxyWithTarget:(id)target{
    return [[self alloc] initWeakProxyWithTarget:target];
}

- (void)forwardInvocation:(NSInvocation *)invocation{
    SEL sel = [invocation selector];
    if ([self.target respondsToSelector:sel]) {
        [invocation invokeWithTarget:self.target];
    }
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)sel{
    return [self.target methodSignatureForSelector:sel];
}

-(BOOL)respondsToSelector:(SEL)aSelector{
    return [self.target respondsToSelector:aSelector];
}

@end
