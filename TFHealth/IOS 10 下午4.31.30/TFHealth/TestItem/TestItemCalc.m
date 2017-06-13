//
//  TestItemCalc.m
//  TFHealth
//
//  Created by nico on 14-7-6.
//  Copyright (c) 2014年 studio37. All rights reserved.
//

#import "TestItemCalc.h"

@implementation TestItemCalc

+(NSNumber*)calcPBF:(NSNumber*) weight pFat:(NSNumber*) fat
{
    return [NSNumber numberWithDouble: [fat doubleValue]/[weight doubleValue] * 100];
}

+(NSNumber*)calcMinPBF:(NSNumber*) weight pFat:(NSNumber*) fat pSexy:(BOOL)sexy
{
    //    NSNumber* minFat = [self calcMinFat:weight pSexy:sexy];
    //    return [self calcPBF:weight pFat:minFat];
    if(sexy)
    {
        return [NSNumber numberWithDouble:10];
    }
    else
    {
        return [NSNumber numberWithDouble:18];
    }
}

+(NSNumber*)calcMaxPBF:(NSNumber*) weight pFat:(NSNumber*) fat pSexy:(BOOL)sexy
{
    //    NSNumber* maxFat = [self calcMaxFat:weight pSexy:sexy];
    //    return [self calcPBF:weight pFat:maxFat];
    if(sexy)
    {
        return [NSNumber numberWithDouble:20];
    }
    else
    {
        return [NSNumber numberWithDouble:28];
    }
}

+(NSNumber*)calcMinFat:(NSNumber*) weight pSexy:(BOOL)sexy
{
    if(sexy) // 男性
    {
        return [NSNumber numberWithDouble: 0.1*[weight doubleValue]];
    }
    else
    {
        return [NSNumber numberWithDouble: 0.18*[weight doubleValue]];
    }
}

+(NSNumber*)calcMaxFat:(NSNumber*) weight pSexy:(BOOL)sexy
{
    if(sexy) // 男性
    {
        return [NSNumber numberWithDouble: 0.2*[weight doubleValue]];
    }
    else
    {
        return [NSNumber numberWithDouble: 0.28*[weight doubleValue]];
    }
}

+(NSNumber*)calcMinTotalWater:(NSNumber*)weight
{
    return [NSNumber numberWithDouble: 0.6*weight.doubleValue*0.9];
}

+(NSNumber*)calcMaxTotalWater:(NSNumber*)weight
{
    return [NSNumber numberWithDouble: 0.6*weight.doubleValue*1.1];
}

+(NSNumber*)calcMinSclerotin:(NSNumber*)weight
{
    return [NSNumber numberWithDouble: 0.045*weight.doubleValue];
}

+(NSNumber*)calcMaxSclerotin:(NSNumber*)weight
{
    return [NSNumber numberWithDouble: 0.055*weight.doubleValue];
}

+(NSNumber*)calcMinMuscle:(NSNumber*)height pSexy:(BOOL)sexy
{
    NSNumber* sw = [self calcStandardMuscle:height pSexy:sexy];
    if(sexy) // 男性
    {
        return [NSNumber numberWithDouble: 0.9*[sw doubleValue]];
    }
    else
    {
        return [NSNumber numberWithDouble: 0.9*[sw doubleValue]];
    }
}

+(NSNumber*)calcMaxMuscle:(NSNumber*)height pSexy:(BOOL)sexy
{
     NSNumber* sw = [self calcStandardMuscle:height pSexy:sexy];
    if(sexy) // 男性
    {
        return [NSNumber numberWithDouble: [sw doubleValue]*1.1];
    }
    else
    {
        return [NSNumber numberWithDouble: [sw doubleValue]*1.1];
    }
}

+(NSNumber*)calcStandardWeight:(NSNumber*)height pSexy:(BOOL)sexy
{
    //    男： SW = 0.00452×H×H –0.55564×H + 26.36570（R^2=1）
    //    女： SW = 0.00465×H×H –0.59980×H + 29.99886（R^2=1）
    if(sexy) // 男性
    {
        return [NSNumber numberWithDouble: 0.00452*[height doubleValue]*height.doubleValue-0.55564*height.doubleValue+26.36570];
    }
    else
    {
        return [NSNumber numberWithDouble: 0.00465*height.doubleValue*height.doubleValue-0.59980*height.doubleValue + 29.99886];
    }
}

+(NSNumber*)calcBMI:(NSNumber*)weight pHeight:(NSNumber*)height
{
    //（BMI）=体重（kg）÷身高（m）的平方
    return [NSNumber numberWithDouble:weight.doubleValue/(height.doubleValue/100*height.doubleValue/100)];
}

+(NSNumber*)calcMinBMI
{
    return [NSNumber numberWithDouble:18.5];
}

