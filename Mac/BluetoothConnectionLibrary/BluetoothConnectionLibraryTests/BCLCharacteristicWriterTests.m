//
//  BCLCharacteristicWriterTests.m
//  BluetoothConnectionLibrary
//
//  Created by Hunter Lang on 12/2/15.
//  Copyright © 2015 Zenel. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "BCLCharacteristicWriter+Exposed.h"
#import "BCLCharacteristicWrite.h"

NS_ASSUME_NONNULL_BEGIN

@interface BCLCharacteristicWriterTests : XCTestCase

@property (strong, nonatomic) CBCharacteristic *mockCharacteristic;
@property (strong, nonatomic) BCLCharacteristicWriter *writer;
@property (strong, nonatomic) NSData *mockData;
@property (strong, nonatomic) BCLCharacteristicWrite *write;

@end

@implementation BCLCharacteristicWriterTests

- (void)setUp {
    [super setUp];
    _writer = [[BCLCharacteristicWriter alloc] initWithExecuteBlock:^(BCLCharacteristicWrite *toWrite) { /* No op */ }];
    _mockCharacteristic = [[CBCharacteristic alloc] init];
    _write = [BCLCharacteristicWrite characteristicWriteWithCharacteristic:_mockCharacteristic data:_mockData requestResponse:YES isLast:YES];
}

- (void)tearDown {
    _writer = nil;
    [super tearDown];
}

- (void)testWriterEnqueuesWrites {
    [_writer enqueueCharacteristicWrite:_write];
    [_writer enqueueCharacteristicWrite:_write];
    XCTAssert([_writer.queuedWrites count] == 1);
}

- (void)testWriterStopsWhenQueueIsEmpty {
    [_writer enqueueCharacteristicWrite:_write];
    [_writer writeNext];
    XCTAssert(!_writer.queueStarted);
}

- (void)testWriterStartsWritingWhenQueueIsNoLongerEmpty {
    [_writer enqueueCharacteristicWrite:_write];
    XCTAssert(_writer.queueStarted);
}

- (void)testWriterWritesWriteImmediatelyWhenQueueIsEmpty {
    [_writer enqueueCharacteristicWrite:_write];
    XCTAssert([_writer.queuedWrites count] == 0);
}

- (void)testWriterMovesToNextWriteWhenWriteNextIsInvoked {
    [_writer enqueueCharacteristicWrite:_write];
    [_writer enqueueCharacteristicWrite:_write];
    [_writer writeNext];
    XCTAssert([_writer.queuedWrites count] == 0);
}

@end

NS_ASSUME_NONNULL_END