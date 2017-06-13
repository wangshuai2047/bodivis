//
//  isShowAppVersion.m
//  TFHealth
//
//  Created by 王帅 on 2017/6/2.
//  Copyright © 2017年 studio37. All rights reserved.
//

#import "isShowAppVersion.h"
#import "AppDelegate.h"

@implementation isShowAppVersion

static int iSAppVdownloadExists=0;
static DataSyncBase* iSAppVdownloadInstance;

-(void)setInstance
{
    iSAppVdownloadInstance = self;
}

-(void)setDownloadFlag:(int)flag
{
    iSAppVdownloadExists = flag;
}


-(int)getDownloadFlag
{
    return iSAppVdownloadExists;
}

-(BOOL)isSingleResult
{
    return true;
}

-(BOOL)isExist:(int)uid uname:(NSString*)uname
{
    return false;
}

-(void)queryData
{
    [self.service isShowAppVersionDetectionAction];
}

-(void)updateData:(NSDictionary*)keyValues
{
    if ([keyValues[@"res"] intValue] == 1){//显示检测版本
        AppDelegate *appdelegate =(AppDelegate*) [[UIApplication sharedApplication] delegate];
        appdelegate.isShowVersion = 1;
        AppCloundService *service = [[AppCloundService alloc] initWidthDelegate:self];
        [service appVersionDetectionWithAppType];
    }else{//不显示检测版本
        AppDelegate *appdelegate =(AppDelegate*) [[UIApplication sharedApplication] delegate];
        appdelegate.isShowVersion = 0;
    }
}

-(NSString*)getMethodName
{
    return @"isOpenCheckVersionJson";
}

-(void)serviceSuccessed:(NSDictionary*)keyValues pMethod:(NSString*)method
{
    if ([method isEqualToString:@"isOpenCheckVersionJson"]) {
        if ([keyValues[@"res"] intValue] == 1){//显示检测版本
            AppDelegate *appdelegate =(AppDelegate*) [[UIApplication sharedApplication] delegate];
            appdelegate.isShowVersion = 1;
            AppCloundService *service = [[AppCloundService alloc] initWidthDelegate:self];
            [service appVersionDetectionWithAppType];
        }else{//不显示检测版本
            AppDelegate *appdelegate =(AppDelegate*) [[UIApplication sharedApplication] delegate];
            appdelegate.isShowVersion = 0;
        }
    }
    else if ([method isEqualToString:@"GetAppVersionJson"])
    {
        if (keyValues[@"Version_Num"] != nil) {
            NSString *appStoreVersion = keyValues[@"Version_Num"];
            NSString *localVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
            
            if(!([[NSUserDefaults standardUserDefaults] boolForKey:appStoreVersion] == NO))
            {
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:appStoreVersion];
                if (![appStoreVersion isEqualToString:localVersion]) {
                    //发送弹出alert通知
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"showAlertView" object:keyValues userInfo:nil];
                    
                }
                
            }
        }
    }
}

-(void)serviceFailed:(NSString*) message pMethod:(NSString*)method
{
    
}


@end
