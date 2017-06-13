//
//  TestItemID.h
//  TFHealth
//
//  Created by nico on 14-7-7.
//  Copyright (c) 2014年 studio37. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 获取测试项目的ID
 */
@interface TestItemID : NSObject

/**
 获取体重ID
 */
+(NSInteger)getWeight;

/**
 获取细胞内液ID
 */
+(NSInteger)getInFluid ;

/**
 获邓细胞外液ID
 */
+(NSInteger)getExFluid;

/**
 获取总水分ID
 */
+(NSInteger)getTotalWater;

/**
 获取蛋白质ID
 */
+(NSInteger)getProtein;

/**
 获取骨质ID
 */
+(NSInteger)getSclerotin;

/**
 获取脂肪ID
 */
+(NSInteger)getFat;

/**
 获取肌肉ID
 */
+(NSInteger)getMuscle;

/**
 获取骨骼肌ID
 */
+(NSInteger)getSMuscle;

/**
 获取血压ID
 */
+(NSInteger)getBloodPressure;

/**
 获取身体年龄ID
 */
+(NSInteger)getBodyAge;

/**
 获取健康得分ID
 */
+(NSInteger)getHealthScore;

/**
 获取水分率ID
 */
+(NSInteger)getPercentWater;

/**
 获取内脏脂肪率ID
 */
+(NSInteger)getSplanchnaPercentFat;

+(NSInteger)getHealthItemIDByName:(NSString*)name;


@end
