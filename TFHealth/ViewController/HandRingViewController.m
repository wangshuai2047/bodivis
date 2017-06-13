//
//  HandRingViewController.m
//  TFHealth
//
//  Created by chenzq on 14-7-16.
//  Copyright (c) 2014年 studio37. All rights reserved.
//

#import "HandRingViewController.h"
#import "UIViewController+MMDrawerController.h"
#import "HandringSleepViewController.h"
#import "MDRadialProgressView.h"
#import "MDRadialProgressTheme.h"
#import "MDRadialProgressLabel.h"
#import "GBFlatButton.h"
#import "UIColor+GBFlatButton.h"
#import "UIViewController+CWPopup.h"
#import "NTSlidingViewController.h"
#import "CXAlertView.h"
#import "SportCoefficient.h"
#import "UserCoreValues.h"
#import "AppDelegate.h"
#import "AppCloundService.h"
#import "PersonalSet.h"
#import "MBProgressHUD.h"
#import "DevicesPopupViewController.h"
#import "SportsRecordsViewController.h"

@interface HandRingViewController ()<MBProgressHUDDelegate>
{
    MBProgressHUD *HUD;
    BleCoreManager* bleCoreMgr;
    //NSTimer *showTimer;//计时器变量
    NSTimer *batterTimer;//电量计时器
    NSTimer *batterTimerLoop;
    Boolean batterTimeIsValid;
    Boolean isOnlineing;
}
-(void)handleScrollTimer:(NSTimer *)theTimer;
-(void)startTimer;

-(void)batterHandleTimer:(NSTimer *)batterTheTimer;
-(void)startBatterTimer;

- (IBAction)OnConnCoreAction:(id)sender;

- (IBAction)BackAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *items_container;
@property (weak, nonatomic) IBOutlet UIView *btn_sleep;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *btn_record;
- (IBAction)recordClicked:(id)sender;
- (IBAction)stepClicked:(id)sender;
- (IBAction)sportTimeClicked:(id)sender;
- (IBAction)kmClicked:(id)sender;
- (IBAction)CalorieClicked:(id)sender;

@property (weak, nonatomic) IBOutlet UIImageView *cur_img;
@property (weak, nonatomic) IBOutlet UILabel *cur_label;
@property (nonatomic, strong) AKPickerView *pickerView;
@property (nonatomic, strong) NSMutableArray *titles;
@property (weak, nonatomic) IBOutlet UIView *prcessView;
@property (nonatomic, retain) MDRadialProgressView *radialView;

@property (weak, nonatomic) IBOutlet UIImageView *stepImageView;
@property (weak, nonatomic) IBOutlet UIImageView *movetimeImageView;
@property (weak, nonatomic) IBOutlet UIImageView *kmImageView;
@property (weak, nonatomic) IBOutlet UIImageView *calorieImageView;

@property (weak, nonatomic) IBOutlet UIButton *stepTextView;
@property (weak, nonatomic) IBOutlet UIButton *moveTimeTextView;
@property (weak, nonatomic) IBOutlet UIButton *kmTextView;
@property (weak, nonatomic) IBOutlet UIButton *calorieTextView;
@property (weak, nonatomic) IBOutlet UIView *userBarView;
@property (weak, nonatomic) IBOutlet UIView *labelXlineView;
@property (assign, nonatomic) int clickIndex;
@property (assign, nonatomic) int goSleep;
@property (assign, nonatomic) bool isSyncing;
@property (assign,nonatomic) NSString* showName;
@property (weak, nonatomic) IBOutlet GBFlatButton *sleepModeButton;
@property (weak, nonatomic) IBOutlet UIButton *btnSelectState;
@property (weak, nonatomic) IBOutlet UIButton *btnBatteryValue;
- (IBAction)SetClicked:(id)sender;
- (IBAction)OtaClicked:(id)sender;

@end

@implementation HandRingViewController

@synthesize superview;
@synthesize recordview;
@synthesize selectedItem;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)BarreyClicked:(UITapGestureRecognizer*)sender {
    
    if (!self.btnSelectState.selected) {
        CXAlertView *alertViewMe = [[CXAlertView alloc] initWithTitle:CustomLocalizedString(@"tip", nil) message:CustomLocalizedString(@"ConBraceletFirst", nil) cancelButtonTitle:CustomLocalizedString(@"OK", nil)];
        
        [alertViewMe show];
    }
    else
    {
        [bleCoreMgr getBattery];
    }
}

-(void)updateDeviceStatus:(CoreStatus)status
{
    switch (status) {
        case CORE_STATUS_DISCONNECTED:
            self.btnSelectState.selected =false;
            NSLog(@"bleCore disconnected");
            batterTimeIsValid=true;
            if (_goSleep==1) {
                _goSleep=0;
                [self goSleepView];
            }
            break;
        case CORE_STATUS_CONNECTED:
            self.btnSelectState.selected=true;
            //HUD.labelText = @"已连接...";
            //sleep(2);
            //[bleCoreMgr getBattery];
            //[bleCoreMgr getHealthData];
            if (batterTimeIsValid) {
                batterTimeIsValid=false;
                //[self startBatterTimer];
                //HUD.labelText = @"获取电量...";
            }
            //[NSThread sleepForTimeInterval:3];
            //[bleCoreMgr getBattery];
            NSLog(@"bleCore connected");
            [self performSelectorOnMainThread:@selector(startTimer) withObject:nil waitUntilDone:YES];
            break;
        default:
            break;
    }
}

