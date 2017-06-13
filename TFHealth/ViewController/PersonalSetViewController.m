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
#import "MBProgressHUD.h"
#import "TestItemID.h"

@interface PersonalSetViewController ()<IQActionSheetPickerViewDelegate,ServiceObjectDelegate,UITextFieldDelegate,UIScrollViewDelegate>
{
    MBProgressHUD *loading;
    UITextField *_currentTF;
}
@property (weak, nonatomic) IBOutlet UILabel *langLable;
@property (weak, nonatomic) IBOutlet UILabel *targetLable;
@property (weak, nonatomic) IBOutlet UILabel *alertLable;
@property (weak, nonatomic) IBOutlet UIView *networkView;
@property (weak, nonatomic) IBOutlet UIView *targetView;//上侧视图
@property (weak, nonatomic) IBOutlet UIView *wifiblueView;
@property (weak, nonatomic) IBOutlet UILabel *netdescLabel;
@property (weak, nonatomic) IBOutlet UIView *netgroupView;
@property (weak, nonatomic) IBOutlet UIView *weightView;
@property (weak, nonatomic) IBOutlet UIView *panel2View;//中部视图
@property (weak, nonatomic) IBOutlet UIView *panel3View;//下侧试图
@property (weak, nonatomic) IBOutlet UIView *panel4View;//用户类型
- (IBAction)savePersonalSetting:(id)sender;//保存按钮
@property (weak, nonatomic) IBOutlet UITextField *txtWeightTarget;//体重目标
@property (weak, nonatomic) IBOutlet UITextField *txtWeekWeightTarget;//一周减重
@property (weak, nonatomic) IBOutlet UITextField *txtSportSubWeight;//运动减重
@property (weak, nonatomic) IBOutlet UITextField *txtFoodSubWeight;//膳食减重
@property (weak, nonatomic) IBOutlet UITextField *txtSleepTimeLength;//睡眠时长
@property (weak, nonatomic) IBOutlet UITextField *txtStepCountTarget;//目标设定
@property (weak, nonatomic) IBOutlet UITextField *txtAlertTime;//提醒时间
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

#pragma mark - 保存按钮
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
    
    //隐藏加载
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [loading hide:YES];
        
    });
    
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
                
                [self refreshUI];
                [self showSystemAlert:CustomLocalizedString(@"PersonSetSuccess", nil)];
                
            }
            else
            {
                
                [self showSystemAlert:CustomLocalizedString(@"PerSetFaiCheckInfo", nil)];
            }
        }
        else
        {
            [self showSystemAlert:CustomLocalizedString(@"PerSetFaiCheckInfo", nil)];
        }
    }
    else
    {
        [self showSystemAlert:CustomLocalizedString(@"LoginFailed", nil)];
    }
}

-(void)serviceFailed:(NSString*) message pMethod:(NSString*)method
{
    //隐藏菊花
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [loading hide:YES];
        
    });
    [self showSystemAlert:CustomLocalizedString(@"connectNetworkFails", nil)];
}


