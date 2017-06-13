//
//  YFBleSendOneDataCmd.h
//  TestBleCore
//
//  Created by y61235 on 14-8-18.
//  Copyright (c) 2014年 yftech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YFBleSendCmd.h"
@interface YFBleSendOneDataCmd : YFBleSendCmd
@property (nonatomic, assign) Byte cmd;
@property (nonatomic, strong) NSData *sendData;
@end
