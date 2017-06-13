//
//  SprotItemsSync.m
//  TFHealth
//
//  Created by nico on 14-12-2.
//  Copyright (c) 2014年 studio37. All rights reserved.
//

#import "SportItemsSync.h"
#import "AppCloundService.h"
#import "Sport_Items.h"

@implementation SportItemsSync

static int siDownloadExists=0;
static DataSyncBase* siDownloadInstance;

-(void)setInstance
{
    siDownloadInstance = self;
}

-(void)setDownloadFlag:(int)flag
{
    siDownloadExists=flag;
}

-(int)getDownloadFlag
{
    return siDownloadExists;
}

-(BOOL)isSingleResult
{
    return false;
}

-(BOOL)isExist:(int)uid uname:(NSString*)uname
{
    //Sport_Items* fc = [Sport_Items MR_findFirstInContext:[NSManagedObjectContext MR_defaultContext]];
    //return fc!=nil;
    return false;
}

-(void)queryData
{    
    [self.service getSportItems];
}

-(void)updateData:(NSDictionary*)keyValues
{
    NSArray *array = [Sport_Items MR_findByAttribute:@"sportId" withValue:[NSNumber numberWithInt:[keyValues[@"SportID"] intValue]] inContext:[NSManagedObjectContext MR_contextForCurrentThread]];
    if (array.count <= 0) {
        Sport_Items *items = [Sport_Items MR_createEntity];
        
        items.caloriesValue =[self getDoubleValue:keyValues[@"CaloriesValue"]];
        items.sportId = [NSNumber numberWithInt:[keyValues[@"SportID"] intValue]];
        items.sportName = [NSString stringWithFormat:@"%@",keyValues[@"SportName"]];
        items.timeSpan = [self getIntValue:keyValues[@"TimeSpan"]];
        items.unit = [NSString stringWithFormat:@"%@",keyValues[@"Uint"]];
    }
}

-(NSString*)getMethodName
{
    return @"GetSportItemsJson";
}

@end
