//
//  BCLDeviceManager.m
//  BluetoothConnectionLibrary
//
//  Created by Hunter Lang on 12/1/15.
//  Copyright © 2015 Zenel. All rights reserved.
//

#import "BCLDeviceManager.h"
#import "BluetoothUUIDs.h"
#import "NSObject+PerformOptionalSelector.h"

NS_ASSUME_NONNULL_BEGIN

@interface BCLDeviceManager () <CBCentralManagerDelegate>

@property (strong, nonatomic) CBUUID *serviceUUID;
@property (weak, nonatomic) id<BCLDeviceManagerDelegate> delegate;
@property (nonatomic) BOOL scanning;
@property (strong, nonatomic) CBCentralManager *centralManager;
@property (nonatomic) BOOL scanRequested;
@property (strong, nonatomic) NSMutableDictionary<NSUUID *, BCLDevice *> *devicesForIdentifiers;

@end

@implementation BCLDeviceManager

- ( instancetype)initWithDelegate:(nullable id<BCLDeviceManagerDelegate>)delegate {
    if (self = [super init]) {
        _delegate = delegate;
        _scanning = NO;
        _centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
        _devicesForIdentifiers = [NSMutableDictionary new];
        _serviceUUID = [CBUUID UUIDWithString:UUID_SERVICE_BLUETOOTH_SMS];
    }
    return self;
}

- (void)startScanning {
    if (_scanning) {
        return;
    }
    if (_centralManager.state != CBCentralManagerStatePoweredOn) {
        _scanRequested = YES;
        return;
    }
    _scanRequested = NO;
    self.scanning = YES;
    [_centralManager scanForPeripheralsWithServices:@[ _serviceUUID ] options:nil];
}

- (void)stopScanning {
    if (!_scanning) {
        return;
    }
    self.scanning = NO;
    [_centralManager stopScan];
}

- (void)connectDevice:(BCLDevice *)device {
    device.state = BCLDeviceStateConnecting;
    [_centralManager connectPeripheral:device.peripheral options:nil];
}

- (void)disconnectDevice:(BCLDevice *)device {
    device.state = BCLDeviceStateDisconnecting;
    [_centralManager cancelPeripheralConnection:device.peripheral];
}

- (void)setScanning:(BOOL)scanning {
    _scanning = scanning;
    if (scanning) {
        [NSObject performOptionalSelector:@selector(managerDidStartScanning:) onTarget:_delegate withArguments:@[ self ]];
    }
    else {
        [NSObject performOptionalSelector:@selector(managerDidStopScanning:) onTarget:_delegate withArguments:@[ self ]];
    }
}


#pragma mark - CBCentralManagerDelegate Implementation

- (void)centralManagerDidUpdateState:(CBCentralManager *)central {
    if (central.state == CBCentralManagerStatePoweredOn && _scanRequested) {
        [self startScanning];
    }
}

- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary<NSString *,id> *)advertisementData RSSI:(NSNumber *)RSSI {
    if (!_devicesForIdentifiers[peripheral.identifier]) {
        BCLDevice *device = [[BCLDevice alloc] initWithPeripheral:peripheral];
        _devicesForIdentifiers[peripheral.identifier] = device;
        [NSObject performOptionalSelector:@selector(manager:didDiscoverDevice:) onTarget:_delegate withArguments:@[ self, device ]];
    }
}

- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral {
    BCLDevice *device = _devicesForIdentifiers[peripheral.identifier];
    device.state = BCLDeviceStateConnected;
    [NSObject performOptionalSelector:@selector(manager:didConnectDevice:) onTarget:_delegate withArguments:@[ self, device ]];
}

- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(nullable NSError *)error {
    BCLDevice *device = _devicesForIdentifiers[peripheral.identifier];
    device.state = BCLDeviceStateDisconnected;
    [NSObject performOptionalSelector:@selector(manager:didDisconnectDevice:) onTarget:_delegate withArguments:@[ self, device ]];
}

@end

NS_ASSUME_NONNULL_END