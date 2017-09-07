//
//  CBCentralManager+Mock.h
//  BluetoothConnectionLibrary
//
//  Created by Hunter Lang on 12/1/15.
//  Copyright © 2015 Zenel. All rights reserved.
//

#import <Foundation/Foundation.h>
@import CoreBluetooth;

NS_ASSUME_NONNULL_BEGIN

@interface CBCentralManager (Mock)

- (void)powerOn;
- (void)discoverPeripheral:(CBPeripheral *)peripheral;
- (void)connectPeripheral:(CBPeripheral *)peripheral;
- (void)disconnectPeripheral:(CBPeripheral *)peripheral;

@end

NS_ASSUME_NONNULL_END