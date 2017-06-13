//
//  AppDelegate.h
//  TFHealth
//
//  Created by nico on 14-5-12.
//  Copyright (c) 2014年 studio37. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "User_Item_Info.h"
#import "User.h"
#import "Services/ServiceCallbackDelegate.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate,ServiceObjectDelegate>
{
    User *user;
    int userId;
    int deviceType;
}
@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) User *user;
@property (assign,nonatomic) int userId;
@property (assign,nonatomic) int deviceType;//设备类型：0-手环用户，1-秤用户，2-两者都有

-(void)goMainView:(UIViewController*)sender;
-(void)initHealItem;
-(void)setRootWindow:(UIViewController*)sender;
-(void)updateUMSocial:(NSString*)urlParam;
-(void) applicationNNotification;

@end
