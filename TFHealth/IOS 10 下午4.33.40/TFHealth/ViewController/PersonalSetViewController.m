//
//  PersonalSetViewController.m
//  TFHealth
//
//  Created by hzth hzth－mac2 on 6/3/14.
//  Copyright (c) 2014 studio37. All rights reserved.
//

#import "PersonalSetViewController.h"
#import "PPiFlatSegmentedControl.h"
#import "NSString+FontAwesome.h"
#import "HealthStatusViewController.h"
#import "UIViewController+MMDrawerController.h"
#import "IQActionSheetPickerView.h"
#import "PersonalSet.h"
#import "SystemInfo.h"
#import "CXAlertView.h"
#import "PersonalSet.h"
#import "AppDelegate.h"
#import "AppCloundService.h"
#import "ServiceCallbackDelegate.h"
#import "UIView+FrameMethods.h"
#import "UserDevices.h"

@interface PersonalSetViewController ()<IQActionSheetPickerViewDelegate,ServiceObjectDelegate>
@property (weak, nonatomic) IBOutlet UILabel *langLable;
@property (weak, nonatomic) IBOutlet UILabel *targetLable;
@property (weak, nonatomic) IBOutlet UILabel *alertLable;
@property (weak, nonatomic) IBOutlet UIView *networkView;
@property (weak, nonatomic) IBOutlet UIView *targetView;
@property (weak, nonatomic) IBOutlet UIView *wifiblueView;
@property (weak, nonatomic) IBOutlet UILabel *netdescLabel;
@property (weak, nonatomic) IBOutlet UIView *netgroupView;
@property (weak, nonatomic) IBOutlet UIView *weightView;
@property (weak, nonatomic) IBOutlet UIView *panel2View;
@property (weak, nonatomic) IBOutlet UIView *panel3View;
@property (weak, nonatomic) IBOutlet UIView *panel4View;
- (IBAction)savePersonalSetting:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *txtWeightTarget;
@property (weak, nonatomic) IBOutlet UITextField *txtWeekWeightTarget;
@property (weak, nonatomic) IBOutlet UITextField *txtSportSubWeight;
@property (weak, nonatomic) IBOutlet UITextField *txtFoodSubWeight;
@property (weak, nonatomic) IBOutlet UITextField *txtSleepTimeLength;
@property (weak, nonatomic) IBOutlet UITextField *txtStepCountTarget;
@property (weak, nonatomic) IBOutlet UITextField *txtAlertTime;
@property (weak, nonatomic) IBOutlet UIButton *btnSaveSet;
- (IBAction)UserDevices_OnChanged:(id)sender;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentUserDevices;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@end

@implementation PersonalSetViewController

#define NUMBERSPERIOD @"0123456789."

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (IBAction)savePersonalSetting:(id)sender {
    if ([self isVerify]) {
        
        [self SaveUserDeviceType];
        AppDelegate *appdelegate =(AppDelegate*) [[UIApplication sharedApplication] delegate];
        User* user = appdelegate.user;
        
        NSMutableString* mStr = [NSMutableString stringWithString:_txtAlertTime.text];
        NSRange sRange =[mStr rangeOfString:@"："];
        if(sRange.location!=NSNotFound)
        {
            [mStr replaceCharactersInRange:sRange withString:@":"];
        }
        
        AppCloundService* s= [[AppCloundService alloc] initWidthDelegate:self];
        [s addAndUpdatePersonalSet:user.userId.intValue targetWeight:_txtWeightTarget.text.floatValue weekSubTarget:_txtWeekWeightTarget.text.floatValue sportProp:_txtSportSubWeight.text.floatValue foodProp:_txtFoodSubWeight.text.floatValue sleepTimeLength:_txtSleepTimeLength.text stepLength:70 stepCount:_txtStepCountTarget.text.intValue alertTime:[NSString stringWithFormat:@"%@",mStr]];
    }
}


