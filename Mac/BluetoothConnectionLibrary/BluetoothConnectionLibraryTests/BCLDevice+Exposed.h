//
//  BCLDevice+Exposed.h
//  BluetoothConnectionLibrary
//
//  Created by Hunter Lang on 12/1/15.
//  Copyright © 2015 Zenel. All rights reserved.
//

#ifndef BCLDevice_Exposed_h
#define BCLDevice_Exposed_h

@import BluetoothConnectionLibrary;
#import "BCLCommand.h"
#import "BCLCharacteristicWrite.h"

NS_ASSUME_NONNULL_BEGIN

@interface BCLDevice (Exposed)

@property (strong, nonatomic) CBPeripheral *peripheral;
@property (strong, nonatomic) CBCharacteristic *writeCharacteristic;
@property (strong, nonatomic) NSMutableArray<id<BCLCommand>> *commandQueue;
@property (nonatomic) BOOL commandQueueStarted;
@property (strong, nonatomic) BCLCharacteristicWrite *currentWrite;

@end

NS_ASSUME_NONNULL_END

#endif /* BCLDevice_Exposed_h */
