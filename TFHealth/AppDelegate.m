//
//  AppDelegate.m
//  TFHealth
//
//  Created by nico on 14-5-12.
//  Copyright (c) 2014年 studio37. All rights reserved.
//

#import "AppDelegate.h"
#import "LeftTableViewController.h"
#import "RightTableViewController.h"
#import "MMDrawerController.h"
#import "MainViewController.h"
#import "LoginViewController.h"
#import "services/AppCloundService.h"

#import "DataModel/Health_Items.h"
#import "DataModel/User.h"
#import "UMSocial.h"
#import "UMSocialWechatHandler.h"
#import "UMSocialQQHandler.h"
#import "PersonalSet.h"
#import "HealthStatusViewController.h"
#import "NSBundle+Language.h"
#import <Bugly/Bugly.h>
#import "AppDelegate+XHLaunchAd.h"
#import "XHLaunchAd.h"
#import "Network.h"
#import "LaunchAdModel.h"
#import "LaunchAnimationController.h"
#import "AppCloundService.h"
#import "FoodDictionary.h"
#import "Members.h"



#define kscreenWidth [UIScreen mainScreen].bounds.size.width
#define kscreenHeight [UIScreen mainScreen].bounds.size.height
#define kUserDefaults [NSUserDefaults standardUserDefaults]
static NSString *const adImageName = @"adImageName";
static NSString *const adUrl = @"adUrl";


@implementation AppDelegate

@synthesize user;
@synthesize userId;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
//    [NSThread sleepForTimeInterval:1.0];
    /**
     *  添加开屏广告
     */
    
    LaunchAnimationController *animationController = [[LaunchAnimationController alloc]init];
    self.window.rootViewController = animationController;
    [self.window makeKeyAndVisible];
    //修改所有状态栏
    [application setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    [application setStatusBarStyle:UIStatusBarStyleLightContent];
    
    [MagicalRecord setupCoreDataStackWithStoreNamed:@"Healthdb.sqlite"];
    
    
    [UMSocialData setAppKey:@"540f1e0ffd98c51d1b02bae8"];
    
    //bugly监控异常
    [Bugly startWithAppId:@"0827f8bdb6"];
    
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"Navigationbar.png"] forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                          [UIColor whiteColor], UITextAttributeTextColor,
                                                          [UIColor colorWithRed:0 green:0.7 blue:0.8 alpha:1], UITextAttributeTextShadowColor,
                                                          [NSValue valueWithUIOffset:UIOffsetMake(0, 0)], UITextAttributeTextShadowOffset,
                                                          [UIFont fontWithName:@"Arial-Bold" size:0.0], UITextAttributeFont,
                                                          nil]];
    if (IOS_VERSION>=7) {
        [[UINavigationBar appearance] setBarTintColor:[UIColor whiteColor]];
    }
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    user=nil;
    userId=0;
    deviceType=2;
    
    [self initHealItem];
    
    //判断是不是第一次启动应用
    if(![[NSUserDefaults standardUserDefaults] boolForKey:@"firstLaunch"])
    {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstLaunch"];
        NSLog(@"第一次启动");
        self.isFirstLaunch = YES;
        
    }
    else
    {
        NSLog(@"不是第一次启动");
        
        self.isFirstLaunch = NO;
        
    }
    
   
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:AppLanguage] && ![[[NSUserDefaults standardUserDefaults] objectForKey:AppLanguage] isEqualToString:@""]) {
        
        
        
        [NSBundle setLanguage:[[NSUserDefaults standardUserDefaults] objectForKey:AppLanguage]];
        //非首次进入应用
        NSString *appLanguage = (NSString*)[[NSUserDefaults standardUserDefaults]objectForKey:AppLanguage];
        if ([appLanguage isEqualToString:Chinese_Simplified]) {
            self.languageIndex = 0;
        }else if ([appLanguage isEqualToString:English]){
            self.languageIndex = 1;
        }else{
            self.languageIndex = 0;
        }
//        if ([appLanguage isEqualToString:Chinese_Simplified]) {
//            self.languageIndex = 0;
//        }else if ([appLanguage isEqualToString:Chinese_Traditional_TW]){
//            self.languageIndex = 1;
//        }else if ([appLanguage isEqualToString:Chinese_Traditional_HK]){
//            self.languageIndex = 2;
//        }else if ([appLanguage isEqualToString:English]){
//            self.languageIndex = 3;
//        }else{
//            self.languageIndex = 0;
//        }
    }else{//首次进入应用
        self.languageIndex = 0;
        [NSBundle setLanguage:Chinese_Simplified];
        
        // 然后将设置好的语言存储好，下次进来直接加载
        [[NSUserDefaults standardUserDefaults] setObject:Chinese_Simplified forKey:AppLanguage];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
//    [self loadSimilarAdsToLocalImage];
//    [self setupXHLaunchAd];
    
    
    return YES;
}


