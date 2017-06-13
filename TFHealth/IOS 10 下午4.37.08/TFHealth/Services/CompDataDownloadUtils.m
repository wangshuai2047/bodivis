//
//  CompDataDownloadUtils.m
//  TFHealth
//
//  Created by nico on 14-9-24.
//  Copyright (c) 2014年 studio37. All rights reserved.
//

#import "CompDataDownloadUtils.h"
#import "ServiceCallbackDelegate.h"
#import "AppDelegate.h"
#import "AppCloundService.h"
#import "User_Item_Info.h"
#import "ItemDataSyncStatus.h"
#import "TestItemID.h"

@interface CompDataDownloadUtils()<ServiceObjectDelegate>
{
    AppCloundService* service;
    int userId;
}

-(void)serviceSuccessed:(NSDictionary*)keyValues pMethod:(NSString*)method;
-(void)serviceFailed:(NSString*) message pMethod:(NSString*)method;

@end

static CompDataDownloadUtils* downloadInstance;
static int downloadExists=0;

@implementation CompDataDownloadUtils

-(void)downloadData
{
    AppDelegate *appdelegate =(AppDelegate*) [[UIApplication sharedApplication] delegate];
    User* user = appdelegate.user;
    if(user==nil)
    {
        NSLog(@"无下载用户");
        return;
    }
    if(downloadExists==1)
    {
        return;
    }
    
    ItemDataSyncStatus* dataStatus=[ItemDataSyncStatus MR_findFirstByAttribute:@"userId" withValue:user.userId inContext:[NSManagedObjectContext MR_defaultContext]];
    if(dataStatus==nil || dataStatus.compflag.intValue!=1)
    {
        downloadInstance=self;
        userId=user.userId.intValue;
        downloadExists=1;
        service =[[AppCloundService alloc] initWidthDelegate:self];
        [service getUserCompInfo:user.userId.intValue];
    }
}


-(void)serviceSuccessed:(NSDictionary*)keyValues pMethod:(NSString*)method
{
    if([method isEqualToString:@"GetUserCompInfoJson"])
    {
        NSString* queueName=@"TFHealth_DownloadData_UserCompItem_Queue";
        const char* qc=[queueName UTF8String];
        dispatch_queue_t q = dispatch_queue_create(qc, nil);
        dispatch_async(q, ^(void){
            int uid=-1;
            for (NSDictionary *dict in keyValues) {
                uid = [dict[@"UserID"] intValue];
                int cid = [dict[@"CID"] intValue];
                //NSString* remark = dict[@"Remarks"];
                NSString* summary = (NSString* )dict[@"Summary"];
                //NSString* sync = [@"SynchronizedStatus"] ;
                
                NSString* strDate = (NSString*)dict[@"TestDate"];
                double tick= [[strDate substringWithRange:NSMakeRange(6, 13)] doubleValue]/1000;
                NSDate* testDate = [NSDate dateWithTimeIntervalSince1970:tick];
                
                double score = [dict[@"TestScore"] doubleValue];
                
                User_Item_Info* item =[User_Item_Info MR_createEntity];
                item.cid=[NSNumber numberWithInt: cid];
                item.userId=[NSNumber numberWithInt:uid];
                item.testDate=testDate;
                item.testValue=[NSNumber numberWithDouble:score];
                item.summary=summary;
                item.sync=[NSNumber numberWithInt:1];
                item.itemId=[NSNumber numberWithInt:[TestItemID getHealthScore]];
            }
            ItemDataSyncStatus* dataStatus=[ItemDataSyncStatus MR_findFirstByAttribute:@"userId" withValue:[NSNumber numberWithInt:userId] inContext:[NSManagedObjectContext MR_contextForCurrentThread]];
            if(dataStatus==nil)
            {
                dataStatus=[ItemDataSyncStatus MR_createEntity];
                dataStatus.userId=[NSNumber numberWithInt:userId];
            }
            dataStatus.compflag=[NSNumber numberWithInt:1];
            [[NSManagedObjectContext MR_contextForCurrentThread] MR_saveToPersistentStoreAndWait];
            downloadExists=0;
        });
    }
}

-(void)serviceFailed:(NSString*) message pMethod:(NSString*)method
{
    if([method isEqualToString:@"GetUserCompInfoJson"])
    {
        NSLog(@"数据下载失败:%@",method);
        downloadExists=0;
    }
}

@end