-(void)serviceSuccessed:(NSDictionary*)keyValues pMethod:(NSString*)method
{
    if([method isEqualToString:@"SetUserDevicesJson"])
    {
        
    }
    else if(keyValues.count>0 )
    {
        if ([[keyValues allKeys] containsObject:@"res" ])
        {
            NSString *res = [keyValues objectForKey:@"res"];
            int personId = res.intValue;
            if (personId>0) {
                AppDelegate *appdelegate =(AppDelegate*) [[UIApplication sharedApplication] delegate];
                User* user = appdelegate.user;
                PersonalSet *p=[PersonalSet MR_findFirstOrCreateByAttribute:@"personId" withValue:[NSNumber numberWithInt:res.intValue] inContext:[NSManagedObjectContext MR_defaultContext]];
                p.userId=user.userId;
                p.personId=[NSNumber numberWithInt:personId];
                p.targetWeight=[NSNumber numberWithFloat:[_txtWeightTarget.text floatValue]];
                if (p.startDate==nil||p.startDate==NULL) {
                    NSDate *date = [NSDate date];
                    p.startDate=date;
                }
                p.weekTarget=[NSNumber numberWithFloat:[_txtWeekWeightTarget.text floatValue]];
                p.sportSubtract =[NSNumber numberWithFloat:[_txtSportSubWeight.text floatValue]];
                p.foodSubtract=[NSNumber numberWithFloat:[_txtFoodSubWeight.text floatValue]];
                p.sleepTimeLength=[NSNumber numberWithFloat:[_txtSleepTimeLength.text floatValue]];
                p.stepLength=[NSNumber numberWithInt:70];
                p.stepTargetCount=[NSNumber numberWithInt:[_txtStepCountTarget.text intValue]];
                NSMutableString* mStr = [NSMutableString stringWithString:_txtAlertTime.text];
                NSRange sRange =[mStr rangeOfString:@"："];
                if(sRange.location!=NSNotFound)
                {
                    [mStr replaceCharactersInRange:sRange withString:@":"];
                }
                p.remindTime=[NSString stringWithFormat:@"%@",mStr];
                [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
                [self showSystemAlert:@"您的个人设置已保存成功。"];
                
            }
            else
            {
                [self showSystemAlert:@"个人设置保存失败，请检查您的信息是否正确。"];
            }
        }
        else
        {
            [self showSystemAlert:@"个人设置保存失败，请检查您的信息是否正确。"];
        }
    }
    else
    {
        [self showSystemAlert:@"登录失败，请检查您的用户密码是否正确。"];
    }
}

-(void)serviceFailed:(NSString*) message pMethod:(NSString*)method
{
    [self showSystemAlert:@"连接网络失败，请检查您的网络。"];
}


-(BOOL)isVerify
{
    BOOL res = true;
    if (![self checkNumber:_txtWeightTarget.text]) {
        [self showSystemAlert:@"您的体重目标不正确，请输入10至200之间的数值。"];
        res=false;
    }
    else if (![self checkNumber:_txtWeekWeightTarget.text])
    {
        [self showSystemAlert:@"您的周减重目标不正确，请输入0.1至20之间的数值。"];
        res=false;
    }
    else if (![self checkNumber:_txtSportSubWeight.text])
    {
        [self showSystemAlert:@"您的运动减重目标不正确，运动减重与膳食减重两项合计应为100。"];
        res=false;
    }
    else if (![self checkNumber:_txtFoodSubWeight.text])
    {
        [self showSystemAlert:@"您的膳食减重目标不正确，运动减重与膳食减重两项合计应为100。"];
        res=false;
    }
    else if (![self checkNumber:_txtSleepTimeLength.text])
    {
        [self showSystemAlert:@"您的睡眼时长不正确，正确的时长应该为5-10小时之间。"];
        res=false;
    }
    else if (![self checkNumber:_txtStepCountTarget.text])
    {
        [self showSystemAlert:@"您的步伐目标不正确，步伐目标指您计划阶段内走的步伐数量。"];
        res=false;
    }
    else if ([_txtAlertTime.text isEqual:[NSNull null]]
             ||[_txtAlertTime.text length] < 1
             )
    {
        [self showSystemAlert:@"您提醒时间不正确，正常的格式如:8:30。"];
        res=false;
    }
    NSMutableString* mStr = [NSMutableString stringWithString:_txtAlertTime.text];
    NSRange sRange =[mStr rangeOfString:@"："];
    if(sRange.location!=NSNotFound)
    {
        [mStr replaceCharactersInRange:sRange withString:@":"];
    }
    
    NSRange range = [mStr rangeOfString:@":"];
    if(range.length==0)
    {
        [self showSystemAlert:@"您提醒时间不正确，正常的格式如:8:30。"];
        res=false;
    }
    else
    {
        NSString *a = [mStr substringToIndex:range.location];
        NSString *b = [mStr substringFromIndex:range.location +
                       range.length];
        if([a length]==0|| [b length]==0)
        {
            [self showSystemAlert:@"您提醒时间不正确，正常的格式如:8:30。"];
            res=false;
        }
        if(![self checkNumber:a] || ![self checkNumber:b] )
        {
            [self showSystemAlert:@"您提醒时间不正确，正常的格式如:8:30。"];
            res=false;
        }
    }

    return res;
}

- (IBAction)showSystemAlert:(id)sender
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:sender delegate:nil cancelButtonTitle:@"好" otherButtonTitles: nil];
    
    [alertView show];
}