-(void)updateUITime
{
    isOnlineing=false;
    [self startBatterTimer];
    HUD.labelText = CustomLocalizedString(@"AcquisitionPower", nil);
    [HUD show:YES];
}

-(void)disError
{
    self.btnSelectState.selected =false;
    [HUD hide:YES];
}

-(void)updateFail
{
    [HUD hide:YES];
    _isSyncing=false;
}

-(void)updateYesOTA
{
    [bleCoreMgr otaUpdate];
    //[HUD hide:YES];
}

-(void)updateUIData:(WTYRestartDeviceCmd*)object
{
    
}

-(void)updateConnState
{
    
}

-(void)updateUIBattery:(WTYGetBattery *)object
{
    NSArray *bater = [object.battery componentsSeparatedByString:@":"];
    
    if (bater.count==2) {
        NSString *batt = [NSString stringWithFormat:@"电量%@%%",[bater objectAtIndex:1]];
        [_btnBatteryValue setTitle:batt forState:UIControlStateNormal];
    }
    [HUD hide:YES];
}

-(NSDate*)getCurrentDate
{
    NSDate *currentDate = [[NSDate alloc]init];
    NSDateFormatter *formate = [[NSDateFormatter alloc] init];
    [formate setDateFormat:@"yyyy-MM-dd"];
    NSString *string = [formate stringFromDate:currentDate];
    NSDate *paraDate = [formate dateFromString:string];
    return paraDate;
}

-(int)getUserHeightId:(NSString*)str
{
    AppDelegate *appdelegate =(AppDelegate*) [[UIApplication sharedApplication] delegate];
    if ([str isEqualToString:@"height"]) {
        return appdelegate.user.height.intValue;
    }
    else
    {
        return appdelegate.user.userId.intValue;
    }
}

-(UserCoreValues*)getUserCoreValues
{
    UserCoreValues *lastUserCoreValues = [UserCoreValues MR_findFirstWithPredicate:[NSPredicate predicateWithFormat:@"userId == %d AND createTime>=%@",[self getUserHeightId:@"id"],[self getCurrentDate]] inContext:[NSManagedObjectContext MR_defaultContext]];
    return lastUserCoreValues;
}

-(PersonalSet*)getPersonalSet
{
    //PersonalSet *personal = [PersonalSet MR_findFirstWithPredicate:[NSPredicate predicateWithFormat:@"userId == %d",[self getUserHeightId:@"id"]] inContext:[NSManagedObjectContext MR_defaultContext]];
    PersonalSet *personal = [PersonalSet MR_findFirstWithPredicate:[NSPredicate predicateWithFormat:@"userId == %d",[self getUserHeightId:@"id"]] sortedBy:@"startDate" ascending:NO];
    return personal;
}

-(int)getTargetStepCount
{
    PersonalSet *personal = [self getPersonalSet];
    if (personal!=nil) {
        return personal.stepTargetCount.intValue;
    }
    else
    {
        return 10000;
    }
}

-(int)getComplatedStepCount
{
    UserCoreValues *lastUserCoreValues=[self getUserCoreValues];
    if (lastUserCoreValues!=nil) {
        return lastUserCoreValues.stepCount.intValue;
    }
    else
    {
        return 0;
    }
}

-(void)updateUIStopSleep
{
}

