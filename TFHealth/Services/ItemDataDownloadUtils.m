//
//  DataDownloadUtils.m
//  TFHealth
//
//  Created by nico on 14-9-24.
//  Copyright (c) 2014年 studio37. All rights reserved.
//

#import "ItemDataDownloadUtils.h"
#import "ServiceCallbackDelegate.h"
#import "AppCloundService.h"
#import "AppDelegate.h"
#import "User_Item_Info.h"
#import "ItemDataSyncStatus.h"
#import "HealthStatusViewController.h"

@interface ItemDataDownloadUtils()<ServiceObjectDelegate>
{
    AppCloundService* service;
    int userId;
}

-(void)serviceSuccessed:(NSDictionary*)keyValues pMethod:(NSString*)method;
-(void)serviceFailed:(NSString*) message pMethod:(NSString*)method;

@end

static ItemDataDownloadUtils* downloadInstance;
static int downloadExists=0;

@implementation ItemDataDownloadUtils

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
    if(dataStatus==nil || dataStatus.itemflag.intValue!=1)
    {
        downloadInstance=self;
        userId=user.userId.intValue;
        downloadExists=1;
        service =[[AppCloundService alloc] initWidthDelegate:self];
        [service getUserItems:user.userId.intValue];
    }
}

-(void)serviceSuccessed:(NSDictionary*)keyValues pMethod:(NSString*)method
{
    if([method isEqualToString:@"GetUserItemsJson"])
    {
        NSString* queueName=@"TFHealth_DownloadData_UserItem_Queue";
        const char* qc=[queueName UTF8String];
        dispatch_queue_t q = dispatch_queue_create(qc, nil);
        dispatch_async(q, ^(void){
            int uid=-1;
            for (NSDictionary *dict in keyValues) {
                uid = [dict[@"UserID"] intValue];
                //int rid=[dict[@"ID"] intValue];
                int cid=0;
                
                if(dict[@"CID"]!=nil && ![dict[@"CID"] isKindOfClass:[NSNull class]])
                {
                    cid = [dict[@"CID"] intValue];
                }
                int itemId=[dict[@"ItemID"] intValue];

                //NSString* remark = dict[@"Remarks"];
                NSString* summary = (NSString* )dict[@"Summary"];
                //NSString* sync = [@"SynchronizedStatus"] ;
                NSString* macModel=(NSString*)dict[@"MacModel"];
                if ([dict[@"ItemID"] intValue] == 1 && [dict[@"TestValue"] floatValue] == 52.5 ) {
                    NSLog(@"1111");
                }
                NSString* strDate = (NSString*)dict[@"TestDate"];
                double tick= [[strDate substringWithRange:NSMakeRange(6, 13)] doubleValue]/1000;
                NSDate* testDate = [NSDate dateWithTimeIntervalSince1970:tick];
                double score = [dict[@"TestValue"] doubleValue];
                
                User_Item_Info* item =[User_Item_Info MR_createEntity];
                
                item.cid=[NSNumber numberWithInt: cid];
                item.userId=[NSNumber numberWithInt:uid];
                item.testDate=testDate;
                item.testValue=[NSNumber numberWithDouble:score];
                item.macModel=macModel;
                item.summary=summary;
                item.sync=[NSNumber numberWithInt:1];
                item.itemId=[NSNumber numberWithInt:itemId];

            }
            ItemDataSyncStatus* dataStatus=[ItemDataSyncStatus MR_findFirstByAttribute:@"userId" withValue:[NSNumber numberWithInt:userId] inContext:[NSManagedObjectContext MR_contextForCurrentThread]];
            if(dataStatus==nil)
            {
                dataStatus=[ItemDataSyncStatus MR_createEntity];
                dataStatus.userId=[NSNumber numberWithInt:userId];
            }
            dataStatus.itemflag=[NSNumber numberWithInt:1];
            [[NSManagedObjectContext MR_contextForCurrentThread] MR_saveToPersistentStoreAndWait];
            downloadExists=0;
            
            //发送通知更新主界面
            AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
            [[NSNotificationCenter defaultCenter]postNotificationName:@"refreshMainUI" object:appDelegate.user];
        });
        
        
        
    }
}

-(void)serviceFailed:(NSString*) message pMethod:(NSString*)method
{
    if([method isEqualToString:@"GetUserItemsJson"])
    {
        NSLog(@"数据下载失败:%@",method);
        downloadExists=0;
    }
}


@end
