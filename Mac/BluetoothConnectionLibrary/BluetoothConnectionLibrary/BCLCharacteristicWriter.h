//
//  BCLCharacteristicWriter.h
//  BluetoothConnectionLibrary
//
//  Created by Hunter Lang on 12/2/15.
//  Copyright © 2015 Zenel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BCLCharacteristicWrite.h"

NS_ASSUME_NONNULL_BEGIN

typedef void (^BCLCharacteristicWriterExecuteWriteBlock)(BCLCharacteristicWrite *toWrite);

@interface BCLCharacteristicWriter : NSObject

- (instancetype)initWithExecuteBlock:(BCLCharacteristicWriterExecuteWriteBlock)executeBlock;
- (void)enqueueCharacteristicWrite:(BCLCharacteristicWrite *)write;
- (void)writeNext;

@end

NS_ASSUME_NONNULL_END