-(void)updateUIStepInfo:(WTYHealthDataModel*)object
{
    UserCoreValues *lastUserCoreValues=[self getUserCoreValues];
    SportCoefficient *coefficient=nil;
    
    int curSetpCount = 0; //本次运动的真实步数，如用户先走了1000步，又跳了200步，指的是200步的数值
    int curCoreSetp=object.steps;  //本次手环取出来的步数
    int stepCount = curCoreSetp;  //计算后的总步数
    curSetpCount=curCoreSetp;
    
    float kmCount=object.distance;  //单位为cm
    
    int curcalorieValue = 0; //本次运动的真实卡路里，如用户先走路消耗了500卡，又跑步消耗了200卡，指的是200步的数值
    int curCoreCalorieValue=object.calories;  //本次手环取出来的卡路里  单位：卡
    int calorieValue=curCoreCalorieValue; //计算后的总卡路里数
    curcalorieValue=curCoreCalorieValue;
    
    int timeLenght=object.time;  //单位分钟
    if (selectedItem != nil && ![selectedItem isEqualToString:@""]) {
        coefficient = [SportCoefficient MR_findFirstByAttribute:@"itemName" withValue:selectedItem];
    }
    //如果当天已经有数据了
    if (lastUserCoreValues!=nil) {
        //这里处理步数  本次真实步数 = 本次取到的步数 - 上次的步数
        curSetpCount = curCoreSetp - lastUserCoreValues.lastCoreStep.intValue;
        //计算卡路里 本次真实卡路里 = 本次取到的卡路里 - 上次的卡路里
        curcalorieValue = curCoreCalorieValue - lastUserCoreValues.lastCalorieValue.intValue;
        if (curSetpCount<0) {
            curSetpCount=0;
        }
        if (curcalorieValue<0) {
            curcalorieValue=0;
        }
        if (curcalorieValue==0) {
            
        }
    }
    if (curSetpCount<=0) {   //这里有一个问题，比如用A手环已经跑了500步，又换成了B手环，如果用B手环跑了200步，那么程序也会自动返回，当B手环跑步大于500时，才会增值记录。
        [HUD hide:YES];
        _isSyncing=false;
        return;
    }
    if (coefficient!=nil) {
        //curSetpCount = curSetpCount>0?curSetpCount:curCoreSetp;
        //curcalorieValue = curcalorieValue >0? curcalorieValue:curCoreCalorieValue;
        
        NSLog(@"%@:%.1f",coefficient.itemName,coefficient.coefficientValue.floatValue);
        //计算步数
        stepCount = curSetpCount*coefficient.coefficientValue.floatValue;
        if (lastUserCoreValues!=nil) {
            stepCount+=lastUserCoreValues.stepCount.intValue;
        }
        //计算卡路里
        calorieValue = curcalorieValue * coefficient.coefficientValue.floatValue;
        if (lastUserCoreValues!=nil) {
            calorieValue += lastUserCoreValues.calorieValue.intValue;
        }
        kmCount = (stepCount*([self getUserHeightId:@"height"]-100)*coefficient.coefficientValue.floatValue)/100000;
    }
    [UIView animateWithDuration:0.1 animations:^{
        if ([_showName isEqualToString:@"时间"]) {
            [_radialView setText:[NSString stringWithFormat:@"%d分钟",timeLenght]];
        }
        else if ([_showName isEqualToString:@"公里"]) {
            [_radialView setText:[NSString stringWithFormat:@"%.1f公里",kmCount]];
        }
        else if ([_showName isEqualToString:@"卡路里"]) {
            [_radialView setText:[NSString stringWithFormat:@"%d千卡",calorieValue/1000]];
        }
        else {
            _radialView.progressCounter=stepCount;
            //[_radialView notifyProgressChange];
        }
        
        [self labelAtXLine:stepCount];
    }];
    if (lastUserCoreValues==nil) {
        lastUserCoreValues = [UserCoreValues MR_createEntity];
    }
    
    //这里应该先更新服务器，再保存本地
    int coreId =1;
    if (lastUserCoreValues.coreId.intValue!=0) {
        coreId=lastUserCoreValues.coreId.intValue;
    }
    else
    {
        UserCoreValues *v = [UserCoreValues MR_findFirstOrderedByAttribute:@"coreId" ascending:NO];
        if (v!=nil) {
            coreId=v.coreId.intValue+1;
        }
    }
    lastUserCoreValues.calorieValue =[NSNumber numberWithInt:calorieValue];
    lastUserCoreValues.stepCount = [NSNumber numberWithInt:stepCount];
    lastUserCoreValues.kmCount = [NSNumber numberWithFloat:kmCount];
    lastUserCoreValues.timeLenght = [NSNumber numberWithInt:timeLenght];
    
    lastUserCoreValues.lastCoreStep=[NSNumber numberWithInt:curCoreSetp];
    lastUserCoreValues.lastCalorieValue=[NSNumber numberWithInt:curCoreCalorieValue];
    lastUserCoreValues.userId = [NSNumber numberWithInt:[self getUserHeightId:@"id"]];
    lastUserCoreValues.createTime = [self getCurrentDate];
    lastUserCoreValues.coreId = [NSNumber numberWithInt:coreId];
    lastUserCoreValues.itemId = coefficient==nil?[NSNumber numberWithInt:1]:coefficient.itemId;
    lastUserCoreValues.itemName = coefficient==nil?@"健步走":coefficient.itemName;
    [[NSManagedObjectContext MR_defaultContext] MR_save];
    
    AppCloundService* s= [[AppCloundService alloc] initWidthDelegate:self];
    [s UploadUserCoreValue:lastUserCoreValues.userId.intValue ItemId:lastUserCoreValues.itemId.intValue ItemName:lastUserCoreValues.itemName StepCount:lastUserCoreValues.stepCount.intValue KmCount:kmCount CalorieValue:lastUserCoreValues.calorieValue.intValue TimeLenght:lastUserCoreValues.timeLenght.intValue SleepTimeCount:0 LastCoreStep:lastUserCoreValues.lastCoreStep.intValue LastCoreCalorieValue:lastUserCoreValues.lastCalorieValue.intValue CreateTime:[self getCurrentDate]];
    [HUD hide:YES];
    _isSyncing=false;
}

-(void)startTimer
{
    //定义时间计数器:每隔2秒执行一次handleScrollTimer方法
    /*showTimer = [NSTimer scheduledTimerWithTimeInterval:10.0
     target:self
     selector:@selector(handleScrollTimer:)
     userInfo:nil
     repeats:true];
     [[NSRunLoop currentRunLoop] addTimer:showTimer forMode:NSDefaultRunLoopMode];*/
}
/*
 -(void)handleScrollTimer:(NSTimer *)theTimer
 {
 [bleCoreMgr getHealthData];
 NSLog(@"%@",theTimer);
 }
 */
