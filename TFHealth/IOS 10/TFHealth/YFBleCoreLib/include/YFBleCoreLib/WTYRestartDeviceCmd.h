//
//  WTYRestartDeviceCmd.h
//  TestBleCore
//
//  Created by y61235 on 14-8-13.
//  Copyright (c) 2014年 yftech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WTYBleService.h"
#import "WTYCmdStatus.h"

@protocol WTYCmdStatus;
@interface WTYRestartDeviceCmd : NSObject
- (void)start:(WTYBleService *)bleService protocol:(id<WTYCmdStatus>)protocol;
@end
