//
//  BCLPingCommand.m
//  BluetoothConnectionLibrary
//
//  Created by Hunter Lang on 12/2/15.
//  Copyright © 2015 Zenel. All rights reserved.
//

#import "BCLPingCommand.h"

NS_ASSUME_NONNULL_BEGIN

@implementation BCLPingCommand

- (BCLCommandType)commandType {
    return BCLCommandTypePing;
}

- (NSData *)commandData {
    BCLCommandType commandType = self.commandType;
    return [NSData dataWithBytes:&commandType length:1];
}

@end

NS_ASSUME_NONNULL_END