-(void)startBatterTimer
{
    //定义时间计数器:每隔2秒执行一次handleScrollTimer方法
    batterTimer = [NSTimer scheduledTimerWithTimeInterval:4.0
                                                   target:self
                                                 selector:@selector(batterHandleTimer:)
                                                 userInfo:nil
                                                  repeats:false];
    [[NSRunLoop currentRunLoop] addTimer:batterTimer forMode:NSDefaultRunLoopMode];
    
    
    batterTimerLoop = [NSTimer scheduledTimerWithTimeInterval:300.0
                                                       target:self
                                                     selector:@selector(batterHandleTimerLoop:)
                                                     userInfo:nil
                                                      repeats:true];
    [[NSRunLoop currentRunLoop] addTimer:batterTimerLoop forMode:NSDefaultRunLoopMode];
    
    
}

-(void)batterHandleTimer:(NSTimer *)batterTheTimer
{
    if (self.btnSelectState.selected) {
        [bleCoreMgr getBattery];
        NSLog(@"One:%@",batterTimer);
    }
}

-(void)batterHandleTimerLoop:(NSTimer *)batterTheTimer
{
    if (self.btnSelectState.selected) {
        [bleCoreMgr getBattery];
        NSLog(@"Loop:%@",batterTimerLoop);
    }
}

- (void)viewDidLoad
{
    //[showTimer setFireDate:[NSDate distantPast]];
    [batterTimer setFireDate:[NSDate distantPast]];
    [batterTimerLoop setFireDate:[NSDate distantPast]];
    
    batterTimeIsValid=true;
    isOnlineing=false;
    _goSleep=0;
    bleCoreMgr = [BleCoreManager sharedInstance];
    bleCoreMgr.delegate = self;
    
    _sleepModeButton.selected=YES;
    _clickIndex=1;
    self.pickerView = [[AKPickerView alloc] initWithFrame:self.items_container.bounds];
    self.pickerView.delegate = self;
    [self.items_container addSubview:self.pickerView];
    self.titles = [[NSMutableArray alloc]init];
    [self initItems];
    int x = self.prcessView.center.x;
    int y = 0;
    
    MDRadialProgressTheme *newTheme = [[MDRadialProgressTheme alloc] init];
    newTheme.completedColor = [UIColor colorWithRed:255/255.0 green:168/255.0 blue:0/255.0 alpha:1.0];
    newTheme.incompletedColor = [UIColor colorWithRed:252/255.0 green:216/255.0 blue:147/255.0 alpha:1.0];
    newTheme.centerColor = [UIColor clearColor];
    newTheme.centerColor = [UIColor colorWithRed:252/255.0 green:241/255.0 blue:218/255.0 alpha:1.0];
    newTheme.sliceDividerHidden = YES;
    newTheme.labelColor = [UIColor orangeColor];
    newTheme.labelShadowColor = [UIColor whiteColor];
    
    y += 40;
    
    
    int targetStepCount=[self getTargetStepCount];
    int complatedStepCount=[self getComplatedStepCount];
    
    CGRect frame = CGRectMake(self.prcessView.center.x-100, y, 180, 180);
    _radialView = [[MDRadialProgressView alloc] initWithFrame:frame andTheme:newTheme];
    _radialView.progressTotal = targetStepCount;
    _radialView.progressCounter = complatedStepCount;
    
    [self.prcessView addSubview:_radialView];
    
    y+=110;
    
    UILabel *label = [self labelAtY:y andText:[NSString stringWithFormat:@"%@%d%@",CustomLocalizedString(@"Target", nil),targetStepCount,CustomLocalizedString(@"Step", nil)]];
    label.textColor =[UIColor colorWithRed:255/255.0 green:168/255.0 blue:0/255.0 alpha:1.0];
    label.font = [UIFont fontWithName:@"Arial Rounded MT Bold" size:(16.0)];
    [self.prcessView addSubview:label];
    
    [_stepImageView setImage:[UIImage imageNamed:@"sm_orange_step"]];
    [_stepTextView setTitleColor:[UIColor colorWithRed:255/255.0 green:168/255.0 blue:0/255.0 alpha:1.0] forState:UIControlStateNormal];
    _radialView.userInteractionEnabled=YES;
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(processClicked:)];
    [_radialView addGestureRecognizer:singleTap];
    
    UITapGestureRecognizer *sleepModeTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sleepClicked:)];
    [_sleepModeButton addGestureRecognizer:sleepModeTap];
    
    UITapGestureRecognizer *connTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(OnConnCoreAction:)];
    [_btnSelectState addGestureRecognizer:connTap];
    
    UITapGestureRecognizer *batterTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(BarreyClicked:)];
    [_btnBatteryValue addGestureRecognizer:batterTap];
    
    //长按
    UILongPressGestureRecognizer *longPressGR = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressEvent:)];
    [_radialView addGestureRecognizer:longPressGR];
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initUI];
    
    [self labelAtXLine:complatedStepCount];  //这里的40需要修改为用户目标期内完成的步数
    
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    HUD.delegate = self;
    
    if ([bleCoreMgr getStatus]== CORE_STATUS_DISCONNECTED) {
        [bleCoreMgr scan];
        isOnlineing=true;
        [self performSelector:@selector(quitConnection) withObject:nil afterDelay:30.0f];
        [self showWithLabelMixed];
    }
    else
    {
        self.btnSelectState.selected=true;
        [self updateUITime];
    }
    
    _isSyncing=false;
    //[HUD hide:YES];
}

