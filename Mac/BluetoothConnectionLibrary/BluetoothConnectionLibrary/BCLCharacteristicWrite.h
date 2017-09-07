//
//  BCLCharacteristicWrite.h
//  BluetoothConnectionLibrary
//
//  Created by Hunter Lang on 12/2/15.
//  Copyright © 2015 Zenel. All rights reserved.
//

#import <Foundation/Foundation.h>
@import CoreBluetooth;

NS_ASSUME_NONNULL_BEGIN

@interface BCLCharacteristicWrite : NSObject

@property (strong, nonatomic, readonly) CBCharacteristic *characteristic;
@property (strong, nonatomic, readonly) NSData *data;
@property (nonatomic, readonly) BOOL requestResponse;
@property (nonatomic, readonly) BOOL isLast;

+ (instancetype)characteristicWriteWithCharacteristic:(CBCharacteristic *)characteristic data:(NSData *)data requestResponse:(BOOL)requestResponse isLast:(BOOL)isLast;

- (instancetype)initWithCharacteristic:(CBCharacteristic *)charateristic data:(NSData *)data requestResponse:(BOOL)requestResponse isLast:(BOOL)isLast;

@end

NS_ASSUME_NONNULL_END