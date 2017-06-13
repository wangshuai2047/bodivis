//
//  TestItemCalc.h
//  TFHealth
//
//  Created by nico on 14-7-6.
//  Copyright (c) 2014年 studio37. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TestItemCalc : NSObject

/**
 计算体脂率
 */
+(NSNumber*)calcPBF:(NSNumber*) weight pFat:(NSNumber*) fat;

/**
 计算最小体脂率
 */
+(NSNumber*)calcMinPBF:(NSNumber*) weight pFat:(NSNumber*) fat pSexy:(BOOL)sexy;

/**
 计算最大体脂率
 */
+(NSNumber*)calcMaxPBF:(NSNumber*) weight pFat:(NSNumber*) fat pSexy:(BOOL)sexy;

/**
 计算最小脂肪
 */
+(NSNumber*)calcMinFat:(NSNumber*) weight pSexy:(BOOL)sexy;

/**
 计算最大脂肪
 */
+(NSNumber*)calcMaxFat:(NSNumber*) weight pSexy:(BOOL)sexy;

/**
 计算最小总水分
 */
+(NSNumber*)calcMinTotalWater:(NSNumber*)weight;

/**
 计算最大总水分
 */
+(NSNumber*)calcMaxTotalWater:(NSNumber*)weight;

/**
 计算最小骨质重
 */
+(NSNumber*)calcMinSclerotin:(NSNumber*)weight;

/**
 计算最大骨质重
 */
+(NSNumber*)calcMaxSclerotin:(NSNumber*)weight;

/**
 计算最小肌肉
 */
+(NSNumber*)calcMinMuscle:(NSNumber*)height pSexy:(BOOL)sexy;

/**
 计算最大肌肉
 */
+(NSNumber*)calcMaxMuscle:(NSNumber*)height pSexy:(BOOL)sexy;

/**
 计算标准体重
 */
+(NSNumber*)calcStandardWeight:(NSNumber*)height pSexy:(BOOL)sexy;

/**
 计算BMI
 */
+(NSNumber*)calcBMI:(NSNumber*)weight pHeight:(NSNumber*)height;

/**
 计算最小BMI
 */
+(NSNumber*)calcMinBMI;

/**
 计算最大BMI
 */
+(NSNumber*)calcMaxBMI;

/**
 计算体型
 @param pbf 体脂率
 @param pBMI bmi
 @param pSexy 性别
 @return 体型文字
 */
+(NSString*)calcSomatotype:(NSNumber*)pbf pBMI:(NSNumber*)bmi pSexy:(BOOL)sexy;

/**
 计算最小体重
 */
+(NSNumber*)calcMinWeight:(NSNumber*)height pSexy:(BOOL)sexy;

/**
 计算最大体重
 */
+(NSNumber*)calcMaxWeight:(NSNumber*)height pSexy:(BOOL)sexy;

/**
 计算最小细胞内液
 */
+(NSNumber*)calcMinInFluid:(NSNumber*)weight;

/**
 计算最大细胞内液
 */
+(NSNumber*)calcMaxInFluid:(NSNumber*)weight;

/**
 计算最小细胞外液
 */
+(NSNumber*)calcMinExFluid:(NSNumber*)weight;

/**
 计算最大细胞外液
 */
+(NSNumber*)calcMaxExFluid:(NSNumber*)weight;

/**
 计算最小蛋白质
 */
+(NSNumber*)calcMinProtein:(NSNumber*)weight;

/**
 计算最大蛋白质
 */
+(NSNumber*)calcMaxProtein:(NSNumber*)weight;

/**
 计算最小骨胳肌
 */
+(NSNumber*)calcMinSMuscle:(NSNumber*)height pSexy:(BOOL)sexy;

/**
 计算最大骨胳肌
 */
+(NSNumber*)calcMaxSMuscle:(NSNumber*)height pSexy:(BOOL)sexy;

/**
 @brief 计算基础代谢
 */
+(NSNumber*)calcBMR:(NSNumber*)weight pHeight:(NSNumber*)height pAge:(int)age pSexy:(bool)sexy;

/**
 @brief 计算去脂体重
 */
+(NSNumber*)calcLBM:(NSNumber*)height pSexy:(BOOL)sexy;

/**
 @brief 计算脂肪控制量
 */
+(NSNumber*)calcFatControl:(NSNumber*)weight pFat:(NSNumber*)fat pSexy:(BOOL)sexy;

/**
 @brief 计算肌肉控制量
 */
+(NSNumber*)calcMuscleControl:(NSNumber*)height pMuscle:(NSNumber*)muscle pSexy:(BOOL)sexy;

/**
 @brief 计算标准肌肉
 */
+(NSNumber*)calcStandardMuscle:(NSNumber*)height pSexy:(BOOL)sexy;

/**
 @brief 计算肥胖等级
 */
+(NSString*)calcFatLevel:(NSNumber*)bmi;

/**
 @brief 根据体脂率计算肥胖等级
 2015､5､26 需求变更，替换calcFatLevel方法
 */
+(NSString*)calcFatLevelByPbf:(NSNumber*)pbf pSexy:(BOOL)sexy;

@end
