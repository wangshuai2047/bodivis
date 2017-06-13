//
//  HandringSleepViewController.m
//  TFHealth
//
//  Created by chenzq on 14-7-27.
//  Copyright (c) 2014年 studio37. All rights reserved.
//

#import "HandringSleepViewController.h"
#import "MDRadialProgressView.h"
#import "MDRadialProgressTheme.h"
#import "MDRadialProgressLabel.h"
#import "GBFlatButton.h"
#import "UIColor+GBFlatButton.h"
#import "NTSlidingViewController.h"
#import "HandRingViewController.h"
#import "UIViewController+CWPopup.h"
#import "CXAlertView.h"
#import "PersonalSet.h"
#import "AppDelegate.h"
#import "MBProgressHUD.h"
#import "UserCoreValues.h"

@interface HandringSleepViewController ()
{
    MBProgressHUD *HUD;
    BleCoreManager* bleCoreMgr;
    //NSTimer *showTimer;//计时器变量
    NSTimer *deviceTimer;//电量计时器
    NSTimer *batterTimer;//电量计时器
    
    NSTimer *batterTimerLoop;
    Boolean batterTimeIsValid;
    Boolean isRuning;
    Boolean isUNline;
    Boolean isSyncing;
    Boolean isOnlineing;
}
- (IBAction)backupClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *processView;
@property (nonatomic, retain) MDRadialProgressView *radialView;
@property (weak, nonatomic) IBOutlet GBFlatButton *sportModeButton;
@property (weak, nonatomic) IBOutlet GBFlatButton *sleepButton;
@property (weak, nonatomic) IBOutlet UIButton *onconnButton;
@property (weak, nonatomic) IBOutlet UIButton *batterButton;
@property (assign, nonatomic) int goSleep;
@property (assign, nonatomic) float curSleepCount;
@property (weak, nonatomic) IBOutlet UILabel *sleepTotal;
-(void)handleScrollTimer:(NSTimer *)theTimer;
-(void)startTimer;

-(void)batterHandleTimer:(NSTimer *)batterTheTimer;
-(void)startBatterTimer;
@end

@implementation HandringSleepViewController

