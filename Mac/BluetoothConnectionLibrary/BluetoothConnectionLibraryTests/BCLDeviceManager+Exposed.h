//
//  BCLDeviceManager+Exposed.h
//  BluetoothConnectionLibrary
//
//  Created by Hunter Lang on 12/1/15.
//  Copyright © 2015 Zenel. All rights reserved.
//

#ifndef BCLDeviceManager_Exposed_h
#define BCLDeviceManager_Exposed_h

@import CoreBluetooth;
@import BluetoothConnectionLibrary;

NS_ASSUME_NONNULL_BEGIN

@interface BCLDeviceManager (Exposed)

@property (strong, nonatomic) CBCentralManager *centralManager;

@end

NS_ASSUME_NONNULL_END

#endif /* BCLDeviceManager_Exposed_h */
