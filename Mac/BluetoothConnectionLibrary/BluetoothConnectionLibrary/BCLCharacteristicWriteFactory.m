//
//  BCLCharacteristicWriteFactory.m
//  BluetoothConnectionLibrary
//
//  Created by Hunter Lang on 12/2/15.
//  Copyright © 2015 Zenel. All rights reserved.
//

#import "BCLCharacteristicWriteFactory.h"

NS_ASSUME_NONNULL_BEGIN

static const NSUInteger MAX_CHUNK_SIZE = 20;
static const NSUInteger MAX_WRITE_WITHOUT_RESPONSE = 512;

@implementation BCLCharacteristicWriteFactory

+ (NSArray<BCLCharacteristicWrite *> *)generateWritesForCharacteristic:(CBCharacteristic *)characteristic usingData:(NSData *)data {
    NSMutableArray<BCLCharacteristicWrite *> *writes = [NSMutableArray new];
    NSUInteger bytesSinceLastWriteWithResponse = 0;
    NSUInteger offset = 0;
    while (offset < data.length) {
        NSUInteger length = MAX_CHUNK_SIZE;
        BOOL isLast = NO;
        if (offset + length >= data.length) {
            isLast = YES;
            length = data.length - offset;
        }
        BOOL forceWriteWithResponse = (bytesSinceLastWriteWithResponse + length >= MAX_WRITE_WITHOUT_RESPONSE);
        BOOL shouldRequestResponse = isLast || forceWriteWithResponse;
        if (shouldRequestResponse) {
            bytesSinceLastWriteWithResponse = 0;
        }
        else {
            bytesSinceLastWriteWithResponse += length;
        }
        NSData *chunk = [data subdataWithRange:NSMakeRange(offset, length)];
        BCLCharacteristicWrite *write = [[BCLCharacteristicWrite alloc] initWithCharacteristic:characteristic data:chunk requestResponse:shouldRequestResponse isLast:isLast];
        [writes addObject:write];
        offset += length;
    }
    return writes;
}

@end

NS_ASSUME_NONNULL_END
