//
//  FoodClass.h
//  TFHealth
//
//  Created by chenzq on 14-6-14.
//  Copyright (c) 2014年 studio37. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class FoodDictionary;

@interface FoodClass : NSManagedObject

@property (nonatomic, retain) NSString * classDesc;
@property (nonatomic, retain) NSNumber * classId;
@property (nonatomic, retain) NSString * cName;
@property (nonatomic, retain) FoodDictionary *foodClass_foodDictionary_ship;

@end
