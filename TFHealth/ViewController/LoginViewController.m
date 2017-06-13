//
//  LoginViewController.m
//  TFHealth
//
//  Created by hzth hzth－mac2 on 5/28/14.
//  Copyright (c) 2014 studio37. All rights reserved.
//

#import "LoginViewController.h"
#import "VPImageCropperViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <QuartzCore/QuartzCore.h>
#import "CXAlertView.h"
#import "RegisterViewController.h"
#import "FindPassowrdViewController.h"
#import "AppCloundService.h"
#import "User.h"
#import "AppDelegate.h"
#import "UIViewController+MMDrawerController.h"
#import "HealthStatusViewController.h"
#import "CXAlertView.h"
#import "UserLog.h"
#import "UserDevices.h"
#import "HandRingViewController.h"
#import "NTSlidingViewController.h"
#import "WriteInformationViewController.h"
#import "MBProgressHUD.h"
#import "DefaultInitViewController.h"

@interface LoginViewController ()
{
    MBProgressHUD *loading;
}

@property (weak, nonatomic) IBOutlet UIImageView *usericoView;

@end

@implementation LoginViewController

- (IBAction)textFieldDoneEditing:(id)sender {
    [sender resignFirstResponder];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.username resignFirstResponder];
    [self.password resignFirstResponder];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}



- (void)viewDidLoad
{
//    [super viewDidLoad];
    
    [self initLoginUser];
}

-(void)setPropertiesOfHeadView:(UIImage*)headImage
{
    self.usericoView.layer.cornerRadius = self.usericoView.frame.size.width/2;
    self.usericoView.layer.borderWidth = 5;
    [self.usericoView setContentMode:UIViewContentModeScaleAspectFill];
    [self.usericoView setClipsToBounds:YES];
    self.usericoView.layer.shadowColor = UIColorFromRGB(0x6d91e2).CGColor;
    self.usericoView.layer.shadowOffset = CGSizeMake(4, 4);
    self.usericoView.layer.shadowOpacity = 0.5;
    self.usericoView.layer.shadowRadius = 2.0;
    self.usericoView.layer.masksToBounds = YES;
    self.usericoView.layer.borderColor = UIColorFromRGB(0x6d91e2).CGColor;
    self.usericoView.layer.contents = (id)[headImage CGImage];
}

-(void)initLoginUser
{
    UserLog *user = [UserLog MR_findFirstOrderedByAttribute:@"lastLoginTime" ascending:NO];
    NSLog(@"username:%@,password:%@",user.username,user.password);
    if (user!=nil) {
        _username.text=user.username;
        _password.text=user.password;
        
        
        User *u = [User MR_findFirstByAttribute:@"userName" withValue:_username.text inContext:[NSManagedObjectContext MR_defaultContext]];
        if (u!=nil) {
            if (u.userIco!=nil&& u.userIco!=NULL) {
                UIImage *image = [UIImage imageWithData:u.userIco];
                [self setPropertiesOfHeadView:image];
            }
            else
            {
                [self setPropertiesOfHeadView:[UIImage imageNamed:@"11_body9"]];
            }
        }
        if (u.loginType.boolValue == YES) {
            [self login:nil];
        }
    }
}