+(NSNumber*)calcMaxBMI
{
    //return [NSNumber numberWithDouble:25];
    return [NSNumber numberWithDouble:24]; //2015.05.26 需求变更25改为24
}

+(NSString*)calcSomatotype:(NSNumber*)pbf pBMI:(NSNumber*)bmi pSexy:(BOOL)sexy
{
    NSArray* types=[[NSArray alloc] initWithObjects:
                    [[NSArray alloc] initWithObjects:@"隐性肥胖型",@"脂肪过多型",@"肥胖型",nil],
                    [[NSArray alloc] initWithObjects:@"肌肉不足型",@"健康匀称型",@"超重肌肉型",nil],
                    [[NSArray alloc] initWithObjects:@"消瘦型",@"低脂肪型",@"运动员型",nil],
                    nil];
    double minBmi=18.5;
    double maxBmi=25;
    double minPbf=20;
    double maxPbf=30;
    int row=1;
    int col=1;
    if(sexy) // 男性
    {
        minPbf=10;
        maxPbf=20;
    }
    if(pbf.doubleValue<minPbf)
    {
        row=2;
    }
    else if(pbf.doubleValue>maxPbf){
        row=0;
    }
    if(bmi.doubleValue<minBmi)
    {
        col=0;
    }
    else if(bmi.doubleValue>maxBmi)
    {
        col=2;
    }
    return [[types objectAtIndex:row] objectAtIndex:col];
}

+(NSNumber*)calcMinWeight:(NSNumber*)height pSexy:(BOOL)sexy
{
    NSNumber* sw = [self calcStandardWeight:height pSexy:sexy];
    return [NSNumber numberWithDouble:0.9*sw.doubleValue];
}

+(NSNumber*)calcMaxWeight:(NSNumber*)height pSexy:(BOOL)sexy
{
    NSNumber* sw = [self calcStandardWeight:height pSexy:sexy];
    return [NSNumber numberWithDouble:1.1*sw.doubleValue];
}

+(NSNumber*)calcMinInFluid:(NSNumber*)weight
{
    return [NSNumber numberWithDouble:weight.doubleValue*0.33];
}

+(NSNumber*)calcMaxInFluid:(NSNumber*)weight
{
    return [NSNumber numberWithDouble:weight.doubleValue*0.47];
}

+(NSNumber*)calcMinExFluid:(NSNumber*)weight
{
    return [NSNumber numberWithDouble:weight.doubleValue*0.17];
}

+(NSNumber*)calcMaxExFluid:(NSNumber*)weight
{
    return [NSNumber numberWithDouble:weight.doubleValue*0.23];
}

+(NSNumber*)calcMinProtein:(NSNumber*)weight
{
    return [NSNumber numberWithDouble:weight.doubleValue*0.1395];
}

+(NSNumber*)calcMaxProtein:(NSNumber*)weight
{
    return [NSNumber numberWithDouble:weight.doubleValue*0.1705];
}

+(NSNumber*)calcMinSMuscle:(NSNumber*)height pSexy:(BOOL)sexy
{
    //骨骼肌(男)	0.75*0.9*标准肌肉 	0.75*1.1*标准肌肉
    //骨骼肌(女)	0.75*0.9*标准肌肉 	0.75*1.1*标准肌肉
    NSNumber* sw = [self calcStandardMuscle:height pSexy:sexy];
    if(sexy) // 男性
    {
        return [NSNumber numberWithDouble: 0.75*[sw doubleValue]*0.9];
    }
    else
    {
        return [NSNumber numberWithDouble: 0.75*[sw doubleValue]*0.9];
    }
}

+(NSNumber*)calcMaxSMuscle:(NSNumber*)height pSexy:(BOOL)sexy
{
    NSNumber* sw = [self calcStandardMuscle:height pSexy:sexy];
    if(sexy) // 男性
    {
        return [NSNumber numberWithDouble: 0.75*[sw doubleValue]*1.1];
    }
    else
    {
        return [NSNumber numberWithDouble: 0.75*[sw doubleValue]*1.1];
    }
}

+(NSNumber*)calcBMR:(NSNumber*)weight pHeight:(NSNumber*)height pAge:(int)age pSexy:(bool)sexy
{
    double result;
    //（男） BMR =10*W+6.25*h-5*age+5
    //（女） BMR =10*W+6.25*h-5*age-161
    if(sexy)
    {
        result=10*weight.doubleValue+6.25*height.doubleValue-5*age+5;
    }
    else
    {
        result=10*weight.doubleValue+6.25*height.doubleValue-5*age-161;
    }
    return [NSNumber numberWithDouble:result];
}

/**
 公式不准确，改为用体重减脂肪，此方法暂保留
 */
