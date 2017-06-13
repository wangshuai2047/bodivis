//
//  FourpoleSteelyard.m
//  TFHealth
//
//  Created by nico on 14-8-11.
//  Copyright (c) 2014年 studio37. All rights reserved.
//

#import "FourpoleSteelyard.h"

@interface FourpoleSteelyard()
{
    double pWater,weight,height;
    int gender,age;
}

@end

@implementation FourpoleSteelyard


-(FourpoleSteelyard*)init:(double)pw pWeight:(double)w pGender:(int)ge pAge:(int)ag pHeight:(int)he
{
    if([super init]==self)
    {
//        pWater=(pw+((float)(arc4random()%61)-30.0)/100.0)/100;
        pWater=pw/100;
        weight=w;
        gender=ge;
        age=ag;
        height=he;
    }
    return self;
}

/**
 @brief 计算体脂率
 */
-(double)calcPBF
{
    double result=0;
    //男   p% =（1-(a/73.81)+(0.6/W)）*100-1
    //女   p% =（1-(a/73.81)+(0.6/W)）*100+1
    if(gender==1)
    {
        result=(1-(pWater*100/73.81)+(0.6/ weight))*100-1;
    }
    else
    {
        result=(1-(pWater*100/73.81)+(0.6/weight))*100+1;
    }
    return result/100;
}

//计算脂肪重
-(double)calcFatWeight
{
    return weight*[self calcPBF];
}

/**
 @brief 计算体水分重
 */
-(double)calcWaterWeight
{
    return weight * pWater;
}

/**
 @brief 计算体肌肉重
 */
-(double)calcMuscleWeight
{
    double result = [self calcWaterWeight]/0.78;
    if(gender==1)
    {
        result = result-0.4;
    }
    else
    {
        result = result-1.5;
    }
    return result;
}

/**
 @brief 计算蛋白质重
 */
-(double)calcProteinWeight
{
    double result= [self calcMuscleWeight]-[self calcWaterWeight];
    if(gender==1)
    {
        result=result;
    }
    else
    {
        result=result;
    }
    return result;
}

/**
 @brief 计算骨重
 */
-(double)calcBoneWeight
{
    double f=[self calcFatWeight];
    double m=[self calcMuscleWeight];
    double result = weight-f-m;
    if(gender==1)
    {
        result=result;
    }
    else
    {
        result=result;
    }
    return result;
}

/**
 @brief 计算骨骼肌重
 */
-(double)calcSMuscle
{
    return [self calcMuscleWeight]*0.7135;
}

@end
