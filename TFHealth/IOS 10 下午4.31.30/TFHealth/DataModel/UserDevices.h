//
//  NSManagedObject+UserLog.h
//  TFHealth
//
//  Created by chenzq on 14-9-7.
//  Copyright (c) 2014年 studio37. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface UserDevices : NSManagedObject

@property (nonatomic, retain) NSNumber * deviceType;  //0手环,1秤,2手环和秤
@property (nonatomic, retain) NSString * userName;
@property (nonatomic, retain) NSNumber * state;  //登录时如果需要跳转，设为1，跳过一次，恢复为0;
@end