- (IBAction)backButtonClikc:(id)sender {
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideRight animated:YES completion:nil];
}

-(void)actionSheetPickerView:(IQActionSheetPickerView *)pickerView didSelectTitles:(NSArray *)titles
{
    switch (pickerView.tag)
    {
        case 1:[self saveTarget:titles[0]]; break;
        case 2:
        {
            NSString *title = [NSString stringWithFormat:@"%@  %@",titles[0],titles[1]];
            [self saveAlert:title]; break;
        }
        case 3: [self saveLang:titles[0]]; break;
        default:
            break;
    }
}

-(BOOL)checkNumber:(NSString *)string
{
    NSCharacterSet*cs;
    cs =[[NSCharacterSet characterSetWithCharactersInString:NUMBERSPERIOD]invertedSet];
    NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs]componentsJoinedByString:@""];
    BOOL basicTest = [string isEqualToString:filtered];
    return basicTest;
}

- (IBAction)targetViewClicked:(UIButton *)sender {
    IQActionSheetPickerView *picker = [[IQActionSheetPickerView alloc] initWithTitle:@"目标体重" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil, nil];
    [picker setTag:1];
    NSMutableArray *mutablearray= [[NSMutableArray alloc] init];
    for (int i=30;i<200;i++) {
        NSString* weight = [NSString stringWithFormat:@"%d kg",i];
        [mutablearray addObject:weight];
    }
    //NSArray *barry = [[NSArray alloc] initWithArray: mutablearray];
    [picker setTitlesForComponenets:[NSArray arrayWithObjects:
                                     [NSArray arrayWithArray:mutablearray],
                                     nil]];
    [picker showInView:self.view];
}

-(void)saveTarget:(NSString *)selectedItem
{
    _targetLable.text=selectedItem;
    NSArray *firstSplit = [selectedItem componentsSeparatedByString:@" "];
    NSDate *dateToDay = [NSDate date];
    PersonalSet *item = [PersonalSet MR_createEntity];
    item.targetWeight = [NSNumber numberWithFloat:[firstSplit[0] floatValue]];
    
    item.startDate=dateToDay;
    [[NSManagedObjectContext MR_defaultContext] MR_save];
}

