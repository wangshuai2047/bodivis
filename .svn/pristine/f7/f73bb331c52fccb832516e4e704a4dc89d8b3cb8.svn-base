//
//  CalcGrades.h
//  TFHealth
//
//  Created by nico on 14-8-11.
//  Copyright (c) 2014年 studio37. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 健康得分，身体年龄计算
 */
@interface CalcGrades : NSObject

/**
 @brief 计算健康得分
 @param pbslm 肌肉百分比
 @param pbfm 脂肪百分比
 @param pbpm 蛋白质百分比
 @param pbmm 骨质百分比
 @param gender 性别，男为1,女为0
 */
+(double)calcScore:(double)pbslm fat:(double)pbfm p:(double)pbpm m:(double)pbmm g:(int)gender a:(int)age;

/**
 @brief 计算身体年龄
 @param score 健康得分
 @param iage 实际年龄
 */
+(int)calcBodyAge:(double)score age:(int)iage gender:(int)igender;
@end
