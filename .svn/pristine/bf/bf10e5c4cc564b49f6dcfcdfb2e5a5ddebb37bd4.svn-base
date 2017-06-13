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
    
    //加载菊花
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        loading = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//        loading.dimBackground = YES;
//        loading.animationType = 2;
//    });
    
    if (![self isValidateEmail:_username.text] && ![self isValidateMobile:_username.text]) {
        [self showSystemAlert:@"您的用户名称格式不正确，请使用正确的Email或手机号码作为用户名称。"];
        return;
    }
    if (!(_password.text.length>=6&&_password.text.length<=8)) {
        [self showSystemAlert:@"您的密码长度不正确，正确长度为6-8个字符。"];
        return;
    }
    AppCloundService* s= [[AppCloundService alloc] initWidthDelegate:self];
    [s UserLogin:_username.text userPassword:_password.text];
}

-(void)serviceSuccessed:(NSDictionary*)keyValues pMethod:(NSString*)method
{
    //隐藏菊花
//    dispatch_async(dispatch_get_main_queue(), ^{
//        
//        [loading hide:YES];
//        
//    });
    if(keyValues.count>0 )
    {
        if ([[keyValues allKeys] containsObject:@"res" ])
        {
            NSString *res = [keyValues objectForKey:@"res"];
            if ([res isEqualToString:@"true"]) {
                [self saveUserLog];
                NSString *uname=_username.text;
                User *user = [User MR_findFirstByAttribute:@"userName" withValue:uname  inContext:[NSManagedObjectContext MR_contextForCurrentThread]];
                if (user!=nil) {
                    AppDelegate *appdelegate =(AppDelegate*) [[UIApplication sharedApplication] delegate];
                    appdelegate.user = user;
                    appdelegate.userId=user.userId.intValue;
                    
                    [self gotoView];
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
                [self showSystemAlert:@"登录失败，请检查您的用户密码是否正确。"];
            }
        }
        else
        {
            [self syncUser:keyValues];
            
        }
    }
    else
    {
//        [self showSystemAlert:@"登录失败，请检查您的用户密码是否正确。"];
        
        WriteInformationViewController *regview=[[self storyboard]instantiateViewControllerWithIdentifier:@"WriteInformationViewController"];
        UINavigationController *nav=[[UINavigationController alloc] initWithRootViewController:regview];
//        NSLog(@"obj=%@",[keyValues objectForKey:@"res"]);
//        [regview setUserId:[[keyValues objectForKey:@"res"] integerValue]];
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [regview setUserId:[[userDefaults objectForKey:@"userid"] integerValue]];
        NSString *uname =_username.text;
        NSString *pword=_password.text;
        [regview setUsername:uname];
        [regview setPassword:pword];
        [self presentViewController:nav animated:YES completion:nil];
    }
}

-(void)gotoView
{
    AppDelegate *appdelegate =(AppDelegate*) [[UIApplication sharedApplication] delegate];
    [appdelegate applicationNNotification];
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

-(void)syncUser:(NSDictionary*) keyValues
{
    User *user=[User MR_createEntity];
    user.userName=[keyValues objectForKey:@"UserName"];
    user.password=[keyValues objectForKey:@"Password"];
    user.userId=[keyValues objectForKey:@"UserID"];
    user.nickName = [keyValues objectForKey:@"NickName"];
    user.sex = [NSNumber numberWithInt:[[keyValues objectForKey:@"Sex"] intValue]];
    user.height=[keyValues objectForKey:@"UserHeight"];;
    user.birthday=[keyValues objectForKey:@"Age"];
    [[NSManagedObjectContext MR_defaultContext] MR_save];
    
    AppDelegate *appdelegate =(AppDelegate*) [[UIApplication sharedApplication] delegate];
    appdelegate.user = user;
    appdelegate.userId=user.userId.intValue;
    [self gotoView];
}

-(void)serviceFailed:(NSString*) message pMethod:(NSString*)method
{
    
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
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:sender delegate:nil cancelButtonTitle:@"好" otherButtonTitles: nil];
    
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