#pragma mark - 启动页和广告页中间有闪屏现象，加了一个类似广告页的本地图片，该图片和启动页是同一张
-(void)loadSimilarAdsToLocalImage{
    XHLaunchImageAdConfiguration *imageAdconfiguration = [XHLaunchImageAdConfiguration new];
    //广告停留时间
    imageAdconfiguration.duration = 1;
    //广告frame
    //    imageAdconfiguration.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.width/1242*1786);
    imageAdconfiguration.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    
    //广告图片URLString/或本地图片名(.jpg/.gif请带上后缀)
    imageAdconfiguration.imageNameOrURLString = @"kaipingzuihou.jpg";
    //缓存机制(仅对网络图片有效)
    imageAdconfiguration.imageOption = XHLaunchAdImageRefreshCached;
    //图片填充模式
    imageAdconfiguration.contentMode = UIViewContentModeScaleToFill;
    //广告点击打开链接
    //        imageAdconfiguration.openURLString = @"http://www.it7090.com";
    //广告显示完成动画
    imageAdconfiguration.showFinishAnimate =ShowFinishAnimateFadein;
    //跳过按钮类型
    imageAdconfiguration.skipButtonType = SkipTypeNone;
    //后台返回时,是否显示广告
    imageAdconfiguration.showEnterForeground = NO;
    //设置要添加的子视图(可选)
    //imageAdconfiguration.subViews = [self launchAdSubViews];
    //显示开屏广告
    [XHLaunchAd imageAdWithImageAdConfiguration:imageAdconfiguration delegate:self];
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification*)notification{
    NSLog(@"获得本地通知");
    //UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"iWeibo" message:notification.alertBody delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    //[alert show];
    // 图标上的数字减1
    application.applicationIconBadgeNumber -= 1;
}

-(void) applicationNNotification
{
    
    UIApplication *application = [UIApplication sharedApplication];
    NSArray *localNotifications = [[UIApplication sharedApplication] scheduledLocalNotifications];
    //取消指定的本地通知
    for (UILocalNotification *obj in localNotifications) {
        NSDictionary *dict = obj.userInfo;
        if (dict) {
            NSString *inKey = [dict objectForKey:@"bodivis"];
            if ([inKey isEqualToString:@"bodivis"]) {
                [application cancelLocalNotification:obj];
                NSLog(@"取消本地通知%@",inKey);
                //图标数字为0
                application.applicationIconBadgeNumber = 0;//由于didReceiveLocalNotification方法无法被调用临时改成这种写法
            }
        }
    }
    if ([UIApplication instancesRespondToSelector:@selector(registerUserNotificationSettings:)])
    {
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound categories:nil]];
    }
    int time = 8;
    int minute = 30;
    //NSDate
//    PersonalSet *p=[PersonalSet MR_findFirstByAttribute:@"userId" withValue:[NSNumber numberWithInt:user.userId.intValue] inContext:[NSManagedObjectContext MR_defaultContext]];
    //通过userid查找到的PersonalSet需要根据startDate进行降序排序，取最近的值
    PersonalSet *p=[PersonalSet MR_findFirstWithPredicate:[NSPredicate predicateWithFormat:@"userId==%d",user.userId.intValue] sortedBy:@"startDate" ascending:NO inContext:[NSManagedObjectContext MR_defaultContext]];
    if(p!=nil)
    {
        if (![p.remindTime isEqualToString:@""]) {
            NSString* remind = p.remindTime;
            NSMutableString* mStr = [NSMutableString stringWithString:remind];
            NSRange sRange =[mStr rangeOfString:@"："];
            if(sRange.location!=NSNotFound)
            {
                [mStr replaceCharactersInRange:sRange withString:@":"];
            }
            NSRange range = [mStr rangeOfString:@":"];
            if(range.length!=0)
            {
                NSString *a = [mStr substringToIndex:range.location];
                NSString *b = [mStr substringFromIndex:range.location +
                               range.length];
                time = a.intValue;
                minute=b.intValue;
            }            
        }
    }
    
    NSDate *dateToDay = [NSDate date];//将获得当前时间
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"HH:mm"];
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    [df setLocale:locale];
    NSString *strDate = [df stringFromDate:dateToDay];
    
    NSRange range1 = [strDate rangeOfString:@":"];
    if(range1.length==0)
    {
        return;
    }
    NSString *a1 = [strDate substringToIndex:range1.location];
    NSString *b1 = [strDate substringFromIndex:range1.location +
                   range1.length];
    int time1 = a1.intValue;
    int minute1=b1.intValue;
    
    int curTime =0;
    if (time1>0)  curTime+=time1*60*60;
    if (minute1>0) curTime+=minute1*60;
    
    int s = 0;
    if (time>0) s+=time*60*60;
    if (minute>0) s+=minute*60;
    
    int remindWait = 0;
    if(s>curTime)
    {
        remindWait = s-curTime;
    }
    else
    {
        remindWait = s-curTime + (24*60*60);
    }
    
    // 创建一个本地推送
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    //设置10秒之后
    NSDate *pushDate = [NSDate dateWithTimeIntervalSinceNow:remindWait];
    if (notification != nil) {
        // 设置推送时间
        notification.fireDate = pushDate;
        // 设置时区
        notification.timeZone = [NSTimeZone defaultTimeZone];
        // 设置重复间隔
        notification.repeatInterval = kCFCalendarUnitDay;
        // 推送声音
        notification.soundName = UILocalNotificationDefaultSoundName;
        // 推送内容
        notification.alertBody = CustomLocalizedString(@"AlertBody", nil);
        //显示在icon上的红色圈中的数子
        notification.applicationIconBadgeNumber = 1;
        //设置userinfo 方便在之后需要撤销的时候使用
        NSDictionary *info = [NSDictionary dictionaryWithObject:@"bodivis"forKey:@"bodivis"];
        notification.userInfo = info;
        //添加推送到UIApplication
        UIApplication *app = [UIApplication sharedApplication];
        [app scheduleLocalNotification:notification];
    }
}


- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    [MagicalRecord setupCoreDataStackWithStoreNamed:@"Healthdb.sqlite"];
}

-(void)initHealItem
{
    //Health_Items* hItem = Health_Items
    //    User* itemInfo = [User MR_createEntity];
    //    itemInfo.userId=[NSNumber numberWithInt:1];
    //    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
    NSError* err = nil;
    NSString* dataPath = [[NSBundle mainBundle] pathForResource:@"HEALTH_ITEMS" ofType:@"json"];
    NSArray* items = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:dataPath]
                                                     options:kNilOptions
                                                       error:&err];
    [items enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSString* itemID = [obj objectForKey:@"ZITEMID"];
        NSArray* hItems = [Health_Items MR_findByAttribute:@"itemId" withValue:itemID];
        if(hItems==nil || hItems.count==0)
        {
            Health_Items* newItem = [Health_Items MR_createEntity];
            newItem.itemId=[NSNumber numberWithInteger:[[obj objectForKey:@"ZITEMID"] integerValue]];
            newItem.itemName=[obj objectForKey:@"ZITEMNAME"];
            newItem.unit = [obj objectForKey:@"ZUNIT"];
            [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
        }
    }];
    
//    NSLog(@"Imported Health_Items: %@", items);
    
}

-(void)updateUMSocial:(NSString*)urlParam
{
//    [UMSocialWechatHandler setWXAppId:@"wx72bc5ab85da559a2" appSecret:@"e9041c77433a0029a2c733bf9778d3ff" url:[NSString stringWithFormat:@"http://i.bodivis.com.cn/share/share.aspx?%@",urlParam]];
//    [UMSocialQQHandler setQQWithAppId:@"100424468" appKey:@"c7394704798a158208a74ab60104f0ba" url:[NSString stringWithFormat:@"http://i.bodivis.com.cn/share/share.aspx?%@",urlParam]];
    
    NSString *strURl = [NSString stringWithFormat:@"http://i.bodivis.com.cn/share/share.aspx?%@",urlParam];
    NSString *new_url=[strURl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [UMSocialWechatHandler setWXAppId:@"wx72bc5ab85da559a2" appSecret:@"e9041c77433a0029a2c733bf9778d3ff" url:new_url];
    [UMSocialQQHandler setQQWithAppId:@"100424468" appKey:@"c7394704798a158208a74ab60104f0ba" url:new_url];

}

-(void)requestSuccessed:(NSString *)request
{
    
}
-(void)requestFailed:(NSString *)request
{
    NSLog(@"food record failure");
}
-(void)serviceSuccessed:(NSDictionary*)keyValues pMethod:(NSString*)method
{
//    if(keyValues.count>0 && [[keyValues allKeys] containsObject:@"UserID" ])
//    {
//        NSLog(@"UserID=%@",[keyValues objectForKey:@"UserID"]);
//    }
    
    
}

-(void)serviceFailed:(NSString*) message pMethod:(NSString*)method
{
    NSLog(@"失败:%@",method);
}

-(void)setRootWindow:(UIViewController*)sender
{
    [self.window setRootViewController:sender];
}

-(void)goMainView:(UIViewController*)sender
{
    //self.window.rootViewController
    MMDrawerController * drawerController = (MMDrawerController *)sender;
    if([drawerController isKindOfClass:[MMDrawerController class]])
    {
        [drawerController setMaximumRightDrawerWidth:276.0];
        [drawerController setMaximumLeftDrawerWidth:276];
        [drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeBezelPanningCenterView];
        [drawerController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
    }
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    
    //如果app在前台运行
    application.applicationIconBadgeNumber = 0;
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [MagicalRecord cleanUp];
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return  [UMSocialSnsService handleOpenURL:url];
}
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    return  [UMSocialSnsService handleOpenURL:url];
}





@end
