//
//  NSObject+PerformOptionalSelector.h
//  BluetoothConnectionLibrary
//
//  Created by Hunter Lang on 12/1/15.
//  Copyright © 2015 Zenel. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (PerformOptionalSelector)

+ (void)performOptionalSelector:(SEL)selector onTarget:(id)target withArguments:(NSArray<NSObject *> *)args;

@end

NS_ASSUME_NONNULL_END