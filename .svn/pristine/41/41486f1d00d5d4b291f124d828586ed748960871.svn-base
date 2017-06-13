//
//  WTYBleService.h
//  TestBleCore
//
//  Created by y61235 on 14-8-11.
//  Copyright (c) 2014年 yftech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

@class WTYBleService;

@protocol BleServiceProtocol<NSObject>

- (void) didFinishService:(WTYBleService *)bleService;
@end

@interface WTYBleService : NSObject
+ (id) sharedInstance;
-(void)initService:(CBPeripheral *)peripheral protocol:(id<BleServiceProtocol>)protocol;

- (void) write:(NSData *)data;

- (void) readCharacteristic:(NSString *)uuid;
@end
