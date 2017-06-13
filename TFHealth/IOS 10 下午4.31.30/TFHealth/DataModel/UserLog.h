//
//  NSManagedObject+UserLog.h
//  TFHealth
//
//  Created by chenzq on 14-9-7.
//  Copyright (c) 2014年 studio37. All rights reserved.
//

#import <CoreData/CoreData.h>
#import <Foundation/Foundation.h>

@interface UserLog : NSManagedObject

@property (nonatomic, retain) NSString * username;
@property (nonatomic, retain) NSString * password;
@property (nonatomic, retain) NSDate * lastLoginTime;

@end