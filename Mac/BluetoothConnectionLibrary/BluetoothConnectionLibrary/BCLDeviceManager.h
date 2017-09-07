//
//  BCLDeviceManager.h
//  BluetoothConnectionLibrary
//
//  Created by Hunter Lang on 12/1/15.
//  Copyright © 2015 Zenel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <BluetoothConnectionLibrary/BCLDevice.h>

NS_ASSUME_NONNULL_BEGIN

@class BCLDeviceManager;

@protocol BCLDeviceManagerDelegate <NSObject>

@optional
- (void)managerDidStartScanning:(BCLDeviceManager *)manager;
- (void)managerDidStopScanning:(BCLDeviceManager *)manager;
- (void)manager:(BCLDeviceManager *)manager didDiscoverDevice:(BCLDevice *)device;
- (void)manager:(BCLDeviceManager *)manager didConnectDevice:(BCLDevice *)device;
- (void)manager:(BCLDeviceManager *)manager didDisconnectDevice:(BCLDevice *)device;

@end

@interface BCLDeviceManager : NSObject

- (instancetype)initWithDelegate:(nullable id<BCLDeviceManagerDelegate>)delegate;
- (void)startScanning;
- (void)stopScanning;
- (void)connectDevice:(BCLDevice *)device;
- (void)disconnectDevice:(BCLDevice *)device;

@end

NS_ASSUME_NONNULL_END