//
//  BleDiscovery.h
//  YFSmartLoop
//
//  Created by y61235 on 14-3-21.
//  Copyright (c) 2014年 yftech. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

//static NSString *kBleName = @"kBleName";
//static NSString *kBleRssi = @"kBleRssi";
//static NSString *kBleId = @"kBleId";
//static NSString *kBleConState = @"kBleConState";
//static NSString *kBleAddTime = @"kBleAddTime";

@interface WTYFoundDeviceModel : NSObject
@property (nonatomic, strong) CBPeripheral *peripheral;

@property (nonatomic, strong) NSNumber *rssi;

@property (nonatomic, strong) NSNumber *addTime;
@end

/****************************************************************************/
/*							UI protocols									*/
/****************************************************************************/
@protocol BleDiscoveryDelegate <NSObject>

- (void) discoveryDidRefresh;
- (void) discoveryStatePoweredOff;
- (void) discoveryStatePoweredOn;

- (void)discoveryBLEChangeStauts:(CBCentralManagerState)status;

@required
- (void) didConnectPeripheral:(CBPeripheral *)peripheral;
- (void) didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error;
- (void) didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error;
@end


typedef void (^connectStatus)(NSInteger status, CBPeripheral* peripheral);

@interface WTYBleDiscovery : NSObject

+ (id) sharedInstance;

/****************************************************************************/
/*								UI controls									*/
/****************************************************************************/
@property (nonatomic, weak) id<BleDiscoveryDelegate>           discoveryDelegate;

/****************************************************************************/
/*								Actions										*/
/****************************************************************************/
- (void) startScanningForUUIDStringAry:(NSArray *)uuidStringAry;
- (void) startScanningForUUIDString:(NSString *)uuidString;
- (void) startScanning;
- (void) stopScanning;

- (void) connectPeripheral:(CBPeripheral*)peripheral;
- (void) disconnectPeripheral:(CBPeripheral*)peripheral;
- (void) retrieveConnectedPeripherals;
- (void) reConnectPeripheral:(CBPeripheral *)peripheral;
- (void) reConnect;
- (void) disCurConnectPeripheral;


// clyde add
- (NSArray *)phoneConnectedDevices;
- (CBPeripheral *)periperalWithUUID:(NSString *)uuid;
// 

- (void) reConnect:(NSString *)bleName;
- (void) setConnectedPeripheralName:(NSString *)peripheralName;
- (NSString *) getConnectedPeripheralName;

- (NSString *) getConnectedPeripheralIdentifier;

- (void) reConnect:(NSString *)bleName connectStatus:(connectStatus)status;


/****************************************************************************/
/*							Access to the devices							*/
/****************************************************************************/
@property (retain, nonatomic) NSMutableArray *foundPeripheralsUnit;  //Array of foundPeripherals
@property (retain, nonatomic) NSMutableArray *connectedPeripherals;	// Array of conPeripherals only one

@end
