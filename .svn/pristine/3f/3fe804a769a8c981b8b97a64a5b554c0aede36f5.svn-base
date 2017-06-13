//
//  FoodClass.m
//  TFHealth
//
//  Created by nico on 14-11-23.
//  Copyright (c) 2014年 studio37. All rights reserved.
//

#import "FoodClassSync.h"
#import "FoodClass.h"
#import "AppCloundService.h"
#import "AppDelegate.h"

@implementation FoodClassSync

static int fcdownloadExists=0;
static DataSyncBase* fcdownloadInstance;

-(void)setInstance
{
    fcdownloadInstance = self;
}

-(void)setDownloadFlag:(int)flag
{
    fcdownloadExists=flag;
}

-(int)getDownloadFlag
{
    return fcdownloadExists;
}

-(BOOL)isSingleResult
{
    return false;
}

-(BOOL)isExist:(int)uid uname:(NSString*)uname
{
    //FoodClass* fc = [FoodClass MR_findFirstInContext:[NSManagedObjectContext MR_defaultContext]];
    //return fc!=nil;
    return false;
}

-(void)queryData
{
//    [self.service getFoodClass];
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    if (appDelegate.languageIndex == 1) {//英语
        [self.service LanguageGetFoodClass:2];
    } else {
        [self.service LanguageGetFoodClass:1];
    }
    
}

-(void)updateData:(NSDictionary*)keyValues
{
    FoodClass* fc = [FoodClass MR_findFirstByAttribute:@"classId" withValue:[NSNumber numberWithInt:[keyValues[@"ClassId"]intValue]] inContext:[NSManagedObjectContext MR_contextForCurrentThread]];
    if(fc==nil)
    {
        FoodClass *fClass = [FoodClass MR_createEntity];
        [fClass setClassId:[NSNumber numberWithInt:[keyValues[@"ClassId"]intValue]]];
        [fClass setCName:keyValues[@"ClassName"]];
        if (keyValues[@"ClassDesc"]!=nil&& (NSNull *)keyValues[@"ClassDesc"] != [NSNull null]) {
            [fClass setClassDesc:keyValues[@"ClassDesc"]];
        }
    }
}

-(NSString*)getMethodName
{
//    return @"GetFoodClassJson";
    return @"LanguageGetFoodClassJson";
}

@end
