//
//  BCLCharacteristicWriter+Exposed.h
//  BluetoothConnectionLibrary
//
//  Created by Hunter Lang on 12/2/15.
//  Copyright © 2015 Zenel. All rights reserved.
//

#ifndef BCLCharacteristicWriter_Exposed_h
#define BCLCharacteristicWriter_Exposed_h

#import <Foundation/Foundation.h>
#import "BCLCharacteristicWriter.h"

NS_ASSUME_NONNULL_BEGIN

@interface BCLCharacteristicWriter (Exposed)

@property (strong, nonatomic, readonly) NSMutableArray<BCLCharacteristicWrite *> *queuedWrites;
@property (nonatomic, readonly) BOOL queueStarted;

@end

NS_ASSUME_NONNULL_END

#endif /* BCLCharacteristicWriter_Exposed_h */
