//
//  NSManagedObject+UserLog.m
//  TFHealth
//
//  Created by chenzq on 14-9-7.
//  Copyright (c) 2014年 studio37. All rights reserved.
//

#import "UserDevices.h"

@implementation UserDevices

@dynamic deviceType;  ////0手环,1秤,2手环和秤
@synthesize userName;
@dynamic state;  //登录时如果需要跳转，设为1，跳过一次，恢复为0;
@end