- (IBAction)alertViewClicked:(UIButton *)sender {
    IQActionSheetPickerView *picker = [[IQActionSheetPickerView alloc] initWithTitle:@"提醒方式" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil, nil];
    [picker setTag:2];
    [picker setTitlesForComponenets:[NSMutableArray arrayWithObjects:
                                     [NSMutableArray arrayWithObjects:@"每天", nil],
                                     [NSMutableArray arrayWithObjects:@"0点",@"1点", @"2点", @"3点", @"4点",@"5点", @"6点", @"7点", @"8点",@"9点", @"10点", @"11点",@"12点", @"13点", @"14点",@"15点", @"16点", @"17点",@"18点", @"19点", @"20点",@"21点",  @"22点", @"23点",nil],
                                     nil]];
    [picker setWidthsForComponents:[NSArray arrayWithObjects:
                                    [NSNumber numberWithFloat:60],
                                    [NSNumber numberWithFloat:100],
                                    nil]];
    [picker showInView:self.view];
}

-(void)saveAlert:(NSString *)selectedItem
{
    _alertLable.text=selectedItem;
    NSNumber *date = [NSNumber numberWithInteger:[[selectedItem substringWithRange:NSMakeRange(4, 2)] integerValue]];
    SystemInfo *sysinfo = [SystemInfo MR_findFirstInContext:[NSManagedObjectContext MR_defaultContext]];
    if (sysinfo!=nil) {
        sysinfo.remindTime=date;
        sysinfo.remindWay=[NSNumber numberWithInteger:1];
        [[NSManagedObjectContext MR_defaultContext] MR_save];
    }
    else
    {
        SystemInfo *sys=[SystemInfo MR_createEntity];
        sys.remindTime=date;
        sysinfo.remindWay=[NSNumber numberWithInteger:1];
        [[NSManagedObjectContext MR_defaultContext] MR_save];
    }
}

- (IBAction)langViewClicked:(UIButton *)sender {
    IQActionSheetPickerView *picker = [[IQActionSheetPickerView alloc] initWithTitle:@"语言选择" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil, nil];
    [picker setTag:3];
    [picker setTitlesForComponenets:[NSArray arrayWithObjects:
                                     [NSArray arrayWithObjects:@"简体中文", @"英文", @"繁体中文", nil],
                                     nil]];
    [picker showInView:self.view];
}

-(void)saveLang:(NSString *)selectedItem
{
    _langLable.text=selectedItem;
    SystemInfo *sysinfo = [SystemInfo MR_findFirstInContext:[NSManagedObjectContext MR_defaultContext]];
    if (sysinfo!=nil) {
        sysinfo.language=selectedItem;
        [[NSManagedObjectContext MR_defaultContext] MR_save];
    }
    else
    {
        SystemInfo *sys=[SystemInfo MR_createEntity];
        sys.language=selectedItem;
        [[NSManagedObjectContext MR_defaultContext] MR_save];
    }
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initUI];
    
    [self initData];
    
    [_txtWeightTarget setDelegate:self];
    [_txtAlertTime setDelegate:self];
    [_txtFoodSubWeight setDelegate:self];
    [_txtSleepTimeLength setDelegate:self];
    [_txtSportSubWeight setDelegate:self];
    [_txtStepCountTarget setDelegate:self];
    [_txtWeekWeightTarget setDelegate:self];
    
    // Do any additional setup after loading the view.
    PPiFlatSegmentedControl *segmented=[[PPiFlatSegmentedControl alloc] initWithFrame:CGRectMake(5,1, 78, 30) items:@[               @{@"text":@"wifi",@"icon":@""},@{@"text":@"蓝牙",@"icon":@""}]iconPosition:IconPositionRight andSelectionBlock:^(NSUInteger segmentIndex) {}];
    segmented.color=[UIColor clearColor];
    segmented.borderWidth=0.5;
    segmented.borderColor= COLOR(54, 148, 254, 1);
    segmented.selectedColor=COLOR(54, 148, 254, 1);;
    segmented.textAttributes=@{NSFontAttributeName:[UIFont systemFontOfSize:13],
                               NSForegroundColorAttributeName:[UIColor whiteColor]};
    segmented.selectedTextAttributes=@{NSFontAttributeName:[UIFont systemFontOfSize:13],
                                       NSForegroundColorAttributeName:[UIColor whiteColor]};
    
    segmented.enabled = YES;
    segmented.userInteractionEnabled  = YES;
    [segmented addTarget:self action:@selector(segmentClick:) forControlEvents:UIControlEventValueChanged];
    [self.wifiblueView addSubview:segmented];
    
    /*PersonalSet *person1 = [PersonalSet MR_findFirst];//此处略
     [person1 MR_deleteEntity];
     [[NSManagedObjectContext MR_defaultContext] MR_save];*/
    
    //查找数据库中的第一条记录
    PersonalSet *person = [PersonalSet MR_findFirstOrderedByAttribute:@"startDate" ascending:NO inContext:[NSManagedObjectContext MR_defaultContext]];
    if (person!=nil) {
        _targetLable.text=[NSString stringWithFormat:@"%d kg", [person.targetWeight integerValue]];
        
    }
    
    SystemInfo *sysinfo = [SystemInfo MR_findFirstInContext:[NSManagedObjectContext MR_defaultContext]];
    if (sysinfo!=nil) {
        _alertLable.text=[NSString stringWithFormat:@"每天 %d点",[sysinfo.remindTime integerValue]];
        _langLable.text = sysinfo.language;
    }
    
    [self.scrollView setContentSize:CGSizeMake(300, self.view.frame.size.height+120)];
    NSLog(@"count=%d",_wifiblueView.subviews.count);
}

