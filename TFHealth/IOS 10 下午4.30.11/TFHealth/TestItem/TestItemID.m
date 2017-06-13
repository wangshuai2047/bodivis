//
//  TestItemID.m
//  TFHealth
//
//  Created by nico on 14-7-7.
//  Copyright (c) 2014年 studio37. All rights reserved.
//

#import "TestItemID.h"
#import "Health_Items.h"

static NSInteger _Weight=0;
static NSInteger _InFluid=0;
static NSInteger _ExFluid=0;
static NSInteger _TotalWater=0;
static NSInteger _Protein=0;
static NSInteger _Sclerotin=0;
static NSInteger _Fat=0;
static NSInteger _Muscle=0;
static NSInteger _SMuscle=0;
static NSInteger _BloodPressure=0;
static NSInteger _BodyAge=0;
static NSInteger _HealthScore=0;
static NSInteger _PercentWater=0;
static NSInteger _SplanchnaPercentFat=0;

@implementation TestItemID

/**
 获取体重ID
 */
+(NSInteger)getWeight
{
    if(_Weight==0)
    {
        _Weight=[self getHealthItemIDByName:@"体重"];
    }
    return _Weight;
}

/**
 获取细胞内液ID
 */
+(NSInteger)getInFluid
{
    if(_InFluid==0)
    {
        _InFluid=[self getHealthItemIDByName:@"细胞内液"];
    }
    return _InFluid;
}


/**
 获取细胞外液ID
 */
+(NSInteger)getExFluid
{
    if(_ExFluid==0)
    {
        _ExFluid=[self getHealthItemIDByName:@"细胞外液"];
    }
    return _ExFluid;
}

/**
 获取总水分ID
 */
+(NSInteger)getTotalWater
{
    if(_TotalWater==0)
    {
        _TotalWater=[self getHealthItemIDByName:@"总水分"];
    }
    return _TotalWater;
}


/**
 获取蛋白质ID
 */
+(NSInteger)getProtein
{
    if(_Protein==0)
    {
        _Protein=[self getHealthItemIDByName:@"蛋白质"];
    }
    return _Protein;
}


/**
 获取骨质重ID
 */
+(NSInteger)getSclerotin
{
    if(_Sclerotin==0)
    {
        _Sclerotin=[self getHealthItemIDByName:@"骨质重"];
    }
    return _Sclerotin;
}


/**
 获取脂肪ID
 */
+(NSInteger)getFat
{
    if(_Fat==0)
    {
        _Fat=[self getHealthItemIDByName:@"脂肪"];
    }
    return _Fat;
}


/**
 获取肌肉ID
 */
+(NSInteger)getMuscle
{
    if(_Muscle==0)
    {
        _Muscle=[self getHealthItemIDByName:@"肌肉"];
    }
    return _Muscle;
}


/**
 获取骨骼肌ID
 */
+(NSInteger)getSMuscle
{
    if(_SMuscle==0)
    {
        _SMuscle=[self getHealthItemIDByName:@"骨骼肌"];
    }
    return _SMuscle;
}


/*
 获取血压ID
 */
+(NSInteger)getBloodPressure
{
    if(_BloodPressure==0)
    {
        _BloodPressure=[self getHealthItemIDByName:@"血压"];
    }
    return _BloodPressure;
}


/*
 获取身体年龄ID
 */
+(NSInteger)getBodyAge
{
    if(_BodyAge==0)
    {
        _BodyAge=[self getHealthItemIDByName:@"身体年龄"];
    }
    return _BodyAge;
}


/*
 获取健康得分ID
 */
+(NSInteger)getHealthScore
{
    if(_HealthScore==0)
    {
        _HealthScore=[self getHealthItemIDByName:@"健康得分"];
    }
    return _HealthScore;
}

+(NSInteger)getHealthItemIDByName:(NSString*)name
{
    Health_Items* hItem = [Health_Items MR_findFirstByAttribute:@"itemName" withValue:name inContext:[NSManagedObjectContext MR_defaultContext]];
    if(hItem!=nil)
    {
        return [hItem.itemId intValue];
    }
    else
    {
        return 0;
    }
}

/**
 获取水分率ID
 */
+(NSInteger)getPercentWater
{
    if(_PercentWater==0)
    {
        _PercentWater=[self getHealthItemIDByName:@"水分率"];
    }
    return _PercentWater;
}

/**
 获取内脏脂肪率ID
 */
+(NSInteger)getSplanchnaPercentFat
{
    if(_SplanchnaPercentFat==0)
    {
        _SplanchnaPercentFat=[self getHealthItemIDByName:@"内脏脂肪率"];
    }
    return _SplanchnaPercentFat;
}

@end
