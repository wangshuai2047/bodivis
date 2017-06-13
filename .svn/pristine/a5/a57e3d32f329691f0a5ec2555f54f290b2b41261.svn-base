//
//  WTYToast.h
//  YFBLESmartApp
//
//  Created by y61235 on 14-1-23.
//  Copyright (c) 2014年 yuanfeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HeaderBleUser.h"
#import "HeaderBleConstants.h"

@protocol  BleCoreManagerDelegate;

typedef enum
{
    CORE_STATUS_DISCONNECTED,
    CORE_STATUS_CONNECTED,
} CoreStatus;

@interface BleCoreManager : NSObject

@property (nonatomic,assign)  CoreStatus curStatus;
@property (nonatomic,retain)  WTYRestartDeviceCmd *scaleResult;
@property (nonatomic,retain)  WTYGetBattery *batteryResult;
@property (nonatomic,retain)  WTYHealthDataModel *healthDataResult;
@property (nonatomic,retain)  id<BleCoreManagerDelegate> delegate;

+(BleCoreManager *)sharedInstance;
-(void)scan;
-(void)disConnection;
-(void)getBattery;
-(void)restartDevice;
-(void)sendTime;
-(void)getHealthData;
-(void)startSleep;
-(void)stopSleep;
-(void)getSleepInfo;
-(void)getDeviceStatus;
- (void) connectPeripheral:(CBPeripheral*)peripheral;
- (void) disconnectPeripheral:(CBPeripheral*)peripheral;
-(void)scanList;
-(int)getPeripheralCount;
-(WTYFoundDeviceModel*) findDeviceModel:(int)row;
-(void)setOtaMode;
-(void)otaUpdate;
-(CoreStatus)getStatus;
@end


@protocol BleCoreManagerDelegate <NSObject>

@required
-(void)updateDeviceStatus:(CoreStatus)status;
-(void)updateUIData:(WTYRestartDeviceCmd*)object;
-(void)updateUIBattery:(WTYGetBattery*)object;
-(void)updateUIStepInfo:(WTYHealthDataModel*)object;
-(void)updateUIStartSleep;
-(void)updateUIStopSleep;
-(void)updateSleepTime:(WTYGetSleepInfoModel*)object;
-(void)updateCoreStatue:(WTYGetDeviceStatus*)object;
-(void)disError;
-(void)updateFail;
-(void)updateConnState;
-(void)updateYesOTA;
-(void)updateUITime;
@end