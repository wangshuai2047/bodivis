//
//  UserDevicesSync.m
//  TFHealth
//
//  Created by nico on 14-12-2.
//  Copyright (c) 2014年 studio37. All rights reserved.
//

#import "UserDevicesSync.h"
#import "AppCloundService.h"
#import "UserDevices.h"

@implementation UserDevicesSync

static int uddownloadExists=0;
static DataSyncBase* uddownloadInstance;

-(void)setInstance
{
    uddownloadInstance = self;
}

-(void)setDownloadFlag:(int)flag
{
    uddownloadExists=flag;
}

-(int)getDownloadFlag
{
    return uddownloadExists;
}

-(BOOL)isSingleResult
{
    return true;
}

-(BOOL)isExist:(int)uid uname:(NSString*)uname
{
    UserDevices* ud = [UserDevices MR_findFirstByAttribute:@"userName" withValue:uname inContext:[NSManagedObjectContext MR_defaultContext]];
    return ud!=nil;
}

-(void)queryData
{    
    [self.service getUserDevices:self.userId];
}

-(void)updateData:(NSDictionary*)keyValues
{
    //int did = [keyValues[@"ID"] intValue];
    //int uid = [keyValues[@"UserID"] intValue];
    NSString* type = (NSString*)keyValues[@"UserType"];
    
    UserDevices* ud=[UserDevices MR_createEntity];
    ud.userName = self.userName;
    ud.deviceType =[NSNumber numberWithInt:[type intValue]];
    
}

-(NSString*)getMethodName
{
    return @"GetUserDevicesJson";
}
@end