- (void)viewDidAppear:(BOOL)animated
{
    //CGRect frame = self.scrollView.frame;
    //frame.size.height=self.view.frame.size.height-40;
    //self.scrollView.frame=frame;
    AppDelegate *appdelegate =(AppDelegate*) [[UIApplication sharedApplication] delegate];
    if (appdelegate.deviceType==1) {
        _panel2View.hidden=YES;
        [_panel3View moveToHorizontal:_panel3View.frame.origin.x toVertical:_panel3View.frame.origin.y-88];
        [_panel4View moveToHorizontal:_panel4View.frame.origin.x toVertical:_panel4View.frame.origin.y-88];
        [_btnSaveSet moveToHorizontal:_btnSaveSet.frame.origin.x toVertical:_btnSaveSet.frame.origin.y-88];
    }
    else if(appdelegate.deviceType==0)
    {
        _targetView.hidden=YES;
        
        [_panel2View moveToHorizontal:_panel2View.frame.origin.x toVertical:_panel2View.frame.origin.y-164];
        [_panel3View moveToHorizontal:_panel3View.frame.origin.x toVertical:_panel3View.frame.origin.y-164];
        [_panel4View moveToHorizontal:_panel4View.frame.origin.x toVertical:_panel4View.frame.origin.y-164];
        [_btnSaveSet moveToHorizontal:_btnSaveSet.frame.origin.x toVertical:_btnSaveSet.frame.origin.y-164];
    }
    
}

-(void) initUI
{
    UIColor *borderColor = [UIColor colorWithRed:255.0 green:255.0 blue:255.0 alpha:0.2];
    UIColor *traColor = [UIColor colorWithRed:255.0 green:255.0 blue:255.0 alpha:0];
    _networkView.layer.masksToBounds = YES;
    _networkView.layer.cornerRadius = 6.0;
    _networkView.layer.borderWidth = 1.0;
    _networkView.layer.borderColor = [borderColor CGColor];
    _networkView.layer.backgroundColor=[borderColor CGColor];
    
    _targetView.layer.masksToBounds = YES;
    _targetView.layer.cornerRadius = 6.0;
    _targetView.layer.borderWidth = 1.0;
    _targetView.layer.borderColor = [borderColor CGColor];
    _targetView.layer.backgroundColor=[borderColor CGColor];
    
    _panel2View.layer.masksToBounds = YES;
    _panel2View.layer.cornerRadius = 6.0;
    _panel2View.layer.borderWidth = 1.0;
    _panel2View.layer.borderColor = [borderColor CGColor];
    _panel2View.layer.backgroundColor=[borderColor CGColor];
    
    _panel3View.layer.masksToBounds = YES;
    _panel3View.layer.cornerRadius = 6.0;
    _panel3View.layer.borderWidth = 1.0;
    _panel3View.layer.borderColor = [borderColor CGColor];
    _panel3View.layer.backgroundColor=[borderColor CGColor];
    
    _panel4View.layer.masksToBounds = YES;
    _panel4View.layer.cornerRadius = 6.0;
    _panel4View.layer.borderWidth = 1.0;
    _panel4View.layer.borderColor = [traColor CGColor];
    _panel4View.layer.backgroundColor=[traColor CGColor];
}

