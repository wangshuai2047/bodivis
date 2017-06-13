//
//  FourpoleSteelyard.h
//  TFHealth
//
//  Created by nico on 14-8-11.
//  Copyright (c) 2014年 studio37. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 @brief 四点极称数据计算
 */
@interface FourpoleSteelyard : NSObject

-(FourpoleSteelyard*)init:(double)pw pWeight:(double)w pGender:(int)ge pAge:(int)ag pHeight:(int)he;

/**
 @brief 计算体脂率
 */
-(double)calcPBF;

/**
 @brief 计算脂肪重
 */
-(double)calcFatWeight;

/**
 @brief 计算体水分重
 */
-(double)calcWaterWeight;

/**
 @brief 计算体肌肉重
 */
-(double)calcMuscleWeight;

/**
 @brief 计算蛋白质重
 */
-(double)calcProteinWeight;

/**
 @brief 计算骨重
 */
-(double)calcBoneWeight;

/**
 @brief 计算骨骼肌重
 */
-(double)calcSMuscle;

@end