+(NSNumber*)calcLBM:(NSNumber*)height pSexy:(BOOL)sexy
{
    NSNumber* sw = [self calcStandardWeight:height pSexy:sexy];
    //LBM=((S + 0.5684)/(1 - 0.0537))
    return [NSNumber numberWithDouble:((sw.doubleValue + 0.5684)/(1 - 0.0537))];
}

+(NSNumber*)calcFatControl:(NSNumber*)weight pFat:(NSNumber*)fat pSexy:(BOOL)sexy
{
    double result=0;
    if(sexy)  //男
    {
        if(fat.doubleValue>weight.doubleValue*0.2)
        {
            result=weight.doubleValue*0.15-fat.doubleValue;
        }
        else if(fat.doubleValue <weight.doubleValue*0.1)
        {
            result=weight.doubleValue*0.1-fat.doubleValue;
        }
        else
        {
            result=0;
        }
    }
    else // 女
    {
        if(fat.doubleValue>weight.doubleValue*0.28)
        {
            result=weight.doubleValue*0.23-fat.doubleValue;
        }
        else if(fat.doubleValue<weight.doubleValue*0.18)
        {
            result=weight.doubleValue*0.18-fat.doubleValue;
        }
        else
        {
            result=0;
        }
    }
    return [NSNumber numberWithDouble:result];
}

+(NSNumber*)calcMuscleControl:(NSNumber*)height pMuscle:(NSNumber*)muscle pSexy:(BOOL)sexy
{
    //    肌肉控制（肌肉SLM）
    //    (SLM < m_smm)?(m_smm - SLM):0 ;
    NSNumber* sm=[self calcStandardMuscle:height pSexy:sexy];
    double result = (muscle.doubleValue<sm.doubleValue)?(sm.doubleValue-muscle.doubleValue):0;
    return [NSNumber numberWithDouble:result];
}

+(NSNumber*)calcStandardMuscle:(NSNumber*)height pSexy:(BOOL)sexy
{
    //    //标准肌肉m_smm
    //    女=(0.00351 * 身高的平方- 0.4661 *身高 + 23.04821):
    //    男=(0.00344 * 身高的平方- 0.37678 *身高 + 14.40021);
    double m_smm=0;
    if(sexy) // 男
    {
        m_smm =0.00344*height.doubleValue*height.doubleValue-0.37678*height.doubleValue+14.40021;
    }
    else
    {
        m_smm =0.00351*height.doubleValue*height.doubleValue-0.4661 *height.doubleValue+23.04821;
    }
    return [NSNumber numberWithDouble:m_smm];
}

+(NSString*)calcFatLevel:(NSNumber*)bmi
{
    double value=bmi.doubleValue;
    NSString* result;
    //    较轻      <18.5
    //    正常      18.5<= BMI<25
    //    超重      25<= BMI<30
    //    肥胖一级  30<=BMI <35
    //    肥胖二级  35<=BMI <40
    //    肥胖三级  BMI>=40
    if(value<18.5)
    {
        result=@"较轻";
    }
    else if(value>=18.5 && value<25)
    {
        result=@"正常";
    }
    else if(value>=25 && value<30)
    {
        result=@"超重";
    }
    else if(value>=30 && value<35)
    {
        result=@"肥胖一级";
    }
    else if(value>=35 && value<40)
    {
        result=@"肥胖二级";
    }
    else
    {
        result=@"肥胖三级";
    }
    return  result;
}

+(NSString*)calcFatLevelByPbf:(NSNumber*)pbf pSexy:(BOOL)sexy
{
    double value=pbf.doubleValue;
    NSString* result;
    if(sexy)// 男
    {
        //        16以下较轻
        //        16=<<20 正常
        //        20=<<24 轻度肥胖
        //        24=<<28 中度肥胖
        //        28=<<30 重度肥胖
        //        >=30极度肥胖
        if(value<16)
        {
            result=@"较轻";
        }
        else if(value>=16 && value<20)
        {
            result=@"正常";
        }
        else if(value>=20 && value<24)
        {
            result=@"轻度";
        }
        else if(value>=24 && value<28)
        {
            result=@"中度";
        }
        else if(value>=28 && value<30)
        {
            result=@"重度";
        }
        else if(value>=30)
        {
            result=@"极度";
        }

    }
    else
    {
        //        18以下较轻
        //        18=<<22 正常
        //        22=<<26 轻度肥胖
        //        26=<<29 中度肥胖
        //        29=<<35 重度肥胖
        //        >=35 极度肥胖
        if(value<18)
        {
            result=@"较轻";
        }
        else if(value>=18 && value<22)
        {
            result=@"正常";
        }
        else if(value>=22 && value<26)
        {
            result=@"轻度";
        }
        else if(value>=26 && value<29)
        {
            result=@"中度";
        }
        else if(value>=29 && value<35)
        {
            result=@"重度";
        }
        else if(value>=35)
        {
            result=@"极度";
        }
    }
    return result;
}

@end
