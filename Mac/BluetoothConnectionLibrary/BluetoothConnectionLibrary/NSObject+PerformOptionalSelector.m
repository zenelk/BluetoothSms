//
//  NSObject+PerformOptionalSelector.m
//  BluetoothConnectionLibrary
//
//  Created by Hunter Lang on 12/1/15.
//  Copyright © 2015 Zenel. All rights reserved.
//

#import "NSObject+PerformOptionalSelector.h"

NS_ASSUME_NONNULL_BEGIN

@implementation NSObject (PerformOptionalSelector)

+ (void)performOptionalSelector:(SEL)selector onTarget:(id)target withArguments:(NSArray<NSObject *> *)args {
    if ([target respondsToSelector:selector]) {
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[target methodSignatureForSelector:selector]];
        invocation.target = target;
        invocation.selector = selector;
        for (int i = 0; i < args.count; ++i) {
            NSObject *o = args[i];
            [invocation setArgument:(void *)&o atIndex:2 + i];
        }
        [invocation invoke];
    }
}

@end

NS_ASSUME_NONNULL_END