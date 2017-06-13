//
//  WTYGetDeviceStatus.h
//  TestBleCore
//
//  Created by y61235 on 14-8-20.
//  Copyright (c) 2014年 yftech. All rights reserved.
//

#import "YFBleGetOneByteCmd.h"
typedef enum ListStatus{
    NormalStatus,
    SleepStatus,
    StatusUnkown,       // 未知，发生错误了
}ListStatus;

@interface WTYGetDeviceStatus : YFBleGetOneByteCmd
@property (nonatomic, assign) ListStatus status;
@end
