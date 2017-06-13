//
//  WTYGetHardVersion.h
//  TestBleCore
//
//  Created by y61235 on 14-8-12.
//  Copyright (c) 2014年 yftech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YFBleGetDeviceInfoCmd.h"

@interface WTYGetHardVersion : YFBleGetDeviceInfoCmd
@property (nonatomic, strong) NSString *hardVersion;
@end

