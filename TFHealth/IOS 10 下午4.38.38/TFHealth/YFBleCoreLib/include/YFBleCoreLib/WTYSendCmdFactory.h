//
//  WTYSendCmdFactory.h
//  TestBleCore
//
//  Created by y61235 on 14-8-12.
//  Copyright (c) 2014年 yftech. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface WTYSendCmdFactory : NSObject
+ (id)createUpdateTimeCmd;
+ (id)createGetBattery;
+ (id)createGetSoftVersion;
+ (id)createGetHardVersion;
+ (id)createGetDeviceModel;
+ (id)createSetOtaMode;
+ (id)createRestartDevice;
+ (id)createGetHealthInfo;
+ (id)createStartSleepCmd;
+ (id)createStopSleepCmd;
+ (id)createGetDeviceStatus;
+ (id)createGetSleepInfo;

+ (void)setCmdStatus;
+ (void)resumeNormal;
@end