-(BOOL)isVerify
{
    BOOL res = true;
    /*
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
    */
    AppDelegate *appdelegate =(AppDelegate*) [[UIApplication sharedApplication] delegate];
    //获取最后一次测试体重值
    User_Item_Info* lastWeightItem = [User_Item_Info MR_findFirstWithPredicate:[NSPredicate predicateWithFormat:@"userId==%d AND itemId==%d",appdelegate.user.userId.intValue,[TestItemID getWeight]] sortedBy:@"testDate" ascending:false inContext:[NSManagedObjectContext MR_defaultContext]];
    NSString *str =@"^[0-9]+(.[0-9])?$";//验证数字和小数的正则表达式,小数位数不限制
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", str];
    NSString *strZheng = @"^[0-9]*$";
    NSPredicate* predicateZheng = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", strZheng];
    
    if (_targetView.hidden == NO) {
        if (![predicate evaluateWithObject:_txtWeightTarget.text])
        {
            [self showSystemAlert:CustomLocalizedString(@"WeightTargetNFormat", nil)];
            res=false;
        }
        else if (!(_txtWeightTarget.text.doubleValue >= 10 && _txtWeightTarget.text.doubleValue <= 200))
        {
            [self showSystemAlert:CustomLocalizedString(@"WeightValueWrong", nil)];
            res=false;
        }
//        else if (lastWeightItem.testValue.doubleValue > 0) {
//            if (_txtWeightTarget.text.doubleValue >= lastWeightItem.testValue.doubleValue)
//            {
//                [self showSystemAlert:CustomLocalizedString(@"WeightGreater", nil)];
//                res=false;
//            }
//        }
        else if (![predicate evaluateWithObject:_txtWeekWeightTarget.text])
        {
            [self showSystemAlert:CustomLocalizedString(@"WeekWeightNFormat", nil)];
            res = false;
        }
        else if (!(_txtWeekWeightTarget.text.doubleValue >= 0.1 && _txtWeekWeightTarget.text.doubleValue <= 0.9))
        {
            [self showSystemAlert:CustomLocalizedString(@"WeightReduction", nil)];
            res=false;
        }
        else if (![predicate evaluateWithObject:_txtSportSubWeight.text])
        {
            [self showSystemAlert:CustomLocalizedString(@"WeightLossExeNFormat", nil)];
            res=false;
        }
        else if (![predicate evaluateWithObject:_txtFoodSubWeight.text])
        {
            [self showSystemAlert:CustomLocalizedString(@"WeightLossDietNFormat", nil)];
            res=false;
        }
        else if (_txtSportSubWeight.text.doubleValue + _txtFoodSubWeight.text.doubleValue != 100)
        {
            [self showSystemAlert:CustomLocalizedString(@"DietaryWeight", nil)];
            res=false;
        }
    }
    if (res == true) {
        if (![predicateZheng evaluateWithObject:_txtSleepTimeLength.text])
        {
            [self showSystemAlert:CustomLocalizedString(@"SleepLengthNFormat", nil)];
            res=false;
        }
        else if (![predicateZheng evaluateWithObject:_txtStepCountTarget.text])
        {
            [self showSystemAlert:CustomLocalizedString(@"GoalSettingNFormat", nil)];
            res=false;
        }
        else if (!(_txtSleepTimeLength.text.doubleValue >= 5 && _txtSleepTimeLength.text.doubleValue <= 10))
        {
            [self showSystemAlert:CustomLocalizedString(@"SleepTimeWrong", nil)];
            res=false;
        }
        else if (![self checkNumber:_txtStepCountTarget.text])
        {
            [self showSystemAlert:CustomLocalizedString(@"StepGoalWrong", nil)];
            res=false;
        }
        else if ([_txtAlertTime.text isEqual:[NSNull null]]
                 ||[_txtAlertTime.text length] < 1
                 )
        {
            [self showSystemAlert:CustomLocalizedString(@"RemindTimeWrong", nil)];
            res=false;
        }
        
        if (res == true) {
            /*
            NSString *strHanZi = @"^[\u4E00-\u9FA5]*$";
            NSPredicate *predicateHanZi = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", strHanZi];
            NSMutableString* mStr = [NSMutableString stringWithString:_txtAlertTime.text];
            NSRange sRange =[mStr rangeOfString:@"："];
            if ([predicateHanZi evaluateWithObject:_txtAlertTime.text])
            {
                [self showSystemAlert:CustomLocalizedString(@"RemindTimeWrong", nil)];
                res=false;
            }
            else if(sRange.location!=NSNotFound)
            {
                [mStr replaceCharactersInRange:sRange withString:@":"];
            }
            
            NSRange range = [mStr rangeOfString:@":"];
            if(range.length==0)
            {
                [self showSystemAlert:CustomLocalizedString(@"RemindTimeWrong", nil)];
                res=false;
            }
            else
            {
                NSString *a = [mStr substringToIndex:range.location];
                NSString *b = [mStr substringFromIndex:range.location +
                               range.length];
                if([a length]==0|| [b length]==0)
                {
                    [self showSystemAlert:CustomLocalizedString(@"RemindTimeWrong", nil)];
                    res=false;
                }
                if(![self checkNumber:a] || ![self checkNumber:b] )
                {
                    [self showSystemAlert:CustomLocalizedString(@"RemindTimeWrong", nil)];
                    res=false;
                }
            }
             */
            
            
//            NSString *strTime = @"^(20|21|22|23|[0-1]\\d):[0-5]\\d$";
            NSString *strTime = @"^(20|21|22|23|[0-1]?\\d):[0-5]?\\d$";
            NSPredicate* predicateTime = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", strTime];
            if (![predicateTime evaluateWithObject:_txtAlertTime.text]) {
                [self showSystemAlert:CustomLocalizedString(@"RemindTimeWrong", nil)];
                res=false;
            }
            
        }
        
    }

    return res;
}

- (IBAction)showSystemAlert:(id)sender
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:CustomLocalizedString(@"tip", nil) message:sender delegate:nil cancelButtonTitle:CustomLocalizedString(@"OK", nil) otherButtonTitles: nil];
    
    [alertView show];
}