-(void)quitConnection
{
    if (isOnlineing) {
        [HUD hide:YES];
    }
}

-(void) initItems
{
    self.pickerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    /*
    NSArray *items = [SportCoefficient MR_findAll];
    if (items.count>0) {
        [self loadPicker:items];
    }
    else  //当本地没有数据时联网获取
    {
        AppCloundService* s= [[AppCloundService alloc] initWidthDelegate:self];
//        [s GetCoefficients];
        AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
        if (appDelegate.languageIndex == 1) {//英文
            [s languageGetCoefficientsJson:2];
        } else {
            [s languageGetCoefficientsJson:1];
        }
        
    }
     */
    AppCloundService* s= [[AppCloundService alloc] initWidthDelegate:self];
    //        [s GetCoefficients];
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    if (appDelegate.languageIndex == 1) {//英文
        [s languageGetCoefficientsJson:2];
    } else {
        [s languageGetCoefficientsJson:1];
    }
}

-(void)loadPicker:(NSArray*)items
{
    int i =0;
    int curIndex =0;
    for (SportCoefficient *item in items) {
        if ([item.itemName isEqualToString:@"健步走"]) {
            curIndex=i;
        }
        [self.titles addObject:item.itemName];
        i++;
    }
    [self.pickerView reloadData];
    if (self.titles.count>0) {
        [self.pickerView selectItem:curIndex animated:YES];
        [self.pickerView scrollToItem:curIndex animated:YES];
    }
}

-(void)serviceSuccessed:(NSDictionary*)keyValues pMethod:(NSString*)method
{
    if ([method isEqualToString:@"UpdateUserCoreValueJson"]) {
        //上传手环运动完成
        //[self AddUser:keyValues];
        NSLog(@"上传手环运动记录完成");
        NSInteger res = [[keyValues objectForKey:@"res"] integerValue];
        NSLog(@"res=%d",res);
    }
    else if(keyValues.count>0 )
    {
        NSMutableArray *items = [NSMutableArray arrayWithArray:[SportCoefficient MR_findAll]];
        if (items.count>0) {
            for (NSDictionary *dict in keyValues)  {
                for (SportCoefficient *coefficient in items) {
                    if (coefficient.itemId.integerValue == [[dict objectForKey:@"sportId"] integerValue]) {
                        coefficient.itemName =[dict objectForKey:@"sportName"];
                        coefficient.coefficientValue =[dict objectForKey:@"coefficientValue"];
                        [[NSManagedObjectContext MR_defaultContext] MR_save];
                    }
                }
            }
        } else {
            for (NSDictionary *dict in keyValues) {
                
                SportCoefficient *coefficient = [SportCoefficient MR_createEntity];
                coefficient.itemId=[dict objectForKey:@"sportId"];
                coefficient.itemName =[dict objectForKey:@"sportName"];
                coefficient.coefficientValue =[dict objectForKey:@"coefficientValue"];
                [[NSManagedObjectContext MR_defaultContext] MR_save];
                [items addObject:coefficient];
            }

        }
        
        [self loadPicker:items];
    }
}

-(void)serviceFailed:(NSString*) message pMethod:(NSString*)method
{
    
}


- (UILabel *)labelAtY:(CGFloat)y andText:(NSString *)text
{
    CGRect frame = CGRectMake(0, y, self.prcessView.frame.size.width, 40);
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.text = text;
    label.textColor = [UIColor whiteColor];
    label.numberOfLines = 0;
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [label.font fontWithSize:14];
    
    return label;
}

