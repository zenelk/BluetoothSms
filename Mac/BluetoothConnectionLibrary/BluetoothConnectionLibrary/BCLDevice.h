//
//  BCLDevice.h
//  BluetoothConnectionLibrary
//
//  Created by Hunter Lang on 12/1/15.
//  Copyright © 2015 Zenel. All rights reserved.
//

#import <Foundation/Foundation.h>
@import CoreBluetooth;
#import "BCLCommand.h"

NS_ASSUME_NONNULL_BEGIN

extern NSString * const BCLDeviceDidInitializeNotification;

typedef enum : NSUInteger {
    BCLDeviceStateDisconnected,
    BCLDeviceStateConnecting,
    BCLDeviceStateConnected,
    BCLDeviceStateInitializing,
    BCLDeviceStateInitialized,
    BCLDeviceStateDisconnecting,
} BCLDeviceState;

@interface BCLDevice : NSObject

@property (nonatomic) BCLDeviceState state;
@property (strong, nonatomic, readonly) NSString *name;
@property (strong, nonatomic, readonly) CBPeripheral *peripheral;

- (instancetype)initWithPeripheral:(CBPeripheral *)peripheral;
- (void)initialize;
- (void)writeCommand:(id<BCLCommand>)command;

@end

NS_ASSUME_NONNULL_END