//
//  SyncCoordinater.m
//  TFHealth
//
//  Created by nico on 14-12-31.
//  Copyright (c) 2014年 studio37. All rights reserved.
//

#import "SyncCoordinater.h"
#import "ItemDataDownloadUtils.h"
#import "CompDataDownloadUtils.h"
#import "DataSyncUtils.h"
#import "SportItemsSync.h"
#import "FoodDctionarySync.h"
#import "UserCoreValueSync.h"
#import "PersonalSetSync.h"
#import "MemberSync.h"
#import "UserDevicesSync.h"
#import "DalidfoodSync.h"
#import "FoodClassSync.h"
#import "AppDelegate.h"
#import "isShowAppVersion.h"

@implementation SyncCoordinater

-(void)start
{
    [[[DataSyncUtils alloc] init] SyncData];
    [[[ItemDataDownloadUtils alloc] init] downloadData];
    [[[CompDataDownloadUtils alloc] init] downloadData];
    
    [[[SportItemsSync alloc]init] downloadData];
    [[[FoodDctionarySync alloc]init] downloadData];
    [[[UserCoreValueSync alloc]init] downloadData];
    [[[PersonalSetSync alloc]init] downloadData];
    [[[MemberSync alloc]init] downloadData];
    [[[UserDevicesSync alloc]init] downloadData];
    [[[DalidfoodSync alloc]init] downloadData];
    [[[FoodClassSync alloc]init] downloadData];
    
    AppDelegate *appdelegate = [UIApplication sharedApplication].delegate;
    if (!appdelegate.isFirstLaunch) {
        [[[isShowAppVersion alloc]init]downloadData];
//        AppCloundService *service = [[AppCloundService alloc] initWidthDelegate:self];
//        [service isShowAppVersionDetectionAction];
    }
}

@end