@synthesize superview;
@synthesize recordview;

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
    isOnlineing=false;
    isRuning=false;
    //[showTimer setFireDate:[NSDate distantPast]];
    [batterTimer setFireDate:[NSDate distantPast]];
    [batterTimerLoop setFireDate:[NSDate distantPast]];
    
    batterTimeIsValid=true;
    isUNline=false;
    isSyncing=false;
    
    _goSleep=0;
    bleCoreMgr = [BleCoreManager sharedInstance] ;
    bleCoreMgr.delegate = self;
    
    _sportModeButton.selected=YES;
    int x = self.processView.center.x;
    int y = 0;
    
    //UILabel *label = [self labelAtY:y andText:@"睡眠时间7.5小时，已完成0%！"];
    //[self.processView addSubview:label];
    
    UserCoreValues *lastUserCoreValues=[self getUserCoreValues];
    
    float targetSleepTime = [self getTargetSleepCount];
    MDRadialProgressTheme *newTheme = [[MDRadialProgressTheme alloc] init];
    newTheme.completedColor = [UIColor colorWithRed:255/255.0 green:168/255.0 blue:0/255.0 alpha:1.0];
    newTheme.incompletedColor = [UIColor colorWithRed:252/255.0 green:216/255.0 blue:147/255.0 alpha:1.0];
    newTheme.centerColor = [UIColor clearColor];
    newTheme.centerColor = [UIColor colorWithRed:252/255.0 green:241/255.0 blue:218/255.0 alpha:1.0];
    newTheme.sliceDividerHidden = YES;
    newTheme.labelColor = [UIColor orangeColor];
    newTheme.labelShadowColor = [UIColor whiteColor];
    
    y += 60;
    
    if (lastUserCoreValues!=nil) {
        _curSleepCount=lastUserCoreValues.sleepTimeCount.floatValue/60+lastUserCoreValues.lightSleepCount.floatValue/60;
        [_sleepTotal setText:[NSString stringWithFormat:@"深睡%.1f小时   浅睡%.1f小时",lastUserCoreValues.sleepTimeCount.floatValue/60,lastUserCoreValues.lightSleepCount.floatValue/60]];
    }
    if (_curSleepCount==0) {
        _curSleepCount=0.02;
    }
    CGRect frame = CGRectMake(self.processView.center.x-105, y, 190, 190);
    _radialView = [[MDRadialProgressView alloc] initWithFrame:frame andTheme:newTheme];
    _radialView.progressTotal = targetSleepTime*60;
    _radialView.progressCounter = _curSleepCount*60;
    _radialView.textFormat=@"%.1f小时";
    [self.processView addSubview:_radialView];
    
    
    [_radialView setText:[NSString stringWithFormat:@"%.1f小时",_curSleepCount]];
    
    
    y += 110;
    UILabel *label = [self labelAtY:y andText:[NSString stringWithFormat:@"目标%.1f小时",targetSleepTime]];
    label.textColor =[UIColor colorWithRed:255/255.0 green:168/255.0 blue:0/255.0 alpha:1.0];
    label.font = [UIFont fontWithName:@"Arial Rounded MT Bold" size:(16.0)];
    [self.processView addSubview:label];
    
    _radialView.userInteractionEnabled=YES;
    
    //UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(timeClicked:)];
    //[_radialView addGestureRecognizer:singleTap];
    
    UITapGestureRecognizer *batterTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(BatterOnClicked:)];
    [_batterButton addGestureRecognizer:batterTap];
    
    UITapGestureRecognizer *sleepTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(SleepOnClicked:)];
    [_sleepButton addGestureRecognizer:sleepTap];
    
    UITapGestureRecognizer *connTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ConnOnClicked:)];
    [_onconnButton addGestureRecognizer:connTap];
    
    UITapGestureRecognizer *sportModeTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sportClicked:)];
    [_sportModeButton addGestureRecognizer:sportModeTap];
    
    UILongPressGestureRecognizer *longPressGR = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressEvent:)];
    [_radialView addGestureRecognizer:longPressGR];
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
        self.onconnButton.selected=true;
        [self updateUITime];
    }
}

-(void)quitConnection
{
    if (isOnlineing) {
        [HUD hide:YES];
    }
}

- (void)longPressEvent:(UILongPressGestureRecognizer*)sender {
    if (isSyncing) {
        return;
    }
    isSyncing=true;
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    
    HUD.delegate = self;
    HUD.labelText = @"正在同步";
    [HUD show:YES];
    //[HUD showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
    [bleCoreMgr getSleepInfo];
}

-(void)handleScrollTimer:(NSTimer *)theTimer
{
    [bleCoreMgr getSleepInfo];
    NSLog(@"%@",theTimer);
}

