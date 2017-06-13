//
//  DataSyncBase.m
//  TFHealth
//
//  Created by nico on 14-11-17.
//  Copyright (c) 2014年 studio37. All rights reserved.
//

#import "DataSyncBase.h"
#import "ServiceCallbackDelegate.h"
#import "AppDelegate.h"
#import "AppCloundService.h"

@interface DataSyncBase ()
{
   
}

@end

@implementation DataSyncBase

@synthesize userId;
@synthesize userName;
@synthesize service;

-(void)downloadData
{
    
    //downloadInstance=self;
    AppDelegate *appdelegate =(AppDelegate*) [[UIApplication sharedApplication] delegate];
    User* user = appdelegate.user;
    if(user==nil)
    {
        NSLog(@"无下载用户");
        return;
    }
    if([self getDownloadFlag]==1)
    {
        return;
    }
    if([self isExist:user.userId.intValue uname:user.userName]==FALSE)
    {
        [self setInstance];
        self.userId=user.userId.intValue;
        self.userName = user.userName;
        AppCloundService* s =[[AppCloundService alloc] initWidthDelegate:self];
        self.service = s;
        NSLog(@"DataSyncBase:%@",[self getMethodName]);
        [self setDownloadFlag:1];        
        [self queryData];
    }
}

-(void)serviceSuccessed:(NSDictionary*)keyValues pMethod:(NSString*)method;
{
    if(method==[self getMethodName])
    {
        NSLog(@"DataSyncBase serviceSuccessed:%@",[self getMethodName]);
        NSString* queueName=[NSString stringWithFormat:@"TFHealth_DownloadData_%@_Queue",[self getMethodName]];
        const char* qc=[queueName UTF8String];
        dispatch_queue_t q = dispatch_queue_create(qc, nil);
        dispatch_async(q, ^(void){
            if([self isSingleResult]==true)
            {
                [self updateData:keyValues];
            }
            else
            {
                if ([[self getMethodName]isEqualToString:@"GetUserPersonalSetInfoJson"]) {
                    NSLog(@"12345");
                }
                for (NSDictionary *dict in keyValues) {
                    [self updateData:dict];
                }
            }
            [[NSManagedObjectContext MR_contextForCurrentThread] MR_saveToPersistentStoreAndWait];
            [self setDownloadFlag:0];
        });
    }
}

-(void)serviceFailed:(NSString*) message pMethod:(NSString*)method
{
    NSLog(@"DataSyncBase serviceFailed:%@",[self getMethodName]);
    if(method==[self getMethodName])
    {
        [self setDownloadFlag:0];
    }
}

-(NSDate*)convertDate:(NSString*)value
{
    NSString* strDate = value;
    if(strDate==nil || (NSNull*)value==[NSNull null])
    {
        return nil;
    }
    double tick= [[strDate substringWithRange:NSMakeRange(6, 13)] doubleValue]/1000;
    return [NSDate dateWithTimeIntervalSince1970:tick];
}

-(NSNumber*)getIntValue:(id)value
{
    if(value==nil || (NSNull*)value==[NSNull null])
    {
        return nil;
    }
    return [NSNumber numberWithInt:[value intValue]];
}

-(NSString*)getStringValue:(id)value
{
    if(value==nil || (NSNull*)value==[NSNull null])
    {
        return nil;
    }
    return (NSString*)value;
}

-(NSNumber*)getDoubleValue:(id)value
{
    if(value==nil || (NSNull*)value==[NSNull null])
    {
        return nil;
    }
    return [NSNumber numberWithDouble:[value doubleValue]];
}

@end