-(void)saveUserLog
{
    UserLog *user = [UserLog MR_createEntity];
    user.lastLoginTime=[NSDate date];
    user.username=_username.text;
    user.password=_password.text;
    [[NSManagedObjectContext MR_defaultContext] MR_save];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (IBAction)login:(id)sender {
    
    
    if (![self isValidateEmail:_username.text] && ![self isValidateMobile:_username.text]) {
        [self showSystemAlert:CustomLocalizedString(@"NameFormatNotCorrect", nil)];
        return;
    }
    if (!(_password.text.length>=6&&_password.text.length<=12)) {
        [self showSystemAlert:CustomLocalizedString(@"PwdLengthNotCorrect", <#comment#>)];
        return;
    }
    
    //加载
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
        loading = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        loading.dimBackground = YES;
        loading.animationType = 2;
//    });
//    loading.hidden = NO;

    AppCloundService* s= [[AppCloundService alloc] initWidthDelegate:self];
    [s UserLogin:_username.text userPassword:_password.text];
}

-(void)serviceSuccessed:(NSDictionary*)keyValues pMethod:(NSString*)method
{
    //隐藏加载
        dispatch_async(dispatch_get_main_queue(), ^{
    
            [loading hide:YES];
    
        });
//    NSLog(@"keyValues:%@",keyValues);
    if ([method isEqualToString:@"LoginJson"]) {
        if ([[keyValues allKeys] containsObject:@"res" ])
        {
            NSString *res = [keyValues objectForKey:@"res"];
            if ([res isEqualToString:@"true"]) {
                [self saveUserLog];
                NSString *uname=_username.text;
                User *user = [User MR_findFirstByAttribute:@"userName" withValue:uname  inContext:[NSManagedObjectContext MR_contextForCurrentThread]];
                user.loginType = [NSNumber numberWithBool:YES];//进入登录
                [[NSManagedObjectContext MR_defaultContext] MR_save];
                if (user!=nil) {
                    AppDelegate *appdelegate =(AppDelegate*) [[UIApplication sharedApplication] delegate];
                    appdelegate.user = user;
                    appdelegate.userId=user.userId.intValue;
                    
                    //更新用户基础数据
                    AppCloundService* s= [[AppCloundService alloc] initWidthDelegate:self];
                    [s GetUserInfo:user.userId.intValue];
                    
                    //通过用户类型判断进入主界面还是选择用户类型界面
                    UserDevices *device=[UserDevices MR_findFirstWithPredicate:[NSPredicate predicateWithFormat:@"userName==%@",user.userName]  inContext:[NSManagedObjectContext MR_defaultContext]];
                    if (device!=nil) {
                        //有用户类型
                        [self gotoView];
                    }
                    else
                    {
                        //无用户类型
                        [self goToUserDeviceView];
                    }
                    
                }
                else
                {
                    // TODO 应同步数据库
                    AppCloundService* s= [[AppCloundService alloc] initWidthDelegate:self];
                    [s SyncUser:_username.text userPassword:_password.text];
                }
                
            }
            else
            {
                [self showSystemAlert:CustomLocalizedString(@"LoginFailed", nil)];
            }
        }
    }
    else if ([method isEqualToString:@"GetUserJson"])
    {
        if (keyValues.count > 0) {
            
            /*
             根据nickname判断是否显示完善信息界面
             
             */
            NSString *nickName = keyValues[@"NickName"];
            if ([nickName isKindOfClass:[NSNull class]] || nickName == nil ||[nickName isEqualToString:@""] ) {
                //服务器无该用户，完善信息
                WriteInformationViewController *regview=[[self storyboard]instantiateViewControllerWithIdentifier:@"WriteInformationViewController"];
                UINavigationController *nav=[[UINavigationController alloc] initWithRootViewController:regview];
                //        NSLog(@"obj=%@",[keyValues objectForKey:@"res"]);
                [regview setUserId:[[keyValues objectForKey:@"UserID"] integerValue]];
                NSString *uname =_username.text;
                NSString *pword=_password.text;
                [regview setUsername:uname];
                [regview setPassword:pword];
                [self presentViewController:nav animated:YES completion:nil];
            } else {
                //服务器有该用户，下载用户信息
                [self syncUser:keyValues];
            }
            
        } else {
             //服务器无该用户，完善信息
//            WriteInformationViewController *regview=[[self storyboard]instantiateViewControllerWithIdentifier:@"WriteInformationViewController"];
//            UINavigationController *nav=[[UINavigationController alloc] initWithRootViewController:regview];
//            //        NSLog(@"obj=%@",[keyValues objectForKey:@"res"]);
//            //        [regview setUserId:[[keyValues objectForKey:@"res"] integerValue]];
//            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//            [regview setUserId:[[userDefaults objectForKey:@"userid"] integerValue]];
//            [regview setUserId:appdelegate.user.userId];
//            NSString *uname =_username.text;
//            NSString *pword=_password.text;
//            [regview setUsername:uname];
//            [regview setPassword:pword];
//            [self presentViewController:nav animated:YES completion:nil];
        }
        
    }
    else if ([method isEqualToString:@"GetUserInfoJson"])
    {
        if (keyValues.count > 0) {
            AppDelegate *appdelegate =(AppDelegate*) [[UIApplication sharedApplication] delegate];
            
            User *user=appdelegate.user;
            
            user.userName=[keyValues objectForKey:@"UserName"];
            user.password=[keyValues objectForKey:@"Password"];
            user.userId=[keyValues objectForKey:@"UserID"];
            NSString *showText = [[keyValues objectForKey:@"NickName"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            user.nickName = showText;
            user.sex = [NSNumber numberWithInt:[[keyValues objectForKey:@"Sex"] intValue]];
            user.height=[keyValues objectForKey:@"UserHeight"];
            user.birthday=[keyValues objectForKey:@"Age"];
            NSString *strImage = [keyValues objectForKey:@"UserIco"];
            if (strImage != nil && ![strImage  isEqual: @""]) {
                NSString *strUrl = [NSString stringWithFormat:@"%@%@",UserIcon_UrlPre,strImage];
                NSData *dataImage = [NSData dataWithContentsOfURL:[NSURL URLWithString:strUrl]];
                user.userIco = dataImage;
            }else{
                
            }
            
            [[NSManagedObjectContext MR_defaultContext] MR_save];
            
        }
    }
    else if ([method isEqualToString:@"GetUserDevicesJson"])
    {
        if (keyValues.count > 0) {
            User *user=[User MR_findFirstWithPredicate:[NSPredicate predicateWithFormat:@"userId==%d",[keyValues[@"UserID"] intValue]]  inContext:[NSManagedObjectContext MR_defaultContext]];
            
            UserDevices *device = [UserDevices MR_createEntity];
            device.deviceType = [NSNumber numberWithInt:[keyValues[@"UserType"] intValue]];
            if (user != nil) {
                device.userName = user.userName;
            }
            [self gotoView];
            
        } else {
            //没有类型，创建类型
            [self goToUserDeviceView];
        }
        
        
    }
}

//获取用户类型
-(void)downloadUserDevices:(int)userId{
    AppCloundService * userDevicesArrayRequest = [[AppCloundService alloc]initWidthDelegate:self];
    [userDevicesArrayRequest getUserDevices:userId];
    
}

-(void)gotoView
{
    AppDelegate *appdelegate =(AppDelegate*) [[UIApplication sharedApplication] delegate];
    [appdelegate applicationNNotification];//取消本地通知
    UserDevices *device = [UserDevices MR_findFirstByAttribute:@"userName" withValue:_username.text];
    if (device!=nil) {
        appdelegate.deviceType=device.deviceType.intValue;
        if (device.deviceType.intValue==0) {
            device.state=[NSNumber numberWithInt:1];
            [[NSManagedObjectContext MR_contextForCurrentThread] MR_save];
        }
    }
    else
    {
        appdelegate.deviceType=2;
    }
    UIViewController * hsvc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateInitialViewController];
    [self presentViewController:hsvc animated:YES completion:nil];
}

-(void)goToUserDeviceView{
    DefaultInitViewController *regview=[[self storyboard]instantiateViewControllerWithIdentifier:@"DefaultInitViewController"];
    UINavigationController *nav=[[UINavigationController alloc] initWithRootViewController:regview];
    //        NSLog(@"obj=%@",[keyValues objectForKey:@"res"]);
    //        [regview setUserId:[[keyValues objectForKey:@"res"] integerValue]];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [regview setUserId:[[userDefaults objectForKey:@"userid"] integerValue]];
    NSString *uname =_username.text;
    NSString *pword=_password.text;
    [regview setUsername:uname];
    [self presentViewController:nav animated:YES completion:nil];
}

-(void)syncUser:(NSDictionary*) keyValues
{
    User *user=[User MR_createEntity];
    user.userName=[keyValues objectForKey:@"UserName"];
    user.password=[keyValues objectForKey:@"Password"];
    user.userId=[keyValues objectForKey:@"UserID"];
    NSString *showText = [[keyValues objectForKey:@"NickName"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    user.nickName = showText;
    user.sex = [NSNumber numberWithInt:[[keyValues objectForKey:@"Sex"] intValue]];
    user.height=[keyValues objectForKey:@"UserHeight"];
    user.birthday=[keyValues objectForKey:@"Age"];
    NSString *strImage = [keyValues objectForKey:@"UserIco"];
    if (strImage != nil && ![strImage  isEqual: @""]) {
        NSString *strUrl = [NSString stringWithFormat:@"%@%@",UserIcon_UrlPre,strImage];
        NSData *dataImage = [NSData dataWithContentsOfURL:[NSURL URLWithString:strUrl]];
        user.userIco = dataImage;
    }else{
        
//        user.userIco = UIImagePNGRepresentation([UIImage imageNamed:@"userico"]);
    }
    [[NSManagedObjectContext MR_defaultContext] MR_save];
    
    AppDelegate *appdelegate =(AppDelegate*) [[UIApplication sharedApplication] delegate];
    appdelegate.user = user;
    appdelegate.userId=user.userId.intValue;
    [self downloadUserDevices:user.userId.intValue];
    
}

-(void)serviceFailed:(NSString*) message pMethod:(NSString*)method
{
    //隐藏菊花
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [loading hide:YES];
        
    });
    [self showSystemAlert:CustomLocalizedString(@"connectNetworkFails", nil)];
}

- (IBAction)regAction:(id)sender {
    RegisterViewController *regview=[[self storyboard]instantiateViewControllerWithIdentifier:@"RegisterViewController"];
    UINavigationController *nav=[[UINavigationController alloc] initWithRootViewController:regview];
    [self presentViewController:nav animated:YES completion:nil];
    
}

- (IBAction)forgetAction:(id)sender {
    FindPassowrdViewController *regview=[[self storyboard]instantiateViewControllerWithIdentifier:@"FindPassowrdViewController"];
    UINavigationController *nav=[[UINavigationController alloc] initWithRootViewController:regview];
    [self presentViewController:nav animated:YES completion:nil];
}

- (IBAction)showSystemAlert:(id)sender
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:CustomLocalizedString(@"tip", nil) message:sender delegate:nil cancelButtonTitle:CustomLocalizedString(@"OK", nil) otherButtonTitles: nil];
    
    [alertView show];
}

-(BOOL)isValidateEmail:(NSString *)email {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}(-[0-9]{4}){0,1}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}


-(BOOL)isValidateMobile:(NSString *)mobile {
    NSString *mobileRegex = @"1\\d{10}(-[0-9]{4}){0,1}";
    NSPredicate *mobileTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", mobileRegex];
    return [mobileTest evaluateWithObject:mobile];
}

@end