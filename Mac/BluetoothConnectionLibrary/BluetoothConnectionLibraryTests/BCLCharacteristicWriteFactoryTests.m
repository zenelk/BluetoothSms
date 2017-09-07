//
//  BCLCharacteristicWriteFactoryTests.m
//  BluetoothConnectionLibrary
//
//  Created by Hunter Lang on 12/2/15.
//  Copyright © 2015 Zenel. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "BCLCharacteristicWriteFactory.h"

NS_ASSUME_NONNULL_BEGIN

@interface BCLCharacteristicWriteFactoryTests : XCTestCase

@property (strong, nonatomic) CBCharacteristic *mockCharacteristic;

@end

@implementation BCLCharacteristicWriteFactoryTests

- (void)setUp {
    [super setUp];
    _mockCharacteristic = [CBCharacteristic new];
    [_mockCharacteristic setValue:[CBUUID UUIDWithNSUUID:[[NSUUID alloc] init]] forKey:@"UUID"];
}

- (void)tearDown {
    _mockCharacteristic = nil;
    [super tearDown];
}


+ (NSData *)generateRandomBytes:(NSUInteger)length {
    NSMutableData *data = [NSMutableData dataWithCapacity:length];
    for (NSUInteger i = 0; i < length; ++i) {
        uint8_t randomByte = arc4random() % 256;
        [data appendBytes:&randomByte length:1];
    }
    return [data copy];
}

- (void)testFactoryReturnsOneCharacteristicWriteForAShortCommand {
    NSArray<BCLCharacteristicWrite *> *writes = [BCLCharacteristicWriteFactory generateWritesForCharacteristic:_mockCharacteristic usingData:[BCLCharacteristicWriteFactoryTests generateRandomBytes:1]];
    XCTAssert(writes.count == 1);
}

- (void)testFactoryReturnsWritesScopedToCharacteristic {
    NSArray<BCLCharacteristicWrite *> *writes = [BCLCharacteristicWriteFactory generateWritesForCharacteristic:_mockCharacteristic usingData:[BCLCharacteristicWriteFactoryTests generateRandomBytes:1]];
    XCTAssert([writes[0].characteristic.UUID isEqual:_mockCharacteristic.UUID]);
}

- (void)testFactoryMakesTwoCharacteristicWritesWhenLargerThanTwentyBytes {
    NSData *data = [BCLCharacteristicWriteFactoryTests generateRandomBytes:21];
    NSArray<BCLCharacteristicWrite *> *writes = [BCLCharacteristicWriteFactory generateWritesForCharacteristic:_mockCharacteristic usingData:data];
    XCTAssert(writes.count == 2);
}

- (void)testFactoryChunksDataForTwoCharacteristicWritesWhenDataIsLargerThanTwentyBytes {
    NSData *data = [BCLCharacteristicWriteFactoryTests generateRandomBytes:21];
    NSArray<BCLCharacteristicWrite *> *writes = [BCLCharacteristicWriteFactory generateWritesForCharacteristic:_mockCharacteristic usingData:data];
    NSData *firstChunk = [data subdataWithRange:NSMakeRange(0, 20)];
    NSData *secondChunk = [data subdataWithRange:NSMakeRange(20, 1)];
    XCTAssert([firstChunk isEqual:writes[0].data]);
    XCTAssert([secondChunk isEqual:writes[1].data]);
}

- (void)testFactoryChunksDataForMultipleCharacteristicWritesWhenDataIsLarge {
    NSData *data = [BCLCharacteristicWriteFactoryTests generateRandomBytes:1000];
    NSArray<BCLCharacteristicWrite *> *writes = [BCLCharacteristicWriteFactory generateWritesForCharacteristic:_mockCharacteristic usingData:data];
    for (NSUInteger i = 0; i < writes.count; ++i) {
        BCLCharacteristicWrite *write = writes[i];
        NSData *comparisonData = [data subdataWithRange:NSMakeRange(i * 20, 20)];
        XCTAssert([write.data isEqual:comparisonData]);
    }
}

- (void)testFactoryGeneratesWritesWithAllTheSameCharacteristic {
    NSData *data = [BCLCharacteristicWriteFactoryTests generateRandomBytes:1000];
    NSArray<BCLCharacteristicWrite *> *writes = [BCLCharacteristicWriteFactory generateWritesForCharacteristic:_mockCharacteristic usingData:data];
    for (NSUInteger i = 0; i < writes.count; ++i) {
        XCTAssert([writes[i].characteristic.UUID isEqual:_mockCharacteristic.UUID]);
    }
}

- (void)testOneWriteIsMarkedAsLast {
    NSData *data = [BCLCharacteristicWriteFactoryTests generateRandomBytes:10];
    NSArray<BCLCharacteristicWrite *> *writes = [BCLCharacteristicWriteFactory generateWritesForCharacteristic:_mockCharacteristic usingData:data];
    XCTAssert(writes[0].isLast);
}

- (void)testLargeDataLastWriteIsMarkedAsLast {
    NSData *data = [BCLCharacteristicWriteFactoryTests generateRandomBytes:101];
    NSArray<BCLCharacteristicWrite *> *writes = [BCLCharacteristicWriteFactory generateWritesForCharacteristic:_mockCharacteristic usingData:data];
    XCTAssert(writes[writes.count - 1].isLast);
}

- (void)testLargeDataLastWriteIsMarkedAsLastWhenEvenlySplitIntoTwentyBytes {
    NSData *data = [BCLCharacteristicWriteFactoryTests generateRandomBytes:100];
    NSArray<BCLCharacteristicWrite *> *writes = [BCLCharacteristicWriteFactory generateWritesForCharacteristic:_mockCharacteristic usingData:data];
    XCTAssert(writes[writes.count - 1].isLast);
}

- (void)testFactoryGeneratesEmptyArrayFromEmptyData {
    NSData *data = [BCLCharacteristicWriteFactoryTests generateRandomBytes:0];
    NSArray<BCLCharacteristicWrite *> *writes = [BCLCharacteristicWriteFactory generateWritesForCharacteristic:_mockCharacteristic usingData:data];
    XCTAssert(writes.count == 0);
}

- (void)testLastWriteIsWriteWithResponse {
    NSData *data = [BCLCharacteristicWriteFactoryTests generateRandomBytes:1000];
    NSArray<BCLCharacteristicWrite *> *writes = [BCLCharacteristicWriteFactory generateWritesForCharacteristic:_mockCharacteristic usingData:data];
    XCTAssert(writes[writes.count - 1].requestResponse);
}

- (void)testWriteWithResponseIsEnforcedBeforeEvery512Bytes {
    NSData *data = [BCLCharacteristicWriteFactoryTests generateRandomBytes:1200];
    NSArray<BCLCharacteristicWrite *> *writes = [BCLCharacteristicWriteFactory generateWritesForCharacteristic:_mockCharacteristic usingData:data];
    NSUInteger byteCount = 0;
    for (NSUInteger i = 0; i < writes.count; ++i) {
        BCLCharacteristicWrite *write = writes[i];
        if (byteCount + write.data.length >= 512) {
            XCTAssert(write.requestResponse);
            byteCount = 0;
        }
        else {
            byteCount += write.data.length;
        }
    }
}

@end

NS_ASSUME_NONNULL_END