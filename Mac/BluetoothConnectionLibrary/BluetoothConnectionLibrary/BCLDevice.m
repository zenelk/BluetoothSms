//
//  BCLDevice.m
//  BluetoothConnectionLibrary
//
//  Created by Hunter Lang on 12/1/15.
//  Copyright © 2015 Zenel. All rights reserved.
//

#import "BCLDevice.h"
#import "BluetoothUUIDs.h"
#import "BCLCharacteristicWriter.h"
#import "BCLCharacteristicWriteFactory.h"

NS_ASSUME_NONNULL_BEGIN

NSString * const BCLDeviceDidInitializeNotification = @"BCLDevice:Notification:DidInitialize";

@interface BCLDevice () <CBPeripheralDelegate>

@property (strong, nonatomic) CBUUID *serviceUUID;
@property (strong, nonatomic) CBCharacteristic *writeCharacteristic;
@property (strong, nonatomic) CBUUID *writeCharacteristicUUID;
@property (strong, nonatomic) NSMutableArray<id<BCLCommand>> *commandQueue;
@property (nonatomic) BOOL commandQueueStarted;
@property (strong, nonatomic) BCLCharacteristicWriter *writer;
@property (strong, nonatomic) BCLCharacteristicWrite *currentWrite;

@end

@implementation BCLDevice

- (instancetype)initWithPeripheral:(CBPeripheral *)peripheral {
    if (self = [super init]) {
        _peripheral = peripheral;
        _peripheral.delegate = self;
        _serviceUUID = [CBUUID UUIDWithString:UUID_SERVICE_BLUETOOTH_SMS];
        _writeCharacteristicUUID = [CBUUID UUIDWithString:UUID_CHARACTERISTIC_BLUETOOTH_SMS_WRITE];
        _commandQueue = [NSMutableArray new];
        _writer = [[BCLCharacteristicWriter alloc] initWithExecuteBlock:^(BCLCharacteristicWrite *toWrite) {
            _currentWrite = toWrite;
            [_peripheral writeValue:toWrite.data
                  forCharacteristic:toWrite.characteristic
                               type:(toWrite.requestResponse
                                     ? CBCharacteristicWriteWithResponse
                                     : CBCharacteristicWriteWithoutResponse)];
        }];
    }
    return self;
}

- (void)initialize {
    self.state = BCLDeviceStateInitializing;
    [_peripheral discoverServices:@[ _serviceUUID ]];
}

- (void)writeCommand:(id<BCLCommand>)command {
    if (self.state != BCLDeviceStateInitialized) {
        @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:@"state must be BCLDeviceStateInitialized before sending commands" userInfo:nil];
    }
    @synchronized(_commandQueue) {
        [_commandQueue addObject:command];
        
        if (!_commandQueueStarted) {
            [self sendNextCommand];
        }
    }
}

- (void)sendNextCommand {
    id<BCLCommand> nextCommand;
    @synchronized(_commandQueue) {
        if ([_commandQueue count] < 1) {
            _commandQueueStarted = NO;
            return;
        }
        _commandQueueStarted = YES;
        nextCommand = [_commandQueue firstObject];
        [_commandQueue removeObjectAtIndex:0];
    }
    if (nextCommand) {
        [self enqueueCommandForWriting:nextCommand];
    }
}

- (void)enqueueCommandForWriting:(id<BCLCommand>)command {
    NSArray<BCLCharacteristicWrite *> *writesForCommand = [BCLCharacteristicWriteFactory generateWritesForCharacteristic:_writeCharacteristic usingData:command.commandData];
    for (BCLCharacteristicWrite *write in writesForCommand) {
        [_writer enqueueCharacteristicWrite:write];
    }
}


- (NSString *)name {
    return _peripheral.name;
}

#pragma mark - CBPeripheralDelegate Implementation

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(nullable NSError *)error {
    [_peripheral discoverCharacteristics:@[ _writeCharacteristicUUID ] forService:peripheral.services[0]];
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(nullable NSError *)error {
    for (CBCharacteristic *characteristic in service.characteristics) {
        if ([characteristic.UUID isEqual:_writeCharacteristicUUID]) {
            _writeCharacteristic = characteristic;
            self.state = BCLDeviceStateInitialized;
            [[NSNotificationCenter defaultCenter] postNotificationName:BCLDeviceDidInitializeNotification object:self];
        }
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(nullable NSError *)error {
    _currentWrite = nil;
}

@end

NS_ASSUME_NONNULL_END