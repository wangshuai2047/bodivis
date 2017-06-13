//
//  DalidfoodSync.m
//  TFHealth
//
//  Created by nico on 14-11-17.
//  Copyright (c) 2014年 studio37. All rights reserved.
//


#import "DalidfoodSync.h"
#import "DalidFood.h"
#import "AppCloundService.h"

@implementation DalidfoodSync

static int dfdownloadExists=0;
static DataSyncBase* dfdownloadInstance;

-(void)setInstance
{
    dfdownloadInstance = self;
}

-(void)setDownloadFlag:(int)flag
{
    dfdownloadExists=flag;
}

-(int)getDownloadFlag
{
    return dfdownloadExists;
}

-(BOOL)isSingleResult
{
    return false;
}

-(BOOL)isExist:(int)uid uname:(NSString*)uname
{
    DalidFood* foods=[DalidFood MR_findFirstByAttribute:@"userId" withValue:[NSNumber numberWithInt:uid] inContext:[NSManagedObjectContext MR_defaultContext]];
    return foods!=nil;
}

-(void)queryData
{
    [self.service getUserDiliyFoodWithUserId:self.userId];
}

-(void)updateData:(NSDictionary*)dict
{
    int uid = [dict[@"UserID"] intValue];
    int fid = [dict[@"FoodID"] intValue];
    float calorie = [dict[@"CalorieValue"] floatValue];
    NSString* foodName = (NSString*)dict[@"FoodName"];
    NSString* strDate = (NSString*)dict[@"IntakeDate"];
    NSDate* intakeDate = [self convertDate:strDate];
    float intakeValue = [dict[@"IntakeValue"] floatValue];
    //NSString* remark = [dict[@"Remark"] stringValue];
    int type = [dict[@"Type"] intValue];
    DalidFood* foods=[DalidFood MR_findFirstByAttribute:@"foodId" withValue:[NSString stringWithFormat:@"%d",fid] inContext:[NSManagedObjectContext MR_contextForCurrentThread]];
    if(foods==nil)
    {
        DalidFood* newEntity=[DalidFood MR_createEntity];
        newEntity.userId=[NSNumber numberWithInt:uid];
        newEntity.foodId=[NSNumber numberWithInt:fid];
        newEntity.calorieValue=[NSNumber numberWithFloat:calorie];
        newEntity.foodName=[self getStringValue:foodName];
        newEntity.intakeDate = intakeDate;
        newEntity.intakeValue = [NSNumber numberWithFloat:intakeValue];
        newEntity.type = [NSNumber numberWithInt:type];
    }   
}

-(NSString*)getMethodName
{
    return @"GetUserDaliyFoodJson";
}

@end