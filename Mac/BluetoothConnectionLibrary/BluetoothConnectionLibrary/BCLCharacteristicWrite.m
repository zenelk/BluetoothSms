//
//  BCLCharacteristicWrite.m
//  BluetoothConnectionLibrary
//
//  Created by Hunter Lang on 12/2/15.
//  Copyright © 2015 Zenel. All rights reserved.
//

#import "BCLCharacteristicWrite.h"

NS_ASSUME_NONNULL_BEGIN

@implementation BCLCharacteristicWrite

+ (instancetype)characteristicWriteWithCharacteristic:(CBCharacteristic *)characteristic data:(NSData *)data requestResponse:(BOOL)requestResponse isLast:(BOOL)isLast {
    return [[BCLCharacteristicWrite alloc] initWithCharacteristic:characteristic data:data requestResponse:requestResponse isLast:isLast];
}

- (instancetype)initWithCharacteristic:(CBCharacteristic *)charateristic data:(NSData *)data requestResponse:(BOOL)requestResponse isLast:(BOOL)isLast {
    if (self = [super init]) {
        _characteristic = charateristic;
        _data = data;
        _requestResponse = requestResponse;
        _isLast = isLast;
    }
    return self;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"<BCLCharacteristicWrite: characteristic:%@, data:%@, requestResponse:%d, isLast:%d", _characteristic.UUID.UUIDString, _data, _requestResponse, _isLast];
}

- (BOOL)isEqual:(id)object {
    if (![object isKindOfClass:[BCLCharacteristicWrite class]]) {
        return NO;
    }
    return [_characteristic isEqual:[object characteristic]]
        && [_data isEqual:[object data]]
        && _requestResponse == [object requestResponse]
        && _isLast == [object isLast];
}

@end

NS_ASSUME_NONNULL_END