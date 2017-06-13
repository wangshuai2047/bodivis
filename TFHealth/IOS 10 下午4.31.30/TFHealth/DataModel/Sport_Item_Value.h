//
//  Sport_Item_Value.h
//  TFHealth
//
//  Created by chenzq on 14-6-14.
//  Copyright (c) 2014年 studio37. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Sport_Items;

@interface Sport_Item_Value : NSManagedObject

@property (nonatomic, retain) NSNumber * consumptionCalories;
@property (nonatomic, retain) NSNumber * movementTime;
@property (nonatomic, retain) NSNumber * sportId;
@property (nonatomic, retain) NSDate * testDate;
@property (nonatomic, retain) NSNumber * userId;
@property (nonatomic, retain) Sport_Items *sportItemValue_sportItems_ship;
@property (nonatomic, retain) NSManagedObject *sportItemValue_user_ship;

@end