-(void)startBatterTimer
{
    //定义时间计数器:每隔2秒执行一次handleScrollTimer方法
    batterTimer = [NSTimer scheduledTimerWithTimeInterval:3.0
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
    if (self.onconnButton.selected) {
        [bleCoreMgr getBattery];
        NSLog(@"One:%@",batterTimer);
    }
}

-(void)batterHandleTimerLoop:(NSTimer *)batterTheTimer
{
    if (self.onconnButton.selected) {
        [bleCoreMgr getBattery];
        NSLog(@"Loop:%@",batterTimerLoop);
    }
}


-(void)startDeviceTimer
{
    //定义时间计数器:每隔2秒执行一次handleScrollTimer方法
    deviceTimer = [NSTimer scheduledTimerWithTimeInterval:4.0
                                                   target:self
                                                 selector:@selector(deviceHandleTimer:)
                                                 userInfo:nil
                                                  repeats:false];
    [[NSRunLoop currentRunLoop] addTimer:deviceTimer forMode:NSDefaultRunLoopMode];
}
-(void)deviceHandleTimer:(NSTimer *)theTimer
{
    if (self.onconnButton.selected) {
        [bleCoreMgr getDeviceStatus];
        NSLog(@"get device status");
    }
}

-(void)updateCoreStatue:(WTYGetDeviceStatus*)object
{
    NSLog(@"获取状态完成");
    HUD.labelText = @"获取电量...";
    [self startBatterTimer];
    if(object.status==1)
    {
        self.sleepButton.selected=true;
    }
    else
    {
        self.sleepButton.selected=false;
    }
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

-(PersonalSet*)getPersonalSet
{
    //PersonalSet *personal = [PersonalSet MR_findFirstWithPredicate:[NSPredicate predicateWithFormat:@"userId == %d",[self getUserHeightId:@"id"]] inContext:[NSManagedObjectContext MR_defaultContext]];
    PersonalSet *personal = [PersonalSet MR_findFirstWithPredicate:[NSPredicate predicateWithFormat:@"userId == %d",[self getUserHeightId:@"id"]] sortedBy:@"startDate" ascending:NO];
    return personal;
}

-(float)getTargetSleepCount
{
    PersonalSet *personal = [self getPersonalSet];
    if (personal!=nil) {
        return personal.sleepTimeLength.floatValue;
    }
    else
    {
        return 7.5;
    }
}

-(void)disError
{
    self.onconnButton.selected =false;
    [HUD hide:YES];
}

-(void)BatterOnClicked:(UITapGestureRecognizer *)sender
{
    if (!self.onconnButton.selected) {
        CXAlertView *alertViewMe = [[CXAlertView alloc] initWithTitle:@"消息" message:@"请先连接手环，才能获取电量信息．" cancelButtonTitle:@"好"];
        
        [alertViewMe show];
    }
    else
    {
        [bleCoreMgr getBattery];
    }
}

-(void)updateSleepTime:(WTYGetSleepInfoModel*)object
{
    UserCoreValues *lastUserCoreValues=[self getUserCoreValues];
    NSMutableString *info = [[NSMutableString alloc]init];
    int sleepTimeLenght = 0;
    int lightSleepCount=0;
    int soberSleepCount=0;
    for (int j = 0; j < object.sleepInfo.count; j ++) {
        WTYPerSleepInfoModel *perModel = [object.sleepInfo objectAtIndex:j];
        if (perModel.sleepStatus ==1 ) {
            soberSleepCount+=perModel.totalMins;
        }
        else if(perModel.sleepStatus==3)
        {
            lightSleepCount+=perModel.totalMins;
        }
        else if(perModel.sleepStatus==4)
        {
            sleepTimeLenght+=perModel.totalMins;
        }
        //NSString *s = [NSString stringWithFormat:@" sleep status:%d, sleep time:%d", perModel.sleepStatus, perModel.totalMins]; //sleepStatus:1为清醒，2为混乱，3为浅睡，4为深睡
        //[info appendString:s];
    }
    //这里需要按日期区分数据
    NSString *string = [NSString stringWithFormat:@" %@, %@", object.date, info];//date 会不准，最好startSleep 时自己记下开始睡眠的时间；
    //_curSleepCount = (float)soberSleepCount/60+(float)lightSleepCount/60+(float)sleepTimeLenght/60;
    _curSleepCount = (float)lightSleepCount/60+(float)sleepTimeLenght/60;
    
    float _deepSleepCount = (float)sleepTimeLenght/60;
    float _lightSleepCount = (float)lightSleepCount/60;
    float _soberSleepCount=(float)soberSleepCount/60;
    
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
    lastUserCoreValues.userId = [NSNumber numberWithInt:[self getUserHeightId:@"id"]];
    if (lastUserCoreValues.createTime == nil) {
        lastUserCoreValues.createTime = [self getCurrentDate];
    }
    lastUserCoreValues.sleepTimeCount=[NSNumber numberWithInt:sleepTimeLenght];
    lastUserCoreValues.lightSleepCount=[NSNumber numberWithInt:lightSleepCount];
    lastUserCoreValues.soberSleepCount=[NSNumber numberWithInt:soberSleepCount];
    lastUserCoreValues.coreId = [NSNumber numberWithInt:coreId];

    if (_curSleepCount==0) {
        _curSleepCount=0.02;
    }
    [[NSManagedObjectContext MR_defaultContext] MR_save];
    self.radialView.progressCounter = _curSleepCount*60;
    [_sleepTotal setText:[NSString stringWithFormat:@"深睡%.1f小时   浅睡%.1f小时",_deepSleepCount,_lightSleepCount]];
    
    [UIView animateWithDuration:0.2 animations:^{
        [self.radialView setText:[NSString stringWithFormat:@"%.1f小时",_curSleepCount]];  //这里更新为什么不好使，不能立即显示？？？
    }];
    
    if (isUNline) {
        //HUD.labelText = @"正在断开...";
        //[bleCoreMgr stopSleep];
    }
    else
    {
        [HUD hide:YES];
    }
    isUNline=false;
    isSyncing=false;
}

-(UserCoreValues*)getUserCoreValues
{
    UserCoreValues *lastUserCoreValues = [UserCoreValues MR_findFirstWithPredicate:[NSPredicate predicateWithFormat:@"userId == %d AND createTime>=%@",[self getUserHeightId:@"id"],[self getCurrentDate]] inContext:[NSManagedObjectContext MR_defaultContext]];
    return lastUserCoreValues;
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

-(void)timeClicked:(UITapGestureRecognizer *)sender
{
    if (!self.onconnButton.selected) {
        CXAlertView *alertViewMe = [[CXAlertView alloc] initWithTitle:@"消息" message:@"您需要先连接手环才能读取睡眠信息．" cancelButtonTitle:@"好"];
        
        [alertViewMe show];
    }
    else
    {
        [bleCoreMgr getSleepInfo];
    }
}

-(void)updateDeviceStatus:(CoreStatus)status
{
    switch (status) {
        case CORE_STATUS_DISCONNECTED:
            self.onconnButton.selected =false;
            //[showTimer setFireDate:[NSDate distantFuture]];
            batterTimeIsValid=true;
            NSLog(@"bleCore disconnected");
            if (_goSleep==1) {
                _goSleep=0;
                [self goSleepView];
            }
            break;
        case CORE_STATUS_CONNECTED:
            self.onconnButton.selected=true;
            if (batterTimeIsValid&&!isRuning) {
                isRuning=true;
                //[self startDeviceTimer];
                //HUD.labelText = @"获取状态...";
            }
            NSLog(@"bleCore connected");
            //[showTimer setFireDate:[NSDate distantPast]];
            break;
        default:
            break;
    }
}

- (UILabel *)labelAtY:(CGFloat)y andText:(NSString *)text
{
    CGRect frame = CGRectMake(0, y, self.processView.frame.size.width, 60);
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.text = text;
    label.textColor = [UIColor whiteColor];
    label.numberOfLines = 0;
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [label.font fontWithSize:14];
    
    return label;
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

- (void)sportClicked:(UITapGestureRecognizer*)sender {
    
    if (self.onconnButton.selected) {
        _goSleep=1;
        if (self.sleepButton.selected) {
            [bleCoreMgr stopSleep];
        }
        else
        {
            [bleCoreMgr disConnection];
        }
    }
    else
    {
        [self goSleepView];
    }
}

-(void)goSleepView
{
    HandRingViewController * sport = [self.storyboard instantiateViewControllerWithIdentifier:@"HandRingViewController"];
    NTSlidingViewController *uv = (NTSlidingViewController *)superview;
    [uv setIndexText:1 txt:@"运动"];
    sport.superview=self.superview;
    [recordview initChart];
    [self presentPopupViewController:sport animated:true completion:nil];
}

- (IBAction)backupClicked:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)ConnOnClicked:(UITapGestureRecognizer*)sender {
    if (self.onconnButton.selected) {
        CXAlertView *alertViewMe = [[CXAlertView alloc] initWithTitle:@"询问" message:@"您确实要断开与手环的连接吗？" cancelButtonTitle:nil];
        
        // This is a demo for multiple line of title.
        [alertViewMe addButtonWithTitle:@"是的"
                                   type:CXAlertViewButtonTypeDefault
                                handler:^(CXAlertView *alertView, CXAlertButtonItem *button) {
                                    [alertView dismiss];
                                    [bleCoreMgr disConnection];
                                }];
        
        [alertViewMe addButtonWithTitle:@"取消"
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

- (void)SleepOnClicked:(UITapGestureRecognizer*)sender
{
    if (!self.onconnButton.selected) {
        CXAlertView *alertViewMe = [[CXAlertView alloc] initWithTitle:@"消息" message:@"开始睡眠前，请先连接手环．" cancelButtonTitle:@"好"];
        
        [alertViewMe show];
    }
    else if(self.sleepButton.selected)
    {
        CXAlertView *alertViewMe = [[CXAlertView alloc] initWithTitle:@"询问" message:@"当前正在睡眠状态，您确实要停止睡眠吗？" cancelButtonTitle:nil];
        
        // This is a demo for multiple line of title.
        [alertViewMe addButtonWithTitle:@"是的"
                                   type:CXAlertViewButtonTypeDefault
                                handler:^(CXAlertView *alertView, CXAlertButtonItem *button) {
                                    [alertView dismiss];
                                    //isUNline=true;
                                    HUD.labelText = @"正在结束...";
                                    
                                    //HUD.labelText = @"正在同步...";
                                    [HUD show:YES];
                                    [bleCoreMgr stopSleep];
                                    //[bleCoreMgr getSleepInfo];
                                }];
        
        [alertViewMe addButtonWithTitle:@"取消"
                                   type:CXAlertViewButtonTypeCancel
                                handler:^(CXAlertView *alertView, CXAlertButtonItem *button) {
                                    [alertView dismiss];
                                }];
        
        [alertViewMe show];
    }
    else
    {
        [bleCoreMgr startSleep];
    }
}

-(void)updateUIStartSleep
{
    self.sleepButton.selected=true;
    [HUD hide:YES];
    //[self performSelectorOnMainThread:@selector(startTimer) withObject:nil waitUntilDone:YES];
}

-(void)updateUIStopSleep
{
    self.sleepButton.selected=false;
    [HUD hide:YES];
    if (_goSleep==1) {
        [bleCoreMgr disConnection];
    }
}

-(void)updateUITime
{
    isOnlineing=false;
    [self startDeviceTimer];
    HUD.labelText = @"获取状态...";
}

-(void)updateUIBattery:(WTYGetBattery *)object
{
    NSArray *bater = [object.battery componentsSeparatedByString:@":"];
    NSLog(@"已取到电量");
    if (bater.count==2) {
        NSString *batt = [NSString stringWithFormat:@"电量%@%%",[bater objectAtIndex:1]];
        [_batterButton setTitle:batt forState:UIControlStateNormal];
    }
    [HUD hide:YES];
    isRuning=false;
}

-(void)updateConnState
{
    
}

-(void)updateFail
{
    [HUD hide:YES];
    isRuning=false;
    isUNline=false;
}

-(void)updateYesOTA
{
}

-(void)updateUIData:(WTYRestartDeviceCmd*)object
{
    
}

-(void)viewDidDisappear:(BOOL)animated
{
    if (self.onconnButton.selected) {
        //[bleCoreMgr disConnection];
        //sleep(2);
    }
    
    //[showTimer setFireDate:[NSDate distantFuture]];
    [batterTimer setFireDate:[NSDate distantFuture]];
    [batterTimerLoop setFireDate:[NSDate distantFuture]];
}

- (void)showWithLabelMixed {
    
    HUD.labelText = @"正在连接...";
    HUD.minSize = CGSizeMake(84.f, 84.f);
    [HUD show:YES];
    //[HUD showWhileExecuting:@selector(myMixedTask) onTarget:self withObject:nil animated:YES];
}

@end
