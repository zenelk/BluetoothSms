//
//  ViewController.m
//  BluetoothSms
//
//  Created by Hunter Lang on 6/4/15.
//  Copyright (c) 2015 Zenel Kazushi. All rights reserved.
//

#import "ViewController.h"
#import <BluetoothConnectionLibrary/BluetoothConnectionLibrary.h>

NS_ASSUME_NONNULL_BEGIN

@interface ViewController () <BCLDeviceManagerDelegate>

@property (strong, nonatomic) BCLDeviceManager *deviceManager;
@property (strong, nonatomic) BCLDevice *device;

@end

@implementation ViewController

- (void)viewDidAppear {
    [super viewDidAppear];
    _deviceManager = [[BCLDeviceManager alloc] initWithDelegate:self];
    [_deviceManager startScanning];
}

#pragma mark BCLDeviceManagerDelegate Implementation

- (void)managerDidStartScanning:(BCLDeviceManager *)manager {
    
}

- (void)managerDidStopScanning:(BCLDeviceManager *)manager {
    
}

- (void)manager:(BCLDeviceManager *)scanner didDiscoverDevice:(BCLDevice *)device {
    if ([device.name isEqualToString:@"Nexus 5X"]) {
        [_deviceManager connectDevice:device];
    }
}

- (void)manager:(BCLDeviceManager *)manager didConnectDevice:(BCLDevice *)device {
    NSLog(@"Device connected");
    _device = device;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleDeviceDidInitializeNotification:) name:BCLDeviceDidInitializeNotification object:nil];
    [_device initialize];
}

- (void)manager:(BCLDeviceManager *)manager didDisconnectDevice:(BCLDevice *)device {
    
}

#pragma mark - BCLDevice Notification Handling

- (void)handleDeviceDidInitializeNotification:(NSNotification *)notification {
    NSLog(@"Device initialized, writing ping");
    [_device writeCommand:[BCLPingCommand new]];
}

@end

NS_ASSUME_NONNULL_END