- (IBAction)backButtonClikc:(id)sender {
    [self editPortrait:nil];
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
    
    [self.txtWeightTarget setDelegate:self];
    [self.txtAlertTime setDelegate:self];
    [self.txtFoodSubWeight setDelegate:self];
    [self.txtSleepTimeLength setDelegate:self];
    [self.txtSportSubWeight setDelegate:self];
    [self.txtStepCountTarget setDelegate:self];
    [self.txtWeekWeightTarget setDelegate:self];
    
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
        _alertLable.text=[NSString stringWithFormat:CustomLocalizedString(@"EveryDayTime", nil),[sysinfo.remindTime integerValue]];
        _langLable.text = sysinfo.language;
    }
    
//    [self.scrollView setContentSize:CGSizeMake(300, self.view.frame.size.height+120)];
    self.scrollView.delegate = self;
    NSLog(@"count=%ld",_wifiblueView.subviews.count);
    
    
    self.txtWeightTarget.delegate = self;
    self.txtWeekWeightTarget.delegate = self;
    self.txtSportSubWeight.delegate = self;
    self.txtFoodSubWeight.delegate = self;
    self.txtSleepTimeLength.delegate = self;
    self.txtStepCountTarget.delegate = self;
    self.txtAlertTime.delegate = self;
    
    UITapGestureRecognizer *portraitTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(editPortrait:)];
    [self.view addGestureRecognizer:portraitTap];
}

-(void)viewDidLayoutSubviews
{
//    [self.scrollView setContentSize:CGSizeMake(300, self.view.frame.size.height+120)];
    [self refreshUI];
}

-(void)editPortrait:(UITapGestureRecognizer*)sender
{
    [self.txtWeightTarget resignFirstResponder];
    [self.txtWeekWeightTarget resignFirstResponder];
    [self.txtSportSubWeight resignFirstResponder];
    [self.txtFoodSubWeight resignFirstResponder];
    [self.txtSleepTimeLength resignFirstResponder];
    [self.txtStepCountTarget resignFirstResponder];
    [self.txtAlertTime resignFirstResponder];
}


//- (void)viewDidAppear:(BOOL)animated
//{
//    //CGRect frame = self.scrollView.frame;
//    //frame.size.height=self.view.frame.size.height-40;
//    //self.scrollView.frame=frame;
//    [self refreshUI];
//    
//}

//-(void)viewWillAppear:(BOOL)animated
//{
//    [super viewWillAppear:animated];
//    [self refreshUI];
//}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    _currentTF = textField;
    return YES;
}

//添加通知中心
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}
//移除通知中心
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}


