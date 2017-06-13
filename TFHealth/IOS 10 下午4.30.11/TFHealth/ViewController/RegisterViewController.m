//
//  RegisterViewController.m
//  TFHealth
//
//  Created by chenzq on 14-7-1.
//  Copyright (c) 2014年 studio37. All rights reserved.
//

#import "RegisterViewController.h"
#import "WriteInformationViewController.h"
#import "AppCloundService.h"
#import "CXAlertView.h"
#import "UserLog.h"
#import "UIColor+BFPaperColors.h"
#import "UserDevices.h"
#import "MBProgressHUD.h"

@interface RegisterViewController ()
{
    MBProgressHUD *loading;
}
- (IBAction)RegisterNext:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *username;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UITextField *confirmPassword;
- (IBAction)backupView:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *containerView;
/*
@property BFPaperCheckbox *paperCheckbox;
@property BFPaperCheckbox *paperCheckbox2;
@property UILabel *paperCheckboxLabel;
@property UILabel *paperCheckboxLabel2;
*/
@end

@implementation RegisterViewController

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
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.username setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    [self.password setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    [self.confirmPassword setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    /*
    self.paperCheckbox = [[BFPaperCheckbox alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    self.paperCheckbox.tag = 1001;
    self.paperCheckbox.delegate = self;
    [self.containerView addSubview:self.paperCheckbox];
    
    // Set up first checkbox label:
    self.paperCheckboxLabel = [[UILabel alloc] initWithFrame:CGRectMake(120, 0, 100, 31)];
    self.paperCheckboxLabel.text = @"手环用户";
    self.paperCheckboxLabel.font=[UIFont fontWithName:@"Helvetica" size:16];
    self.paperCheckboxLabel.textColor=[UIColor whiteColor];
    self.paperCheckboxLabel.backgroundColor = [UIColor clearColor];
    self.paperCheckboxLabel.center = CGPointMake(self.paperCheckbox.center.x + ((2 * self.paperCheckboxLabel.frame.size.width) / 3), self.paperCheckbox.center.y);
    [self.containerView addSubview:self.paperCheckboxLabel];
    
    
    // Set up second checkbox and customize it:
    self.paperCheckbox2 = [[BFPaperCheckbox alloc] initWithFrame:CGRectMake(200, 0, 50, 50)];
    self.paperCheckbox2.center = CGPointMake(self.paperCheckbox2.frame.origin.x, self.paperCheckbox.center.y);
    self.paperCheckbox2.tag = 1002;
    self.paperCheckbox2.delegate = self;
    self.paperCheckbox2.rippleFromTapLocation = NO;
    self.paperCheckbox2.tapCirclePositiveColor = [UIColor paperColorAmber]; // We could use [UIColor colorWithAlphaComponent] here to make a better tap-circle.
    self.paperCheckbox2.tapCircleNegativeColor = [UIColor paperColorRed];   // We could use [UIColor colorWithAlphaComponent] here to make a better tap-circle.
    self.paperCheckbox2.checkmarkColor = [UIColor paperColorLightBlue];
    [self.containerView addSubview:self.paperCheckbox2];
    
    // Set up second checkbox label:
    self.paperCheckboxLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(300, 0, 100, 31)];
    self.paperCheckboxLabel2.text = @"秤用户";
    self.paperCheckboxLabel2.font=[UIFont fontWithName:@"Helvetica" size:16];
    self.paperCheckboxLabel2.textColor=[UIColor whiteColor];
    self.paperCheckboxLabel2.backgroundColor = [UIColor clearColor];
    self.paperCheckboxLabel2.center = CGPointMake(self.paperCheckbox2.center.x + ((2 * self.paperCheckboxLabel2.frame.size.width) / 3), self.paperCheckbox2.center.y);
    [self.containerView addSubview:self.paperCheckboxLabel2];
     */
}

#pragma mark - BFPaperCheckbox Delegate
- (void)paperCheckboxChangedState:(BFPaperCheckbox *)checkbox
{
    /*
     if (checkbox.tag == 1001) {      // First box
     self.paperCheckboxLabel.text = self.paperCheckbox.isChecked ? @"BFPaperCheckbox [ON]" : @"BFPaperCheckbox [OFF]";
     }
     else if (checkbox.tag == 1002) { // Second box
     self.paperCheckboxLabel2.text = self.paperCheckbox2.isChecked ? @"Customized [ON]" : @"Customized [OFF]";
     }
     */
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

- (IBAction)RegisterNext:(id)sender {
    
    if (![self isValidateEmail:_username.text]&&![self isValidateMobile:_username.text]) {
        [self showSystemAlert:@"您的用户名称格式不正确，请使用正确的邮箱地址或手机号码作为用户名称。"];
        return;
    }
    
    NSLog(_password.text);
    NSLog(_confirmPassword.text);
    if (!(_password.text.length>=6&&_password.text.length<=8)) {
        [self showSystemAlert:@"您的密码长度不正确，正确长度为6-8个字符。"];
        return;
    }
    else if(![_password.text isEqualToString:_confirmPassword.text])
    {
        [self showSystemAlert:@"您的两次密码不统一，请重新输入。"];
        return;
    }
    /*
    if (self.paperCheckbox.isChecked==false&& self.paperCheckbox2.isChecked== false) {
        [self showSystemAlert:@"请至少选择一个您使用的设备类型。"];
        return;
    }
    */
    
    //加载菊花
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        loading = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//        loading.dimBackground = YES;
//        loading.animationType = 2;
//    });
    AppCloundService* s= [[AppCloundService alloc] initWidthDelegate:self];
    [s RegisterUser:_username.text userPassword:_password.text];
}

-(void)serviceSuccessed:(NSDictionary*)keyValues pMethod:(NSString*)method
{
    //隐藏菊花
//    dispatch_async(dispatch_get_main_queue(), ^{
//        
//        [loading hide:YES];
//        
//    });
    
    if(keyValues.count>0 && [[keyValues allKeys] containsObject:@"res" ])
    {
        NSInteger res = [[keyValues objectForKey:@"res"] integerValue];
        if (res>10) {
            [self saveUserLog];
            [self saveDevice];
            WriteInformationViewController *regview=[[self storyboard]instantiateViewControllerWithIdentifier:@"WriteInformationViewController"];
            UINavigationController *nav=[[UINavigationController alloc] initWithRootViewController:regview];
            NSLog(@"obj=%@",[keyValues objectForKey:@"res"]);
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            [userDefaults setObject:[NSNumber numberWithInteger:[[keyValues objectForKey:@"res"] integerValue]] forKey:@"userid"];
            [regview setUserId:[[keyValues objectForKey:@"res"] integerValue]];
            NSString *uname =_username.text;
            NSString *pword=_password.text;
            [regview setUsername:uname];
            [regview setPassword:pword];
            [self presentViewController:nav animated:YES completion:nil];
        }
        else if(res==1)
        {
            [self showSystemAlert:@"您注册的的用户名称已经存在，请更换其它用户。"];
        }
        else
        {
            [self showSystemAlert:@"注册失败，请检查您填写的信息是否正确并重试。"];
        }
    }
    else
    {
        [self showSystemAlert:@"注册失败，请检查您填写的信息是否正确并重试。"];
    }
}

-(void)saveDevice
{
    /*
    UserDevices *device = [UserDevices MR_createEntity];
    device.userName = _username.text;
    if (self.paperCheckbox.isChecked&&self.paperCheckbox2.isChecked) {
        device.deviceType=[NSNumber numberWithInt:2];
    }
    else if(self.paperCheckbox.isChecked)
    {
        device.deviceType=[NSNumber numberWithInt:0];
    }
    else if(self.paperCheckbox2.isChecked)
    {
        device.deviceType=[NSNumber numberWithInt:1];
    }
    */
    [[NSManagedObjectContext MR_defaultContext] MR_save];
}

-(void)saveUserLog
{
    UserLog *user = [UserLog MR_createEntity];
    user.lastLoginTime=[NSDate date];
    user.username=_username.text;
    user.password=_password.text;
    [[NSManagedObjectContext MR_defaultContext] MR_save];
    
}

-(void)serviceFailed:(NSString*) message pMethod:(NSString*)method
{
    [self showSystemAlert:@"注册失败，请检查您的网络连接"];
}

- (IBAction)backupView:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
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
