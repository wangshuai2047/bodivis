//
//  WTYGetTime.h
//  TestBleCore
//
//  Created by y61235 on 14-8-13.
//  Copyright (c) 2014年 yftech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YFBleGetDeviceInfoCmd.h"
@interface WTYGetTime : YFBleGetDeviceInfoCmd
@property (nonatomic, strong) NSString *time;
@end
