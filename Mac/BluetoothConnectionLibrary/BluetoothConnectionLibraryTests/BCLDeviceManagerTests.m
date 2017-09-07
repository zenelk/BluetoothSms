//
//  BCLDeviceManagerTests.m
//  BluetoothConnectionLibrary
//
//  Created by Hunter Lang on 12/1/15.
//  Copyright © 2015 Zenel. All rights reserved.
//

#import <XCTest/XCTest.h>
@import BluetoothConnectionLibrary;
#import "BCLDeviceManager+Exposed.h"
#import "CBCentralManager+Mock.h"
#import "BCLDevice+Exposed.h"

NS_ASSUME_NONNULL_BEGIN

@interface BCLDeviceManagerTests : XCTestCase <BCLDeviceManagerDelegate>

@property (strong, nonatomic) CBPeripheral *mockPeripheral;
@property (strong, nonatomic) BCLDeviceManager *deviceManager;
@property (nonatomic) BOOL didStartScanningInvoked;
@property (nonatomic) BOOL didStopScanningInvoked;
@property (strong, nonatomic) BCLDevice *discoveredDevice;
@property (nonatomic) BOOL didConnectDeviceInvoked;

@end

@implementation BCLDeviceManagerTests

- (void)setUp {
    [super setUp];
    _mockPeripheral = [[CBPeripheral alloc] init];
    [_mockPeripheral setValue:[[NSUUID alloc] init] forKeyPath:@"identifier"];
    _deviceManager = [[BCLDeviceManager alloc] initWithDelegate:self];
    _didStartScanningInvoked = NO;
    _didStopScanningInvoked = NO;
}

- (void)tearDown {
    _discoveredDevice = nil;
    _deviceManager = nil;
    [super tearDown];
}

- (void)testStartScanningWhenReadyFiresDidStartScanning {
    [_deviceManager.centralManager powerOn];
    [_deviceManager startScanning];
    XCTAssert(_didStartScanningInvoked);
}

- (void)testStartScanningWhileScanningDoesNotFireDidStartScanning {
    [_deviceManager.centralManager powerOn];
    [_deviceManager startScanning];
    _didStartScanningInvoked = NO;
    [_deviceManager startScanning];
    XCTAssert(!_didStartScanningInvoked);
}

- (void)testStopScanningWhileScanningFiresDidStopScanning {
    [_deviceManager.centralManager powerOn];
    [_deviceManager startScanning];
    [_deviceManager stopScanning];
    XCTAssert(_didStopScanningInvoked);
}

- (void)testStopScanningWhileNotScanningDoesNotFireStopScanning {
    [_deviceManager stopScanning];
    XCTAssert(!_didStopScanningInvoked);
}

- (void)testStartScanningWhenNotReadyDoesNotFireDidStartScanning {
    [_deviceManager startScanning];
    XCTAssert(!_didStartScanningInvoked);
}

- (void)testStartScanningInvokedWhenRequestedAndCentralManagerPowersOn {
    [_deviceManager startScanning];
    [_deviceManager.centralManager powerOn];
    XCTAssert(_didStartScanningInvoked);
}

- (void)testScannerFiresDidDiscoverDeviceWhenDeviceIsDiscovered {
    [_deviceManager.centralManager discoverPeripheral:_mockPeripheral];
    XCTAssert(_discoveredDevice);
}

- (void)testDidDiscoverDeviceContainsDeviceWithMockPeripheral {
    [_deviceManager.centralManager discoverPeripheral:_mockPeripheral];
    XCTAssert([_discoveredDevice.peripheral.identifier isEqual:_mockPeripheral.identifier]);
}

- (void)testDidDiscoverDeviceIsNotInvokedTwiceWhenDiscoveringTheSameDeviceTwice {
    [_deviceManager.centralManager discoverPeripheral:_mockPeripheral];
    _discoveredDevice = nil;
    [_deviceManager.centralManager discoverPeripheral:_mockPeripheral];
    XCTAssert(!_discoveredDevice);
}

- (void)testConnectingAPeripheralInvokesDidConnectPeripheralDelegateMethod {
    [_deviceManager.centralManager discoverPeripheral:_mockPeripheral];
    [_deviceManager.centralManager connectPeripheral:_mockPeripheral];
    XCTAssert(_didConnectDeviceInvoked);
}

- (void)testConnectingDeviceSetsDeviceStateToConnecting {
    [_deviceManager.centralManager discoverPeripheral:_mockPeripheral];
    [_deviceManager connectDevice:_discoveredDevice];
    XCTAssert(_discoveredDevice.state == BCLDeviceStateConnecting);
}

- (void)testWhenPeripheralConnectsDeviceStateIsSetToConnected {
    [_deviceManager.centralManager discoverPeripheral:_mockPeripheral];
    [_deviceManager connectDevice:_discoveredDevice];
    [_deviceManager.centralManager connectPeripheral:_mockPeripheral];
    XCTAssert(_discoveredDevice.state == BCLDeviceStateConnected);
}

- (void)testDisconnectingConnectedDeviceSetsDeviceStateToDisconnecting {
    [_deviceManager.centralManager discoverPeripheral:_mockPeripheral];
    [_deviceManager connectDevice:_discoveredDevice];
    [_deviceManager.centralManager connectPeripheral:_mockPeripheral];
    [_deviceManager disconnectDevice:_discoveredDevice];
    XCTAssert(_discoveredDevice.state == BCLDeviceStateDisconnecting);
}

- (void)testWhenPeripheralDisconnectsDeviceStateIsSetToDisconnected {
    [self connectDevice];
    [self disconnectDevice];
    XCTAssert(_discoveredDevice.state == BCLDeviceStateDisconnected);
}

- (void)connectDevice {
    [_deviceManager.centralManager discoverPeripheral:_mockPeripheral];
    [_deviceManager connectDevice:_discoveredDevice];
    [_deviceManager.centralManager connectPeripheral:_mockPeripheral];
}

- (void)disconnectDevice {
    [_deviceManager disconnectDevice:_discoveredDevice];
    [_deviceManager.centralManager disconnectPeripheral:_mockPeripheral];
}

#pragma mark BCLDeviceManagerDelegate Implementation

- (void)managerDidStartScanning:(BCLDeviceManager *)manager {
    _didStartScanningInvoked = YES;
}

- (void)managerDidStopScanning:(BCLDeviceManager *)manager {
    _didStopScanningInvoked = YES;
}

- (void)manager:(BCLDeviceManager *)manager didDiscoverDevice:(BCLDevice *)device {
    _discoveredDevice = device;
}

- (void)manager:(BCLDeviceManager *)manager didConnectDevice:(BCLDevice *)device {
    _didConnectDeviceInvoked = YES;
}

@end

NS_ASSUME_NONNULL_END