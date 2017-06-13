//
//  DataSyncUtils.m
//  TFHealth
//
//  Created by nico on 14-9-11.
//  Copyright (c) 2014年 studio37. All rights reserved.
//

#import "DataSyncUtils.h"
#import "AppDelegate.h"
#import "User.h"
#import "TestItemID.h"
#import "AppCloundService.h"
#import "User_Item_Info.h"

@interface DataSyncUtils()<ServiceObjectDelegate>
{
    AppCloundService* service;
}

-(void)serviceSuccessed:(NSDictionary*)keyValues pMethod:(NSString*)method;
-(void)serviceFailed:(NSString*) message pMethod:(NSString*)method;

@end

static NSMutableArray* itemIds;
static int scoreID;
static int uploadExists=0;

@implementation DataSyncUtils

-(void)SyncData
{
    service =[[AppCloundService alloc] initWidthDelegate:self];
    AppDelegate *appdelegate =(AppDelegate*) [[UIApplication sharedApplication] delegate];
    User* user = appdelegate.user;
    if(user==nil)
    {
        NSLog(@"无上传用户");
        return;
    }
    if(itemIds==nil)
    {
        itemIds=[[NSMutableArray alloc] initWithCapacity:10];
        [itemIds addObject:[NSNumber numberWithInt:[TestItemID getBodyAge]]];
        [itemIds addObject:[NSNumber numberWithInt:[TestItemID getExFluid]]];
        [itemIds addObject:[NSNumber numberWithInt:[TestItemID getFat]]];
        [itemIds addObject:[NSNumber numberWithInt:[TestItemID getHealthScore]]];
        scoreID=[TestItemID getHealthScore];
        [itemIds addObject:[NSNumber numberWithInt:[TestItemID getInFluid]]];
        [itemIds addObject:[NSNumber numberWithInt:[TestItemID getMuscle]]];
        [itemIds addObject:[NSNumber numberWithInt:[TestItemID getPercentWater]]];
        [itemIds addObject:[NSNumber numberWithInt:[TestItemID getProtein]]];
        [itemIds addObject:[NSNumber numberWithInt:[TestItemID getSclerotin]]];
        [itemIds addObject:[NSNumber numberWithInt:[TestItemID getSMuscle]]];
        [itemIds addObject:[NSNumber numberWithInt:[TestItemID getSplanchnaPercentFat]]];
        [itemIds addObject:[NSNumber numberWithInt:[TestItemID getTotalWater]]];
        [itemIds addObject:[NSNumber numberWithInt:[TestItemID getWeight]]];
    }
    if(uploadExists==1)
    {
        return;
    }
    uploadExists=1;
    NSString* queueName=@"TFHealth_UploadData_Queue";
    const char* qc=[queueName UTF8String];
    dispatch_queue_t q = dispatch_queue_create(qc, nil);
    
    
//    dispatch_async(q, ^(void){
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{ 
        
        int count=1;
        BOOL running=true;
        while (running) {
            NSMutableArray *ScoreArray = [NSMutableArray array];//分数数组值
            NSMutableArray *AllItemsArray = [NSMutableArray array];//所有item数组
            BOOL changed=false;
            NSLog(@"********data sync running");
            for (NSNumber* itemId in itemIds) {
                if (itemId.intValue == 11) {
                    
                }
                NSArray* datas = [User_Item_Info MR_findAllWithPredicate:[NSPredicate predicateWithFormat:@"userId==%d AND itemId==%d AND sync!=1",user.userId.intValue,itemId.intValue]];
                for (User_Item_Info* info in datas) {
                    if(info.itemId.intValue==scoreID)
                    {
                        ScoreArray = [self addCompositeScoreWithUserId:user.userId.intValue score:info.testValue testDate:info.testDate];
//                        [service uploadCompositeScore:user.userId.intValue score:info.testValue testDate:info.testDate];
                    }
                    else
                    {
                        NSMutableArray *itemArray = [self addUserItemInfoWithUserId:user.userId.intValue cId:-1 itemId:itemId.intValue testDate:info.testDate testValue:info.testValue];
                        [AllItemsArray addObject:itemArray];
//                        [service uploadUserItemInfo:user.userId.intValue cId:-1 itemId:itemId.intValue testDate:info.testDate testValue:info.testValue];
                    }
                    [NSThread sleepForTimeInterval:3];
                    info.sync=[NSNumber numberWithInt:1];
                    
                }
            }
            
            
            //////////////////
            if (AllItemsArray.count>0 || ScoreArray.count > 0) {
                
                NSMutableDictionary *Mdict = [NSMutableDictionary dictionaryWithObjectsAndKeys:AllItemsArray,@"data",ScoreArray,@"score", nil];
                //字典转json
                NSData *jsonData = [NSJSONSerialization dataWithJSONObject:Mdict options:NSJSONWritingPrettyPrinted error:nil];
                NSString *jsonStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
                [service UploadUserTestDataByJson:jsonStr];
                if(!changed)
                {
                    changed=true;
                }

            }
            
            if(changed)
            {
                [[NSManagedObjectContext MR_contextForCurrentThread] MR_saveToPersistentStoreAndWait];
            }
            else
            {
                count=count+1;
            }
            if(count>2) //3次无数则退出，下次进入程序时在执行
            {
                running=false;
                NSLog(@"********data sync stop");
                uploadExists=0;
            }
            else
            {
                [NSThread sleepForTimeInterval:10];
            }
        }
    });
}

