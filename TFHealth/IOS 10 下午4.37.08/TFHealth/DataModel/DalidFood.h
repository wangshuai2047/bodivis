//
//  DalidFood.h
//  TFHealth
//
//  Created by chenzq on 14-6-14.
//  Copyright (c) 2014年 studio37. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface DalidFood : NSManagedObject

@property (nonatomic, retain) NSNumber * calorieValue;
@property (nonatomic, retain) NSNumber * foodId;
@property (nonatomic, retain) NSString * foodName;
@property (nonatomic, retain) NSDate * intakeDate;
@property (nonatomic, retain) NSNumber * intakeValue;
@property (nonatomic, retain) NSNumber * type;
@property (nonatomic, retain) NSNumber * userId;
@property (nonatomic, retain) NSManagedObject *dalidFood_foodDictionary_ship;
@property (nonatomic, retain) NSManagedObject *dalidFood_user_ship;

@end
