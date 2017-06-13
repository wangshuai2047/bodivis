//
//  WTYGetHealthData.h
//  TestBleCore
//
//  Created by y61235 on 14-8-18.
//  Copyright (c) 2014年 yftech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YFBleSendCmd.h"

@interface WTYHealthDataModel : NSObject
@property (nonatomic, assign) unsigned int steps;

@property (nonatomic, assign) unsigned int distance; /// 单位cm

@property (nonatomic, assign) unsigned int calories; /// 单位0.1小卡

@property (nonatomic, assign) unsigned short time;  /// 运动时间 单位分钟
@end

@interface WTYGetHealthData : YFBleSendCmd

- (void)start:(WTYBleService *)bleService
     protocol:(id<WTYCmdStatus>)protocol
        dataNum:(int)value
        startIndex:(int)nIndex;

@property (nonatomic, strong) NSArray *healthDataArray;
@end
