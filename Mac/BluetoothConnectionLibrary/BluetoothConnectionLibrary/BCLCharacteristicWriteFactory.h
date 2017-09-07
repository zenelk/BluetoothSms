//
//  BCLCharacteristicWriteFactory.h
//  BluetoothConnectionLibrary
//
//  Created by Hunter Lang on 12/2/15.
//  Copyright © 2015 Zenel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BCLCharacteristicWrite.h"

NS_ASSUME_NONNULL_BEGIN

@interface BCLCharacteristicWriteFactory : NSObject

+ (NSArray<BCLCharacteristicWrite *> *)generateWritesForCharacteristic:(CBCharacteristic *)characteristic usingData:(NSData *)data;

@end

NS_ASSUME_NONNULL_END
