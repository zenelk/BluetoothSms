//
//  CBPeripheral+Mock.h
//  BluetoothConnectionLibrary
//
//  Created by Hunter Lang on 12/2/15.
//  Copyright © 2015 Zenel. All rights reserved.
//

#import <Foundation/Foundation.h>
@import CoreBluetooth;

NS_ASSUME_NONNULL_BEGIN

@interface CBPeripheral (Mock)

- (void)discoverService:(CBUUID *)serviceUUID;
- (void)discoverCharacteristic:(CBUUID *)characteristicUUID forService:(CBUUID *)serviceUUID;
- (void)didWriteValueForCharacteristic:(CBCharacteristic *)characteristic;

@end

NS_ASSUME_NONNULL_END