-(void)initData
{
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    User *user = appDelegate.user;
    PersonalSet *p=[PersonalSet MR_findFirstWithPredicate:[NSPredicate predicateWithFormat:@"userId==%d",user.userId.intValue] sortedBy:@"startDate" ascending:NO inContext:[NSManagedObjectContext MR_defaultContext]];
    
    if (p!=nil&&p!=NULL) {
        
        _txtWeightTarget.text=[NSString stringWithFormat:@"%.1f",p.targetWeight.floatValue];
        _txtWeekWeightTarget.text=p.weekTarget.stringValue;
        _txtSportSubWeight.text=p.sportSubtract.stringValue;
        _txtFoodSubWeight.text= p.foodSubtract.stringValue;
        _txtSleepTimeLength.text=p.sleepTimeLength.stringValue;
        _txtStepCountTarget.text=p.stepTargetCount.stringValue;
        _txtAlertTime.text=p.remindTime;
    }
    
    UserDevices *device=[UserDevices MR_findFirstWithPredicate:[NSPredicate predicateWithFormat:@"userName==%@",user.userName]  inContext:[NSManagedObjectContext MR_defaultContext]];
    if (device!=nil) {
        _segmentUserDevices.selectedSegmentIndex=device.deviceType.intValue;
    }
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//开始编辑输入框的时候，软键盘出现，执行此事件
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    CGRect frame = textField.frame;
    int offset = frame.origin.y + 32 - (self.view.frame.size.height - 216.0);//键盘高度216
    
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    
    //将视图的Y坐标向上移动offset个单位，以使下面腾出地方用于软键盘的显示
    if(offset > 0)
        self.view.frame = CGRectMake(0.0f, -offset, self.view.frame.size.width, self.view.frame.size.height);
    
    [UIView commitAnimations];
}

//当用户按下return键或者按回车键，keyboard消失
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

//输入框编辑完成以后，将视图恢复到原始状态
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    self.view.frame =CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
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

- (IBAction)UserDevices_OnChanged:(id)sender {
    int deviceType = 1;
    switch (_segmentUserDevices.selectedSegmentIndex) {
        case 0:
            deviceType=0;
            break;
        case 1:
            deviceType=1;
            break;
        case 2:
            deviceType=2;
            break;
        default:
            break;
    }
}

-(void)SaveUserDeviceType
{
    int deviceType = 1;
    switch (_segmentUserDevices.selectedSegmentIndex) {
        case 0:
            deviceType=0;
            break;
        case 1:
            deviceType=1;
            break;
        case 2:
            deviceType=2;
            break;
        default:
            break;
    }
    AppDelegate *appdelegate =(AppDelegate*) [[UIApplication sharedApplication] delegate];
    
    UserDevices *device=[UserDevices MR_findFirstWithPredicate:[NSPredicate predicateWithFormat:@"userName==%@",appdelegate.user.userName]  inContext:[NSManagedObjectContext MR_defaultContext]];
    if (device==nil) {
        device = [UserDevices MR_createEntity];
    }
    device.userName = appdelegate.user.userName;
    device.deviceType=[NSNumber numberWithInt:deviceType];
    [[NSManagedObjectContext MR_defaultContext] MR_save];

    appdelegate.deviceType = device.deviceType.intValue;
    
    AppCloundService* s= [[AppCloundService alloc] initWidthDelegate:self];
    [s UploadUserDevices:appdelegate.user.userId.intValue userType:[NSString stringWithFormat:@"%@",device.deviceType]];
}
@end
