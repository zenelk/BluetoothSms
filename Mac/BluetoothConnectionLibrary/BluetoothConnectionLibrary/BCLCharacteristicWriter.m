//
//  BCLCharacteristicWriter.m
//  BluetoothConnectionLibrary
//
//  Created by Hunter Lang on 12/2/15.
//  Copyright © 2015 Zenel. All rights reserved.
//

#import "BCLCharacteristicWriter.h"

NS_ASSUME_NONNULL_BEGIN

@interface BCLCharacteristicWriter ()

@property (copy, nonatomic) BCLCharacteristicWriterExecuteWriteBlock executeBlock;
@property (strong, nonatomic) NSMutableArray<BCLCharacteristicWrite *> *queuedWrites;
@property (nonatomic) BOOL queueStarted;
@property (strong, nonatomic) BCLCharacteristicWrite *currentWrite;
@property (nonatomic) NSUInteger bytesSinceLastWriteWithResponse;

@end

@implementation BCLCharacteristicWriter

- (instancetype)initWithExecuteBlock:(BCLCharacteristicWriterExecuteWriteBlock)executeBlock {
    if (self = [super init]) {
        _queuedWrites = [NSMutableArray new];
        self.executeBlock = executeBlock;
    }
    return self;
}

- (void)enqueueCharacteristicWrite:(BCLCharacteristicWrite *)write {
    @synchronized(_queuedWrites) {
        [_queuedWrites addObject:write];
        if (!_queueStarted) {
            _queueStarted = YES;
            [self writeNext];
        }
    }
}

- (void)writeNext {
    @synchronized(_queuedWrites) {
        if ([_queuedWrites count] < 1) {
            _queueStarted = NO;
            return;
        }
        _currentWrite = [_queuedWrites firstObject];
        [_queuedWrites removeObjectAtIndex:0];
        self.executeBlock(_currentWrite);
    }
}

@end

NS_ASSUME_NONNULL_END