-(void) labelAtXLine:(float)x
{
    for(UIView *view in [self.labelXlineView subviews])
    {
        if (view.tag!=1) {
            [view removeFromSuperview];
        }
    }
    int targetStep=[self getTargetStepCount]; //这里的步数需要从用户设定的目标中取得
    int xBaseWidth=x>targetStep?x:targetStep;
    UIColor *bgColor = [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:0.7];
    float y = self.userBarView.frame.origin.y;
    
    float line_x = self.userBarView.frame.origin.x;
    float line_width = self.userBarView.frame.size.width;
    float xDensity=xBaseWidth/line_width;
    
    UIView *dotfirst =[[ UIView alloc]initWithFrame:CGRectMake(line_x-5,y-3,8,8)];
    dotfirst.layer.masksToBounds = YES;
    dotfirst.layer.cornerRadius = 4.0;
    dotfirst.layer.backgroundColor=[bgColor CGColor];
    [self.labelXlineView addSubview:dotfirst];
    
    UILabel *labelfirst = [[ UILabel alloc]initWithFrame:CGRectMake(line_x-9                                      ,y+3,40,20)];
    labelfirst.text = [NSString stringWithFormat:@"0%@",CustomLocalizedString(@"Step", nil)];
    labelfirst.font=[UIFont fontWithName:@"Helvetica" size:10];
    labelfirst.textColor=[UIColor whiteColor];
    [self.labelXlineView addSubview:labelfirst];
    
    
    UIView *dotlast =[[ UIView alloc]initWithFrame:CGRectMake(line_x+targetStep/xDensity-3,y-3,8,8)];
    dotlast.layer.masksToBounds = YES;
    dotlast.layer.cornerRadius = 4.0;
    dotlast.layer.backgroundColor=[bgColor CGColor];
    [self.labelXlineView addSubview:dotlast];
    
    UILabel *labellast = [[ UILabel alloc]initWithFrame:CGRectMake(line_x+targetStep/xDensity-30-5,y+3,45,20)];
    labellast.text = [NSString stringWithFormat:@"%d%@",targetStep,CustomLocalizedString(@"Step", nil)]; //这里需要注意如果用户实际行走的步数大于目标的显示情况
    labellast.font=[UIFont fontWithName:@"Helvetica" size:10];
    labellast.textColor=[UIColor whiteColor];
    [self.labelXlineView addSubview:labellast];
    
    UIView *dot =[[ UIView alloc]initWithFrame:CGRectMake(x/xDensity+5,y-3,8,8)];
    dot.layer.masksToBounds = YES;
    dot.layer.cornerRadius = 4.0;
    dot.layer.backgroundColor=[bgColor CGColor];
    [self.labelXlineView addSubview:dot];
    
    UIView *line =[[ UIView alloc]initWithFrame:CGRectMake(x/xDensity+8,y-15,2,12)];
    line.layer.masksToBounds = YES;
    line.layer.cornerRadius = 1.0;
    line.layer.backgroundColor=[bgColor CGColor];
    [self.labelXlineView addSubview:line];
    
    UIView *clrice =[[ UIView alloc]initWithFrame:CGRectMake(x/xDensity-5,y-45,30,30)];
    clrice.layer.masksToBounds = YES;
    clrice.layer.cornerRadius = 15.0;
    clrice.layer.borderWidth=2;
    clrice.layer.backgroundColor=[UIColor clearColor].CGColor;
    clrice.layer.borderColor=[bgColor CGColor];
    [self.labelXlineView addSubview:clrice];
    
    UILabel *label = [[ UILabel alloc]initWithFrame:CGRectMake(x/xDensity+1,y-43,20,25)];
    label.text = @"you";
    label.font=[UIFont fontWithName:@"Helvetica" size:10];
    label.textColor=[UIColor whiteColor];
    [self.labelXlineView addSubview:label];
    
    UILabel *labelValue = [[ UILabel alloc]initWithFrame:CGRectMake(x/xDensity+1,y+3,40,20)];
    labelValue.text = [NSString stringWithFormat:@"%.f%@",x,CustomLocalizedString(@"Step", nil)];
    labelValue.font=[UIFont fontWithName:@"Helvetica" size:10];
    labelValue.textColor=[UIColor whiteColor];
    [self.labelXlineView addSubview:labelValue];
    
}

-(void)initUI
{
    UIColor *borderColor = [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:0.2];
    _items_container.layer.masksToBounds = YES;
    _items_container.layer.backgroundColor=[borderColor CGColor];
    
    UIColor *borderColor1 = [UIColor colorWithHue:0.55 saturation:0.8 brightness:0.9 alpha:0.7];
    _userBarView.layer.masksToBounds = YES;
    _userBarView.layer.cornerRadius = 1.0;
    _userBarView.layer.backgroundColor=[borderColor1 CGColor];
}

- (NSUInteger)numberOfItemsInPickerView:(AKPickerView *)pickerView
{
    return [self.titles count];
}

- (NSString *)pickerView:(AKPickerView *)pickerView titleForItem:(NSInteger)item
{
    return self.titles[item];
}

