//
//  YFBleGetOneByteCmd.h
//  TestBleCore
//
//  Created by y61235 on 14-8-20.
//  Copyright (c) 2014年 yftech. All rights reserved.
//

#import "YFBleSendCmd.h"

@interface YFBleGetOneByteCmd : YFBleSendCmd
@property (nonatomic, assign) Byte cmd;
@property (nonatomic, assign) Byte cmdResp;
@property (nonatomic, assign, readonly) Byte passCmd;
@end
