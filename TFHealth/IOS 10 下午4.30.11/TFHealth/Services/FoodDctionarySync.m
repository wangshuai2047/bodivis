//
//  FoodDctionarySync.m
//  TFHealth
//
//  Created by nico on 14-12-2.
//  Copyright (c) 2014年 studio37. All rights reserved.
//

#import "FoodDctionarySync.h"
#import "FoodDictionary.h"
#import "AppCloundService.h"

@implementation FoodDctionarySync

static int fddownloadExists=0;
static DataSyncBase* fddownloadInstance;

-(void)setInstance
{
    fddownloadInstance = self;
}

-(void)setDownloadFlag:(int)flag
{
    fddownloadExists=flag;
}

-(int)getDownloadFlag
{
    return fddownloadExists;
}

-(BOOL)isSingleResult
{
    return false;
}

-(BOOL)isExist:(int)uid uname:(NSString*)uname
{
    //FoodDictionary* fd = [FoodDictionary MR_findFirstInContext:[NSManagedObjectContext MR_defaultContext]];
    //return fd!=nil;
    return false;
}

-(void)queryData
{    
    [self.service getFoodDictionary];
}

-(void)updateData:(NSDictionary*)keyValues
{
    FoodDictionary* fd = [FoodDictionary MR_findFirstByAttribute:@"foodId" withValue:[NSNumber numberWithInt:[keyValues[@"FoodID"]intValue]] inContext:[NSManagedObjectContext MR_contextForCurrentThread]];
    if(fd==nil)
    {
        FoodDictionary *fDictionary = [FoodDictionary MR_createEntity];
        [fDictionary setClassId:[NSNumber numberWithInt:[keyValues[@"ClassId"]intValue]]];
        [fDictionary setFoodName:keyValues[@"FoodName"]];
        [fDictionary setFoodId:[NSNumber numberWithInt:[keyValues[@"FoodID"]intValue]]];
        [fDictionary setGramValue:[NSNumber numberWithInt:[keyValues[@"GramValue"] intValue]]];
        [fDictionary setCaloriesValue:[NSNumber numberWithInt:[keyValues[@"CaloriesValue"]intValue]]];
    }
}

-(NSString*)getMethodName
{
    return @"GetFoodDictionaryJson";
}

@end
