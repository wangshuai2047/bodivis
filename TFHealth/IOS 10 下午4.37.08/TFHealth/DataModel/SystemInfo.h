//
//  SystemInfo.h
//  TFHealth
//
//  Created by chenzq on 14-6-14.
//  Copyright (c) 2014年 studio37. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface SystemInfo : NSManagedObject

@property (nonatomic, retain) NSString * language;
@property (nonatomic, retain) NSNumber * remindTime;
@property (nonatomic, retain) NSNumber * remindWay;
@end
