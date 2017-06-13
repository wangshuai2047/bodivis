//
//  YFBleSendCmd.h
//  TestBleCore
//
//  Created by y61235 on 14-8-15.
//  Copyright (c) 2014年 yftech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WTYBleService.h"
#import "WTYCmdStatus.h"


@interface YFBleSendCmd : NSObject

@property (nonatomic, assign) ListCmd type;
@property (nonatomic, strong) WTYBleService *curBleService;
@property (nonatomic, strong) NSData *receiveData;

- (void)start:(WTYBleService *)bleService protocol:(id<WTYCmdStatus>)protocol;
-(void)finish;
-(void)failed;
-(void)receiveData:(NSData *)data dataLenth:(int)lenth;

@end
