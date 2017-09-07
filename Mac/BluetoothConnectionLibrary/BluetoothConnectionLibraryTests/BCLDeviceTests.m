//
//  BCLDeviceTests.m
//  BluetoothConnectionLibrary
//
//  Created by Hunter Lang on 12/1/15.
//  Copyright © 2015 Zenel. All rights reserved.
//

#import <XCTest/XCTest.h>
@import CoreBluetooth; 
#import "BCLDevice+Exposed.h"
#import "CBPeripheral+Mock.h"
#import "BluetoothUUIDs.h"
#import "BCLCharacteristicWriteFactory.h"

NS_ASSUME_NONNULL_BEGIN

@interface BCLDeviceTests : XCTestCase

@property (strong, nonatomic) CBPeripheral *mockPeripheral;
@property (strong, nonatomic) BCLDevice *device;
@property (nonatomic) BOOL handleDeviceDidInitializeNotificationInvoked;

@end

@implementation BCLDeviceTests

- (void)setUp {
    [super setUp];
    _mockPeripheral = [[CBPeripheral alloc] init];
    [_mockPeripheral setValue:[[NSUUID alloc] init] forKeyPath:@"identifier"];
    _device = [[BCLDevice alloc] initWithPeripheral:_mockPeripheral];
}

- (void)tearDown {
    _device = nil;
    [super tearDown];
}

- (void)initializeDevice {
    [_device initialize];
    [_mockPeripheral discoverService:[CBUUID UUIDWithString:UUID_SERVICE_BLUETOOTH_SMS]];
    [_mockPeripheral discoverCharacteristic:[CBUUID UUIDWithString:UUID_CHARACTERISTIC_BLUETOOTH_SMS_WRITE] forService:[CBUUID UUIDWithString:UUID_SERVICE_BLUETOOTH_SMS]];
}

- (void)testPeripheralDelegateIsSetToDeviceWhenCreated {
    XCTAssert(_device == _mockPeripheral.delegate);
}

- (void)testDeviceStateIsSetToInitializingWhenInitializeIsCalled {
    [_device initialize];
    XCTAssert(_device.state == BCLDeviceStateInitializing);
}

- (void)testDeviceNotifiesWhenInitialized {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleDeviceDidInitializeNotification:) name:BCLDeviceDidInitializeNotification object:nil];
    [self initializeDevice];
    XCTAssert(_handleDeviceDidInitializeNotificationInvoked);
    [[NSNotificationCenter defaultCenter] removeObserver:self name:BCLDeviceDidInitializeNotification object:nil];
}

- (void)testInitializingDevicePopulatesWriteCharacteristic {
    [self initializeDevice];
    XCTAssert(_device.writeCharacteristic);
}

- (void)testCompletingInitializationSetsStateToInitialized {
    [self initializeDevice];
    XCTAssert(_device.state == BCLDeviceStateInitialized);
}

- (void)testWriteCommandToAnEmptyCommandQueueStartsWriting {
    [self initializeDevice];
    [_device writeCommand:[BCLPingCommand new]];
    XCTAssert(_device.commandQueueStarted);
}

- (void)testWriteCommandWhileQueueIsBusyEnqueuesCommand {
    [self initializeDevice];
    [_device writeCommand:[BCLPingCommand new]];
    [_device writeCommand:[BCLPingCommand new]];
    XCTAssert([_device.commandQueue count] == 1);
}

- (void)testCommandIsImmediatelyDequeuedWhenQueueIsNotBusy {
    [self initializeDevice];
    [_device writeCommand:[BCLPingCommand new]];
    XCTAssert([_device.commandQueue count] == 0);
}

- (void)testWritingCommandWhenQueueIsNotBusyImmediatelyStartsWriting {
    [self initializeDevice];
    id<BCLCommand> command = [BCLPingCommand new];
    [_device writeCommand:command];
    NSArray<BCLCharacteristicWrite *> *writesForCommand = [BCLCharacteristicWriteFactory generateWritesForCharacteristic:_device.writeCharacteristic usingData:command.commandData];
    XCTAssert([writesForCommand[0] isEqual:_device.currentWrite]);
}

- (void)testDeviceClearsCurrentWriteWhenWriteIsComplete {
    [self initializeDevice];
    id<BCLCommand> command = [BCLPingCommand new];
    [_device writeCommand:command];
    [_mockPeripheral didWriteValueForCharacteristic:_device.writeCharacteristic];
    XCTAssert(!_device.currentWrite);
}

- (void)testSendingCommandsToAnUnitializedDeviceThrowsAnException {
    id<BCLCommand> command = [BCLPingCommand new];
    XCTAssertThrows([_device writeCommand:command], @"Sending a command to a non-initialized device should throw");
}

- (void)handleDeviceDidInitializeNotification:(NSNotification *)notification {
    _handleDeviceDidInitializeNotificationInvoked = YES;
}

@end

NS_ASSUME_NONNULL_END