//
//  UserCoreValueSync.m
//  TFHealth
//
//  Created by nico on 14-12-2.
//  Copyright (c) 2014年 studio37. All rights reserved.
//

#import "UserCoreValueSync.h"
#import "AppCloundService.h"
#import "UserCoreValues.h"

@implementation UserCoreValueSync

static int ucdownloadExists=0;
static DataSyncBase* ucdownloadInstance;

-(void)setInstance
{
    ucdownloadInstance = self;
}

-(void)setDownloadFlag:(int)flag
{
    ucdownloadExists=flag;
}

-(int)getDownloadFlag
{
    return ucdownloadExists;
}

-(BOOL)isSingleResult
{
    return false;
}

-(BOOL)isExist:(int)uid uname:(NSString*)uname
{
    UserCoreValues* uc = [UserCoreValues MR_findFirstByAttribute:@"userId" withValue:[NSNumber numberWithInt:uid] inContext:[NSManagedObjectContext MR_defaultContext]];
    return uc!=nil;
}

-(void)queryData
{
    [self.service getUserCoreValue:self.userId];
}

-(void)updateData:(NSDictionary*)keyValues
{
    int calorieValue=0;
    double kmCount=0;
    int lastCoreCalorieValue=0;
    int lastCoreStep=0;
    int sleepTimeCount=0;
    int stepCount=0;
    int timeLenght =0;
    
    int itemId = [keyValues[@"ItemId"] intValue];
    int userId = [keyValues[@"UserId"] intValue];
    int coreId = [keyValues[@"CoreId"] intValue];

    NSDate* createTime = [self convertDate:(NSString*)keyValues[@"CreateTime"]];
    NSString* itemName = keyValues[@"ItemName"];
    if (keyValues[@"CalorieValue"]!=[NSNull null]) {
        calorieValue = [keyValues[@"CalorieValue"] intValue];
    }
    if (keyValues[@"KmCount"]!=[NSNull null]) {
        kmCount  = [keyValues[@"KmCount"] doubleValue];
    }
    if (keyValues[@"LastCoreCalorieValue"]!=[NSNull null]) {
        lastCoreCalorieValue = [keyValues[@"LastCoreCalorieValue"] intValue];
    }
    if (keyValues[@"LastCoreStep"]!=[NSNull null]) {
        lastCoreStep = [keyValues[@"LastCoreStep"] intValue];
    }
    if (keyValues[@"SleepTimeCount"]!=[NSNull null]) {
        sleepTimeCount = [keyValues[@"SleepTimeCount"] intValue];
    }
    if (keyValues[@"StepCount"]!=[NSNull null]) {
        stepCount = [keyValues[@"StepCount"] intValue];
    }
    if (keyValues[@"TimeLenght"]!=[NSNull null]) {
        timeLenght = [keyValues[@"TimeLenght"] intValue];
    }
    
    
    UserCoreValues* array = [UserCoreValues MR_findFirstWithPredicate:[NSPredicate predicateWithFormat:@"userId==%d AND createTime==%@ AND itemId==%d",userId,createTime,itemId] inContext:[NSManagedObjectContext MR_contextForCurrentThread]];
    if(array==nil)
    {
        UserCoreValues* uc =[UserCoreValues MR_createEntity];
        uc.calorieValue = [NSNumber numberWithInt:calorieValue];
        uc.coreId = [NSNumber numberWithInt:coreId];
        uc.createTime = createTime;
        uc.itemId = [NSNumber numberWithInt:itemId];
        uc.itemName = itemName;
        uc.kmCount = [NSNumber numberWithDouble:kmCount];
        uc.lastCalorieValue = [NSNumber numberWithInt:lastCoreCalorieValue];
        uc.lastCoreStep = [NSNumber numberWithInt:lastCoreStep];
        uc.sleepTimeCount = [NSNumber numberWithInt:sleepTimeCount];
        uc.timeLenght = [NSNumber numberWithInt:timeLenght];
        uc.userId = [NSNumber numberWithInt:userId];
        uc.stepCount = [NSNumber numberWithInt:stepCount];
    }
}

-(NSString*)getMethodName
{
    return @"GetUserCoreValueJson";
}

@end
