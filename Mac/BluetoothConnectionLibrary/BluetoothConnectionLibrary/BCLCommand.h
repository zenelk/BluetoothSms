//
//  BCLCommand.h
//  BluetoothConnectionLibrary
//
//  Created by Hunter Lang on 12/2/15.
//  Copyright © 2015 Zenel. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    BCLCommandTypePing,
} BCLCommandType;

@protocol BCLCommand <NSObject>

- (BCLCommandType)commandType;
- (NSData *)commandData;

@end

NS_ASSUME_NONNULL_END