- (void)pickerView:(AKPickerView *)pickerView didSelectItem:(NSInteger)item
{
    NSLog(@"%@", self.titles[item]);
    
    selectedItem =self.titles[item];
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

- (void)OnConnCoreAction:(UITapGestureRecognizer*)sender {
    if(self.btnSelectState.selected)
    {
        CXAlertView *alertViewMe = [[CXAlertView alloc] initWithTitle:CustomLocalizedString(@"tip", nil) message:CustomLocalizedString(@"DisconBra", nil) cancelButtonTitle:nil];
        
        // This is a demo for multiple line of title.
        [alertViewMe addButtonWithTitle:CustomLocalizedString(@"yes", nil)
                                   type:CXAlertViewButtonTypeDefault
                                handler:^(CXAlertView *alertView, CXAlertButtonItem *button) {
                                    [alertView dismiss];
                                    [bleCoreMgr disConnection];
                                }];
        
        [alertViewMe addButtonWithTitle:CustomLocalizedString(@"cancel", nil)
                                   type:CXAlertViewButtonTypeCancel
                                handler:^(CXAlertView *alertView, CXAlertButtonItem *button) {
                                    [alertView dismiss];
                                }];
        
        [alertViewMe show];
    }
    else
    {
        [bleCoreMgr scan];
        isOnlineing=true;
        [self performSelector:@selector(quitConnection) withObject:nil afterDelay:30.0f];
        [self showWithLabelMixed];
    }
}

- (IBAction)BackAction:(id)sender {
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}
- (IBAction)recordClicked:(id)sender {
}

- (void)sleepClicked:(UITapGestureRecognizer*)sender {
    /*if (self.btnSelectState.selected) {
     CXAlertView *alertViewMe = [[CXAlertView alloc] initWithTitle:@"消息" message:@"请先断开与手环的连接，才能切换睡眠模式．" cancelButtonTitle:@"好"];
     
     [alertViewMe show];
     return;
     }*/
    if (self.btnSelectState.selected) {
        _goSleep=1;
        [bleCoreMgr disConnection];
    }
    else
    {
        [self goSleepView];
    }
}

-(void)goSleepView
{
    //[showTimer setFireDate:[NSDate distantFuture]];
    HandringSleepViewController * his = [self.storyboard instantiateViewControllerWithIdentifier:@"HandringSleepViewController"];
    NTSlidingViewController *uv = (NTSlidingViewController *)superview;
    [uv setIndexText:1 txt:CustomLocalizedString(@"Sleep", nil)];
    his.superview=self.superview;
    his.recordview=recordview;
    [recordview initChart];
    [self presentPopupViewController:his animated:true completion:nil];
}

-(int)updateComplated:(NSString*)t
{
    UserCoreValues *lastUserCoreValues=[self getUserCoreValues];
    if (lastUserCoreValues!=nil) {
        if ([t isEqualToString:CustomLocalizedString(@"calories", nil)]) {
            [_radialView setText:[NSString stringWithFormat:@"%d%@",lastUserCoreValues.calorieValue.intValue/1000,CustomLocalizedString(@"Kcalories", nil) ]];
        }
        else if([t isEqualToString:CustomLocalizedString(@"Time", nil)])
        {
            [_radialView setText:[NSString stringWithFormat:@"%d%@",lastUserCoreValues.timeLenght.intValue,CustomLocalizedString(@"Minute", nil) ]];
        }
        else if([t isEqualToString:CustomLocalizedString(@"kilometre", nil)])
        {
            [_radialView setText:[NSString stringWithFormat:@"%.1f%@",lastUserCoreValues.kmCount.floatValue,CustomLocalizedString(@"kilometre", nil) ]];
        }
    }
    else
    {
        if ([t isEqualToString:CustomLocalizedString(@"calories", nil)]) {
            [_radialView setText:[NSString stringWithFormat:@"0%@",CustomLocalizedString(@"calories", nil)]];
        }
        else if([t isEqualToString:CustomLocalizedString(@"Time", nil)])
        {
            [_radialView setText:[NSString stringWithFormat:@"0%@",CustomLocalizedString(@"Time", nil)]];
        }
        else if([t isEqualToString:CustomLocalizedString(@"kilometre", nil)])
        {
            [_radialView setText:[NSString stringWithFormat:@"0%@",CustomLocalizedString(@"kilometre", nil)]];
        }
    }
}

- (void)longPressEvent:(UILongPressGestureRecognizer*)sender {
    if (_isSyncing) {
        return;
    }
    _isSyncing=true;
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    
    HUD.delegate = self;
    HUD.labelText = CustomLocalizedString(@"BeingSynchronized", nil);
    [HUD show:YES];
    //[HUD showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
    [bleCoreMgr getHealthData];
}

- (void)myTask {
    // Do something usefull in here instead of sleeping ...
    sleep(5);
}

-(void)processClicked:(UITapGestureRecognizer *)sender
{
    if (_clickIndex==1) {
        [self sportTimeClicked:nil];
    }
    else if (_clickIndex==2) {
        [self kmClicked:nil];
    }
    else if (_clickIndex==3) {
        [self CalorieClicked:nil];
    }
    else if (_clickIndex==4) {
        [self stepClicked:nil];
    }
}

- (IBAction)stepClicked:(id)sender {
    _clickIndex=1;
    [_radialView notifyProgressChange];
    [self defaultBtnStyle];
    [_stepImageView setImage:[UIImage imageNamed:@"sm_orange_step"]];
    [_stepTextView setTitleColor:[UIColor colorWithRed:255/255.0 green:168/255.0 blue:0/255.0 alpha:1.0] forState:UIControlStateNormal];
    _showName=CustomLocalizedString(@"Steps", nil);
    //[bleCoreMgr getHealthData];
    
    //_cur_img.image = [UIImage imageNamed:@"orange_step"];
    //_cur_label.text=@"800步";
}

- (IBAction)sportTimeClicked:(id)sender {
    _clickIndex=2;
    [self defaultBtnStyle];
    [self updateComplated:CustomLocalizedString(@"Time", nil)];
    [_movetimeImageView setImage:[UIImage imageNamed:@"sm_orange_movetime"]];
    [_moveTimeTextView setTitleColor:[UIColor colorWithRed:255/255.0 green:168/255.0 blue:0/255.0 alpha:1.0] forState:UIControlStateNormal];
    _showName=CustomLocalizedString(@"Time", nil);
    //[bleCoreMgr getHealthData];
    //_cur_img.image = [UIImage imageNamed:@"orange_movetime"];
    //_cur_label.text=@"35分钟";
}

- (IBAction)kmClicked:(id)sender {
    _clickIndex=3;
    [self defaultBtnStyle];
    [self updateComplated:CustomLocalizedString(@"kilometre", nil)];
    [_kmImageView setImage:[UIImage imageNamed:@"sm_orange_km"]];
    [_kmTextView setTitleColor:[UIColor colorWithRed:255/255.0 green:168/255.0 blue:0/255.0 alpha:1.0] forState:UIControlStateNormal];
    _showName=CustomLocalizedString(@"kilometre", nil);
    //[bleCoreMgr getHealthData];
    //_cur_img.image = [UIImage imageNamed:@"orange_km"];
    //_cur_label.text=@"4.2公里";
}

- (IBAction)CalorieClicked:(id)sender {
    _clickIndex=4;
    [self defaultBtnStyle];
    [self updateComplated:CustomLocalizedString(@"calories", nil)];
    [_calorieImageView setImage:[UIImage imageNamed:@"sm_orange_calorie"]];
    [_calorieTextView setTitleColor:[UIColor colorWithRed:255/255.0 green:168/255.0 blue:0/255.0 alpha:1.0] forState:UIControlStateNormal];
    _showName=CustomLocalizedString(@"calories", nil);
    //[bleCoreMgr getHealthData];
    //_cur_img.image = [UIImage imageNamed:@"orange_calorie"];
    //_cur_label.text=@"580卡路里";
}

-(void)defaultBtnStyle
{
    NSArray *images = [[NSArray alloc] initWithObjects:_stepImageView,_movetimeImageView,_kmImageView,_calorieImageView,nil];
    NSArray *texts = [[NSArray alloc] initWithObjects:_stepTextView,_moveTimeTextView,_kmTextView,_calorieTextView,nil];
    NSArray *imgs = [[NSArray alloc] initWithObjects:@"white_step",@"white_movetime",@"white_km",@"white_calorie", nil];
    for (int i=0; i<4; i++) {
        UIImageView *img=[images objectAtIndex:i];
        UIButton *btns = [texts objectAtIndex:i];
        [btns setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [img setImage:[UIImage imageNamed:[imgs objectAtIndex:i]]];
    }
}

-(void)viewDidDisappear:(BOOL)animated
{
    if (self.btnSelectState.selected) {
        //[bleCoreMgr disConnection];
        //sleep(2);
    }
    //关闭定时器
    //[showTimer setFireDate:[NSDate distantFuture]];
    [batterTimer setFireDate:[NSDate distantFuture]];
    [batterTimerLoop setFireDate:[NSDate distantFuture]];
}
- (IBAction)SetClicked:(id)sender {
    
    DevicesPopupViewController* v = [self.storyboard instantiateViewControllerWithIdentifier:@"DevicesPopupViewController"];
    
    [self presentPopupViewController:v animated:true completion:^(void){
        //[v setTips:tips];
        [v setOwener:self];
    }];
}

- (IBAction)OtaClicked:(id)sender {
    //[HUD show:YES];
    CXAlertView *alertViewMe = [[CXAlertView alloc] initWithTitle:CustomLocalizedString(@"tip", nil) message:CustomLocalizedString(@"UpdateFirmware", nil) cancelButtonTitle:nil];
    
    // This is a demo for multiple line of title.
    [alertViewMe addButtonWithTitle:CustomLocalizedString(@"yes", nil)
                               type:CXAlertViewButtonTypeDefault
                            handler:^(CXAlertView *alertView, CXAlertButtonItem *button) {
                                [alertView dismiss];
                                [bleCoreMgr setOtaMode];
                            }];
    
    [alertViewMe addButtonWithTitle:CustomLocalizedString(@"cancel", nil)
                               type:CXAlertViewButtonTypeCancel
                            handler:^(CXAlertView *alertView, CXAlertButtonItem *button) {
                                [alertView dismiss];
                            }];
    
    [alertViewMe show];
}

- (void)showWithLabelMixed {
    
    HUD.labelText = CustomLocalizedString(@"Connecting", nil);
    HUD.minSize = CGSizeMake(84.f, 84.f);
    [HUD show:YES];
    //[HUD showWhileExecuting:@selector(myMixedTask) onTarget:self withObject:nil animated:YES];
}

- (void)myMixedTask {
    // Indeterminate mode
    sleep(2);
    // Switch to determinate mode
    HUD.mode = MBProgressHUDModeDeterminate;
    HUD.labelText = @"Progress";
    float progress = 0.0f;
    while (progress < 1.0f)
    {
        progress += 0.01f;
        HUD.progress = progress;
        usleep(50000);
    }
    // Back to indeterminate mode
    HUD.mode = MBProgressHUDModeIndeterminate;
    HUD.labelText = @"Cleaning up";
    sleep(2);
    // UIImageView is a UIKit class, we have to initialize it on the main thread
    __block UIImageView *imageView;
    dispatch_sync(dispatch_get_main_queue(), ^{
        UIImage *image = [UIImage imageNamed:@"37x-Checkmark.png"];
        imageView = [[UIImageView alloc] initWithImage:image];
    });
    //HUD.customView = [imageView autorelease];
    HUD.mode = MBProgressHUDModeCustomView;
    HUD.labelText = @"Completed";
    sleep(2);
}

@end