-(void)keyboardWillShow:(NSNotification*)notification
{
    //1、取得键盘最后的frame
    CGRect keyboardFrame = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat height = keyboardFrame.origin.y;
    //2、计算控制器的view需要移动的距离
    CGFloat textField_maxY = _currentTF.superview.frame.origin.y +  _currentTF.superview.superview.frame.origin.y + _currentTF.frame.size.height;
    CGFloat transformY = height - textField_maxY;
    //3、当键盘挡道到输入框的时候就开始移动，不然不移动，有时要考虑导航栏＋64
    if (transformY < 0) {
        /*
         CGRect frame = self.view.frame;
         frame.origin.y = transformY ;
         self.view.frame = frame;
         */
        NSNumber *duration = [notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
        NSNumber *curve = [notification.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
        NSValue *keyboardBeginBounds=[[notification userInfo]objectForKey:UIKeyboardFrameBeginUserInfoKey];
        CGRect beginRect=[keyboardBeginBounds CGRectValue];
        
        NSValue *keyboardEndBounds=[[notification userInfo]objectForKey:UIKeyboardFrameEndUserInfoKey];
        CGRect endRect=[keyboardEndBounds CGRectValue];
        CGFloat deltaY=endRect.origin.y-beginRect.origin.y;
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationDuration:[duration doubleValue]];
        [UIView setAnimationCurve:[curve intValue]];
        //更改聊天窗口table的inset  位置  inputbar位置
        CGRect frame = self.view.frame;
        frame.origin.y = transformY ;
        self.view.frame = frame;
        [UIView commitAnimations];
    }
}

-(void)keyboardWillHide:(NSNotification*)notification
{
    /*
     //恢复到默认y为0的状态，有时候要考虑导航栏要+64
     CGRect frame = self.view.frame;
     frame.origin.y = 0;
     self.view.frame = frame;
     */
    NSNumber *duration = [notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [notification.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    NSValue *keyboardBeginBounds=[[notification userInfo]objectForKey:UIKeyboardFrameBeginUserInfoKey];
    CGRect beginRect=[keyboardBeginBounds CGRectValue];
    
    NSValue *keyboardEndBounds=[[notification userInfo]objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect endRect=[keyboardEndBounds CGRectValue];
    CGFloat deltaY=endRect.origin.y-beginRect.origin.y;
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];
    //更改聊天窗口table的inset  位置  inputbar位置
    CGRect frame = self.view.frame;
    frame.origin.y = 0;
    self.view.frame = frame;
    [UIView commitAnimations];
}

-(void)refreshUI
{
    AppDelegate *appdelegate =(AppDelegate*) [[UIApplication sharedApplication] delegate];
//    NSLog(@"deviceType = %d",appdelegate.deviceType);
    if (appdelegate.deviceType==1) {
        //秤用户
        _panel2View.hidden=YES;
        _targetView.hidden=NO;
        [_targetView moveToHorizontal:_targetView.frame.origin.x toVertical:80];
        [_panel3View moveToHorizontal:_panel3View.frame.origin.x toVertical:341-88];
        [_panel4View moveToHorizontal:_panel4View.frame.origin.x toVertical:390-88];
        [_btnSaveSet moveToHorizontal:_btnSaveSet.frame.origin.x toVertical:440-88];
        /*
        [_panel3View moveToHorizontal:_panel3View.frame.origin.x toVertical:_panel3View.frame.origin.y-88];
        [_panel4View moveToHorizontal:_panel4View.frame.origin.x toVertical:_panel4View.frame.origin.y-88];
        [_btnSaveSet moveToHorizontal:_btnSaveSet.frame.origin.x toVertical:_btnSaveSet.frame.origin.y-88];
         */
    }
    else if(appdelegate.deviceType==0)
    {
        //手环用户
        _targetView.hidden=YES;
        _panel2View.hidden=NO;
        
        [_panel2View moveToHorizontal:_panel2View.frame.origin.x toVertical:252-164];
        [_panel3View moveToHorizontal:_panel3View.frame.origin.x toVertical:341-164];
        [_panel4View moveToHorizontal:_panel4View.frame.origin.x toVertical:390-164];
        [_btnSaveSet moveToHorizontal:_btnSaveSet.frame.origin.x toVertical:440-164];
        
        /*
        [_panel2View moveToHorizontal:_panel2View.frame.origin.x toVertical:_panel2View.frame.origin.y-164];
        [_panel3View moveToHorizontal:_panel3View.frame.origin.x toVertical:_panel3View.frame.origin.y-164];
        [_panel4View moveToHorizontal:_panel4View.frame.origin.x toVertical:_panel4View.frame.origin.y-164];
        [_btnSaveSet moveToHorizontal:_btnSaveSet.frame.origin.x toVertical:_btnSaveSet.frame.origin.y-164];
         */
    }
    else if (appdelegate.deviceType == 2)
    {
        //两者都有
        _targetView.hidden=NO;
        _panel2View.hidden=NO;
        
        [_targetView moveToHorizontal:_targetView.frame.origin.x toVertical:80];
        [_panel2View moveToHorizontal:_panel2View.frame.origin.x toVertical:252];
        [_panel3View moveToHorizontal:_panel3View.frame.origin.x toVertical:341];
        [_panel4View moveToHorizontal:_panel4View.frame.origin.x toVertical:390];
        [_btnSaveSet moveToHorizontal:_btnSaveSet.frame.origin.x toVertical:440];
        
    }
    
//    UserDevices *device=[UserDevices MR_findFirstWithPredicate:[NSPredicate predicateWithFormat:@"userName==%@",appdelegate.user.userName]  inContext:[NSManagedObjectContext MR_defaultContext]];
//    if (device!=nil) {
//        self.segmentUserDevices.selectedSegmentIndex=device.deviceType.intValue;
//        NSLog(@"selectedSegmentIndex = %ld",self.segmentUserDevices.selectedSegmentIndex);
//    }
    
    self.segmentUserDevices.selectedSegmentIndex=appdelegate.deviceType;

}

-(void) initUI
{
    UIColor *borderColor = [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:0.2];
    UIColor *traColor = [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:0];
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
    //通过userid查找到的PersonalSet需要根据startDate进行降序排序，取最近的值
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
        appDelegate.deviceType = device.deviceType.intValue;
    }
    else
    {
        _segmentUserDevices.selectedSegmentIndex = 1;
        appDelegate.deviceType = 1;
    }

    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIScrollViewDelegate
-(void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    
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

//分段控件绑定方法
- (IBAction)UserDevices_OnChanged:(id)sender {
    [self editPortrait:nil];
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
    
    //加载菊花
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
        loading = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        loading.dimBackground = YES;
        loading.animationType = 2;
//    });
//    loading.hidden = NO;
    
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
