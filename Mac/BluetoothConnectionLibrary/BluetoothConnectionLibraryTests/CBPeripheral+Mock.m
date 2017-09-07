//
//  CBPeripheral+Mock.m
//  BluetoothConnectionLibrary
//
//  Created by Hunter Lang on 12/2/15.
//  Copyright © 2015 Zenel. All rights reserved.
//

#import "CBPeripheral+Mock.h"

NS_ASSUME_NONNULL_BEGIN

@implementation CBPeripheral (Mock)

- (void)discoverService:(CBUUID *)serviceUUID {
    CBService *mockService = [[CBService alloc] init];
    [mockService setValue:serviceUUID forKey:@"UUID"];
    [self setValue:@[ mockService ] forKey:@"services"];
    [self.delegate peripheral:self didDiscoverServices:nil];
}

- (void)discoverCharacteristic:(CBUUID *)characteristicUUID forService:(CBUUID *)serviceUUID {
    CBService *serviceForUUID;
    for (CBService *service in self.services) {
        if ([service.UUID isEqual:serviceUUID]) {
            serviceForUUID = service;
        }
    }
    if (!serviceForUUID) {
        @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:@"Could not find service that the characteristic is reportedly from" userInfo:nil];
    }
    CBCharacteristic *mockCharacteristic = [[CBCharacteristic alloc] init];
    [mockCharacteristic setValue:characteristicUUID forKey:@"UUID"];
    [serviceForUUID setValue:@[ mockCharacteristic ] forKey:@"characteristics"];
    [self.delegate peripheral:self didDiscoverCharacteristicsForService:serviceForUUID error:nil];
}

- (void)didWriteValueForCharacteristic:(CBCharacteristic *)characteristic {
    [self.delegate peripheral:self didWriteValueForCharacteristic:characteristic error:nil];
}

@end

NS_ASSUME_NONNULL_END