//用户item
-(NSMutableArray*)addUserItemInfoWithUserId:(int)userId cId:(int)cId itemId:(int)itemId testDate:(NSDate*)date testValue:(NSNumber*)testValue
{
    NSDateFormatter* formater=[[NSDateFormatter alloc] init];
    [formater setDateFormat: @"yyyy-MM-dd HH:mm:ss"];
    NSMutableArray* wsParas=[[NSMutableArray alloc] init];
    [wsParas addObject:@"appUserId"];
    [wsParas addObject:[NSString stringWithFormat:@"%d",userId]];
    [wsParas addObject:@"CID"];
    [wsParas addObject:[NSString stringWithFormat:@"%d",cId]];
    [wsParas addObject:@"itemId"];
    [wsParas addObject:[NSString stringWithFormat:@"%d",itemId]];
    [wsParas addObject:@"itemValue"];
    [wsParas addObject:[NSString stringWithFormat:@"%@",testValue]];
    [wsParas addObject:@"summary"];
    [wsParas addObject:@"none"];
    [wsParas addObject:@"testDate"];
    [wsParas addObject:[NSString stringWithFormat:@"%@",[formater stringFromDate:date]]];
    [wsParas addObject:@"macModel"];
    [wsParas addObject:@"4"];
    return wsParas;
    
}

//健康得分
-(NSMutableArray*)addCompositeScoreWithUserId:(int)userId score:(NSNumber*)score testDate:(NSDate*)date
{
    NSDateFormatter* formater=[[NSDateFormatter alloc] init];
    [formater setDateFormat: @"yyyy-MM-dd HH:mm:ss"];
    NSMutableArray* wsParas=[[NSMutableArray alloc] init];
    [wsParas addObject:@"appUserId"];
    [wsParas addObject:[NSString stringWithFormat:@"%d",userId]];
    [wsParas addObject:@"score"];
    [wsParas addObject:[NSString stringWithFormat:@"%@",score]];
    [wsParas addObject:@"summary"];
    [wsParas addObject:@"none"];
    [wsParas addObject:@"testDate"];
    [wsParas addObject:[NSString stringWithFormat:@"%@",[formater stringFromDate:date]]];
    [wsParas addObject:@"Remark"];
    [wsParas addObject:@"none"];
    [wsParas addObject:@"syncStatus"];
    [wsParas addObject:@"0"];
    return wsParas;
    
}

-(void)serviceSuccessed:(NSDictionary*)keyValues pMethod:(NSString*)method
{
    if ([method isEqualToString:@"UploadUserTestDataByJson"]) {
        if(keyValues.count>0 && [[keyValues allKeys] containsObject:@"res" ])
        {
            NSInteger res = [[keyValues objectForKey:@"res"] integerValue];
            if (res>0) {
            }
        }
    }
}

-(void)serviceFailed:(NSString*) message pMethod:(NSString*)method
{
    NSLog(@"FailedMethod:%@",method);
}

@end
