//
//  CBCentralManager+Mock.m
//  BluetoothConnectionLibrary
//
//  Created by Hunter Lang on 12/1/15.
//  Copyright © 2015 Zenel. All rights reserved.
//

#import "CBCentralManager+Mock.h"

NS_ASSUME_NONNULL_BEGIN

@implementation CBCentralManager (Mock)

- (void)powerOn {
    [self setValue:@(CBCentralManagerStatePoweredOn) forKey:@"state"];
    [self.delegate centralManagerDidUpdateState:self];
}

- (void)discoverPeripheral:(CBPeripheral *)peripheral {
    [self.delegate centralManager:self didDiscoverPeripheral:peripheral advertisementData:@{} RSSI:@(127)];
}

- (void)connectPeripheral:(CBPeripheral *)peripheral {
    [self.delegate centralManager:self didConnectPeripheral:peripheral];
}

- (void)disconnectPeripheral:(CBPeripheral *)peripheral {
    [self.delegate centralManager:self didDisconnectPeripheral:peripheral error:nil];
}

@end

NS_ASSUME_NONNULL_END