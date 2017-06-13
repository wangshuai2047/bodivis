//
//  FoodClass.m
//  TFHealth
//
//  Created by chenzq on 14-6-14.
//  Copyright (c) 2014年 studio37. All rights reserved.
//

#import "UserCoreValues.h"


@implementation UserCoreValues

@dynamic coreId;
@dynamic userId;
@dynamic itemId;
@dynamic itemName;
@dynamic stepCount;
@dynamic timeLenght;
@dynamic calorieValue;
@dynamic kmCount;
@dynamic createTime;
@dynamic sleepTimeCount;
@dynamic soberSleepCount;
@dynamic lightSleepCount;

//上一次从手环读出的步数，用于计算系数步数使用
@dynamic lastCoreStep;
//上一次从手环读出的卡路里，用于计算系数卡路里使用
@dynamic lastCalorieValue;

@end
