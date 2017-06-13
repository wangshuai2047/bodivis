//
//  FoodClass.h
//  TFHealth
//
//  Created by chenzq on 14-6-14.
//  Copyright (c) 2014年 studio37. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface UserCoreValues : NSManagedObject

@property (nonatomic, retain) NSNumber * coreId;
@property (nonatomic, retain) NSNumber * userId;
@property (nonatomic, retain) NSNumber * itemId;
@property (nonatomic, retain) NSString * itemName;
@property (nonatomic, retain) NSNumber * stepCount;
@property (nonatomic, retain) NSNumber * timeLenght;
@property (nonatomic, retain) NSNumber * calorieValue;
@property (nonatomic, retain) NSNumber * kmCount;
@property (nonatomic, retain) NSDate * createTime;
@property (nonatomic,retain) NSNumber *sleepTimeCount;
@property (nonatomic,retain) NSNumber *lightSleepCount;
@property (nonatomic,retain) NSNumber *soberSleepCount;

//上一次从手环读出的步数，用于计算系数步数使用
@property (nonatomic,retain) NSNumber *lastCoreStep;
//上一次从手环读出的卡路里，用于计算系数卡路里使用
@property (nonatomic,retain) NSNumber *lastCalorieValue;
@end
