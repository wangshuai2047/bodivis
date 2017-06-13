//
//  FoodDictionary.h
//  TFHealth
//
//  Created by chenzq on 14-6-14.
//  Copyright (c) 2014年 studio37. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class DalidFood;

@interface FoodDictionary : NSManagedObject

@property (nonatomic, retain) NSNumber * caloriesValue;
@property (nonatomic, retain) NSNumber * classId;
@property (nonatomic, retain) NSNumber * foodId;
@property (nonatomic, retain) NSString * foodName;
@property (nonatomic, retain) NSString * unitName;
@property (nonatomic, retain) NSNumber * gramValue;
@property (nonatomic, retain) DalidFood *foodDictionary_dalidFood_ship;
@property (nonatomic, retain) NSManagedObject *foodDictionary_foodclass_ship;

@end
