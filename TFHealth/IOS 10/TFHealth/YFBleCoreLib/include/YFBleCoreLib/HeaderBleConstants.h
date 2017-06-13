//
//  HeaderBleConstants.h
//  TestBleCore
//
//  Created by y61235 on 14-8-15.
//  Copyright (c) 2014年 yftech. All rights reserved.
//

#ifndef TestBleCore_HeaderBleConstants_h
#define TestBleCore_HeaderBleConstants_h

typedef enum ListCmd{
    GetTime,
    UpdateTime,
    SendHostName,
    GetBattery,
    GetSoftVersion,
    GetHardVersion,
    GetDeviceModel,
    SetOtaMode,
    RestartDevice = 9,
    GetHealthData = 12,
    StartSleep = 18,
    StopSleep = 19,
    GetDeviceStatus = 20,
    GetSleepInfo = 22,
}ListCmd;


#endif
