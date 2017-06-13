//
//  PersonalSetSync.m
//  TFHealth
//
//  Created by nico on 14-12-2.
//  Copyright (c) 2014年 studio37. All rights reserved.
//

#import "PersonalSetSync.h"
#import "AppCloundService.h"
#import "PersonalSet.h"

@implementation PersonalSetSync

static int psdownloadExists=0;
static DataSyncBase* psdownloadInstance;

-(void)setInstance
{
    psdownloadInstance = self;
}

-(void)setDownloadFlag:(int)flag
{
    psdownloadExists=flag;
}

-(int)getDownloadFlag
{
    return psdownloadExists;
}

-(BOOL)isSingleResult
{
    return false;
}

-(BOOL)isExist:(int)uid uname:(NSString*)uname
{
    PersonalSet* ps = [PersonalSet MR_findFirstByAttribute:@"userId" withValue:[NSString stringWithFormat:@"%d", uid] inContext:[NSManagedObjectContext MR_defaultContext]];
//    PersonalSet *ps=[PersonalSet MR_findFirstWithPredicate:[NSPredicate predicateWithFormat:@"userId==%d",uid] sortedBy:@"startDate" ascending:NO inContext:[NSManagedObjectContext MR_defaultContext]];
    return ps!=nil;
}

-(void)queryData
{
    [self.service getUserPersonalSetInfo:self.userId];
}

-(void)updateData:(NSDictionary*)keyValues
{
    if (keyValues.count==0) {
        return;
    }
    
    NSDate* cDate = nil;
    
    if (keyValues[@"CompletedTargetDate"] != [NSNull null]) {
        cDate=[self convertDate:(NSString*)keyValues[@"CompletedTargetDate"]];;
    }
    
    NSDate* eDate = [self convertDate:(NSString*)keyValues[@"EndDate"]];
    double foodTarget = [keyValues[@"FoodSubTarget"] doubleValue];
//    int pid = [keyValues[@"FoodSubTarget"] intValue];
    int pid = [keyValues[@"ID"] intValue];
    //NSString* remark = (NSString*)keyValues[@"Remarks"];
    NSString* remindTime =(NSString*)keyValues[@"RemindTime"];
    NSString* remindWay = (NSString*)keyValues[@"RemindWay"];
    NSString* sleepTimeLength = (NSString*)keyValues[@"SleepTimeLength"];
    double sportSubTarget = [keyValues[@"SportSubTarget"] doubleValue];
    NSDate* sDate =[self convertDate:(NSString*)keyValues[@"StartDate"]];
    int stepCount = [keyValues[@"StepCount"] intValue];
    int stepLength = [keyValues[@"StepLength"] intValue];
    double targetWeight = [keyValues[@"TargetWeight"] doubleValue];
    int userID = [keyValues[@"UserID"] intValue];
    double weekTarget = [keyValues[@"WeekTarget"] doubleValue];
    
    PersonalSet* ps = [PersonalSet MR_findFirstByAttribute:@"userId" withValue:[NSString stringWithFormat:@"%d", self.userId] inContext:[NSManagedObjectContext MR_contextForCurrentThread]];
    if(ps==nil)
    {
        PersonalSet* pSet = [PersonalSet MR_createEntity];
        pSet.completedDate = cDate;
        pSet.endDate = eDate;
        pSet.foodSubtract = [NSNumber numberWithDouble:foodTarget];
        pSet.remindTime = remindTime;
        pSet.remindWay = [self getIntValue:remindWay];
        pSet.sleepTimeLength = [self getIntValue:sleepTimeLength];
        pSet.sportSubtract = [NSNumber numberWithDouble:sportSubTarget];
        pSet.startDate = sDate;
        pSet.stepTargetCount = [NSNumber numberWithInt:stepCount];
        pSet.stepLength = [NSNumber numberWithInt:stepLength];
        pSet.targetWeight = [NSNumber numberWithDouble:targetWeight];
        pSet.userId = [NSNumber numberWithInt:userID];
        pSet.personId = [NSNumber numberWithInt:pid];
        pSet.weekTarget = [NSNumber numberWithDouble:weekTarget];
    }
    else
    {
        ps.completedDate = cDate;
        ps.endDate = eDate;
        ps.foodSubtract = [NSNumber numberWithDouble:foodTarget];
        ps.remindTime = remindTime;
        ps.remindWay = [self getIntValue:remindWay];
        ps.sleepTimeLength = [self getIntValue:sleepTimeLength];
        ps.sportSubtract = [NSNumber numberWithDouble:sportSubTarget];
        ps.startDate = sDate;
        ps.stepTargetCount = [NSNumber numberWithInt:stepCount];
        ps.stepLength = [NSNumber numberWithInt:stepLength];
        ps.targetWeight = [NSNumber numberWithDouble:targetWeight];
        ps.userId = [NSNumber numberWithInt:userID];
        ps.personId = [NSNumber numberWithInt:pid];
        ps.weekTarget = [NSNumber numberWithDouble:weekTarget];
    }
}

-(NSString*)getMethodName
{
    return @"GetUserPersonalSetInfoJson";
}
@end
