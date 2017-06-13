//
//  HealthStatusViewController.m
//  TFHealth
//
//  Created by hzth hzth－mac2 on 6/7/14.
//  Copyright (c) 2014 studio37. All rights reserved.
//

#import "HealthStatusViewController.h"
#import "UIAwesomeButton.h"
#import "HealthStatusTableViewCell.h"
#import "UIViewController+MMDrawerController.h"
#import "HistoryDataViewController.h"
#import "LoginViewController.h"
#import "AppDelegate.h"
#import "AppCloundService.h"
#import "User_Item_Info.h"
#import "Health_Items.h"
#import "TestItemID.h"
#import "TestItemCalc.h"
#import "VScaleManager.h"
#import "FourpoleSteelyard.h"
#import "CalcGrades.h"
#import "NTSlidingViewController.h"
#import "UserDevices.h"
#import "HandRingViewController.h"
#import "UMSocial.h"
#import <AudioToolbox/AudioToolbox.h>
#import "PersonalSet.h"
#import "SyncCoordinater.h"
#import "DataSyncUtils.h"
#import "UserCoreValues.h"
#import "Members.h"

@interface HealthStatusViewController ()<UITableViewDataSource,UITableViewDelegate,ServiceObjectDelegate>
{
    UIImageView *jImage;
    
    UIImageView *jImage02;
    
    float lastWeight;
    
    VScaleManager* vscaleMgr;
    
    //状态指数/基础代谢/体重/标准体重/体脂率/BMI/水份/蛋白质/肌肉/骨质
    float share_ztzs;
    float share_jcdx;
    float share_tz;
    float share_bztz;
    float share_tzl;
    float share_bmi;
    float share_sf;
    float share_dbz;
    float share_jr;
    float share_gz;
    float share_zf; // fat
    float share_bs; // stepcount
    float share_rszf; // calorieValue
}

//上方那个白色指示标
@property (weak, nonatomic) IBOutlet UIView *indicaterView;
//下面那个tableview，显示数据的
@property (weak, nonatomic) IBOutlet UITableView *healthDataTableView;
//左上方综合得分label
@property (weak, nonatomic) IBOutlet UILabel *totalScoreLabel;
//中间体重的数值label
@property (weak, nonatomic) IBOutlet UILabel *weightLabel;
//体重旁边那个变化率百分比label，黄色字体那个
@property (weak, nonatomic) IBOutlet UILabel *varyPersentageLabel;
//设置那个黄色箭头的图片
@property (weak, nonatomic) IBOutlet UIImageView *arrowImageView;
@property (weak, nonatomic) IBOutlet UIButton *connectButton;
@property (weak, nonatomic) IBOutlet UIView *sumView;

@property (weak, nonatomic) IBOutlet UIView *blueView;
@property (weak, nonatomic) IBOutlet UIView *totalView;
@property (weak, nonatomic) IBOutlet UIView *hisView;//历史曲线
@property (weak, nonatomic) IBOutlet UIView *shareView;//分享
@property (weak, nonatomic) IBOutlet UIButton *blueStatus;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *menuBarItem;

/**
 *  需切换中英文的文字
 */




-(User_Item_Info*)createNewTestItem:(NSNumber*)userID pItemID:(NSInteger)itemID pValue:(NSNumber*)value pDate:(NSDate*)date;

@end

@implementation HealthStatusViewController

-(void)awakeFromNib
{
    //self.sumView.layer.cornerRadius = 25;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
//右侧表格视图
- (IBAction)myAccountButtonClick:(id)sender {
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideRight animated:YES completion:nil];
}
//左侧表格视图
- (IBAction)menuButtonClick:(id)sender {
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}

#pragma mark - 设置上面指示标的值-0.5到0.5之间的数
-(void)setIndicaterViewWithWeight:(float)weight
{
    static float j = 1.0;
    static float k = 0.1;
    
    [UIView beginAnimations:nil context:nil];
    
    [UIView setAnimationDuration:0.5];
    CGAffineTransform transform= CGAffineTransformMakeRotation(M_PI*(weight));
    jImage02.transform = transform;
    j = -j;
    k+=0.1;
    
    [UIView commitAnimations];
    
}
#pragma mark -
//上面那些数据的设置方法
-(void)setDatas
{
    self.totalScoreLabel.text = @"88";
    self.weightLabel.text = @"66";
    self.varyPersentageLabel.text = @"0.8%";
    
    //设置那个黄色箭头的图片
//    self.arrowImageView.image = [UIImage imageNamed:@""];
}


//连接仪器按钮响应
- (IBAction)connectMeshine:(id)sender {
    
    //self.connectButton.selected = !self.connectButton.selected;
    if(self.connectButton.selected)
    {
        [vscaleMgr disconnect];
    }
    else
    {
        [vscaleMgr scan];
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //self.sumView.layer.cornerRadius = 27;
    //self.sumView.layer.borderColor = [UIColor whiteColor].CGColor;
    //self.sumView.layer.borderWidth = 0.5;
    
    //接收右侧表格删除用户后更新主界面的通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(AddRefreshUI:) name:@"refreshMainUI" object:nil];
}

-(void)AddRefreshUI:(NSNotification*)sender
{
    User *user = (User*)sender.object;
    [self refreshUI:user];
    [self.healthDataTableView reloadData];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void)loadHeadTestItem:(User *)user offset:(float)offset
{
    UILabel* lblWeight =(UILabel*)[[self.view viewWithTag:1000] viewWithTag:1001];
    UILabel* lblScore =(UILabel*)[[self.view viewWithTag:2000] viewWithTag:2001];
    User_Item_Info* lastWeightItem = [User_Item_Info MR_findFirstWithPredicate:[NSPredicate predicateWithFormat:@"userId==%d AND itemId==%d",user.userId.intValue,[TestItemID getWeight]] sortedBy:@"testDate" ascending:false inContext:[NSManagedObjectContext MR_defaultContext]];
    User_Item_Info* lastScoreItem = [User_Item_Info MR_findFirstWithPredicate:[NSPredicate predicateWithFormat:@"userId==%d AND itemId==%d",user.userId.intValue,[TestItemID getHealthScore]] sortedBy:@"testDate" ascending:false inContext:[NSManagedObjectContext MR_defaultContext] ];
    
    if(lastWeightItem!=nil && user!=nil)
    {
        [lblWeight setText: [NSString stringWithFormat:@"%3.1f",lastWeightItem.testValue.doubleValue]];
        [self setIndicaterViewWithWeight:(lastWeightItem.testValue.doubleValue/(150.0-30.0))+offset];
        NSNumber* sWeight = [TestItemCalc calcStandardWeight:user.height pSexy:user.sex.intValue==1];
        double varyPerct=0;
        varyPerct=(lastWeightItem.testValue.doubleValue-sWeight.doubleValue);
        [_varyPersentageLabel setText:[NSString stringWithFormat:@"%2.1fkg",varyPerct]];
        if(varyPerct>0)
        {
            [_arrowImageView setImage:[UIImage imageNamed:@"11_upArrow_orenge"]];
        }
        share_tz = lastWeightItem.testValue.floatValue;
        share_bztz=sWeight.floatValue;
        NSNumber* bmi=[TestItemCalc calcBMI:lastWeightItem.testValue pHeight:user.height];
        NSNumber* bmr =[TestItemCalc calcBMR:lastWeightItem.testValue pHeight:user.height pAge:user.birthday.integerValue pSexy:user.sex.intValue==1];
        share_bmi = bmi.floatValue;
        share_jcdx = bmr.floatValue;
    }
    else
    {
        [lblWeight setText:@"0.0"];
        [_varyPersentageLabel setText:@"0%"];
        [self setIndicaterViewWithWeight:-0.5];

    }
    if(lastScoreItem!=nil)
    {
        share_ztzs = lastScoreItem.testValue.floatValue;
        [lblScore setText:[NSString stringWithFormat:@"%3.1f",lastScoreItem.testValue.doubleValue]];
    }
    else
    {
        [lblScore setText:@"0"];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    share_ztzs=0;
    share_jcdx=0;
    share_tz=0;
    share_bztz=0;
    share_tzl=0;
    share_bmi=0;
    share_sf=0;
    share_dbz=0;
    share_jr=0;
    share_gz=0;
    share_bs=0;
    share_rszf=0;
    share_zf=0;
    
    //    AppCloundService * s =[[AppCloundService alloc]initWidthDelegate:self];
    //    [s getFoodDictionary];
    /*
     AppDelegate *appDelegate=[[UIApplication sharedApplication] delegate];
     if (appDelegate.user==nil) {
     LoginViewController *login = [[LoginViewController alloc] init];
     [self presentViewController:login animated:NO completion:nil];
     return;
     }
     */
    
    
    AppDelegate *appdelegate =(AppDelegate*) [[UIApplication sharedApplication] delegate];
    User* user = appdelegate.user;
    if (user.userName!=nil && ![user.userName isEqualToString:@""]) {
        
        UserDevices *device = [UserDevices MR_findFirstByAttribute:@"userName" withValue:user.userName];
        if (device!=nil) {
            if (device.deviceType.intValue==0) {
                device.state=[NSNumber numberWithInt:0];
                [[NSManagedObjectContext MR_defaultContext] MR_save];
                //UIViewController *vc1 = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"SportSuggestionsViewController"];
                
                HandRingViewController *vc2 = [[UIStoryboard storyboardWithName:@"Account" bundle:nil] instantiateViewControllerWithIdentifier:@"HandRingViewController"];
                
                UIViewController *vc3 = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"SportsRecordsViewController"];
                
                
                NTSlidingViewController *sliding = [[NTSlidingViewController alloc] initSlidingViewControllerWithTitle:CustomLocalizedString(@"Sports", nil) viewController:vc2];
                //[sliding addControllerWithTitle:@"运动" viewController:vc2];
                [sliding addControllerWithTitle:CustomLocalizedString(@"Record", nil) viewController:vc3];
                
                vc2.superview=sliding;
                
                sliding.selectedLabelColor = [UIColor whiteColor];
                sliding.unselectedLabelColor = [UIColor colorWithRed:123.0/255.0 green:223.0/255.0 blue:240.0/255.0 alpha:1];
                [self.mm_drawerController setCenterViewController:sliding withCloseAnimation:YES completion:nil];
                [sliding transitionToViewControllerAtIndex:0];
            }
        }
    }
    vscaleMgr = [VScaleManager sharedInstance] ;
    vscaleMgr.delegate = self;
    
    self.healthDataTableView.delegate = self;
    self.healthDataTableView.dataSource = self;
    jImage02 = [[UIImageView alloc] init];
    jImage02.frame = CGRectMake(155, 140, 10, 170);
    jImage02.backgroundColor = [UIColor clearColor];
    [self.view addSubview:jImage02];
    
    
    jImage = [[UIImageView alloc] init];
    jImage.frame = CGRectMake(0, 1, 10, 10);
    jImage.image = [UIImage imageNamed:@"1_indicaterWhite"];
    [jImage02 addSubview:jImage];
    
    [self refreshUI:user];
    
    [self addEvent];
    
    // 设置允许摇一摇功能
    [UIApplication sharedApplication].applicationSupportsShakeToEdit = YES;
    // 并让自己成为第一响应者
    [self becomeFirstResponder];
    
    [[[SyncCoordinater alloc] init] start];
    
//    if (!appdelegate.isFirstLaunch) {
//        AppCloundService *service = [[AppCloundService alloc] initWidthDelegate:self];
//        [service isShowAppVersionDetectionAction];
//    }
    
    //接收是否弹出alert通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(showAlertView:) name:@"showAlertView" object:nil];
}

-(void)showAlertView:(NSNotification*)sender
{
    NSString *remark = sender.object[@"Remark"];
    NSString *url = sender.object[@"Url"];
    [self showAlertViewWithTitle:CustomLocalizedString(@"NewVersion", nil) message:remark cancelAction:CustomLocalizedString(@"cancel", nil) OKAction:CustomLocalizedString(@"update", nil) url:url];
}

/*
#pragma mark - 获取用户上次数据
-(void)getPreviousUserData{
    if (![[NSUserDefaults standardUserDefaults]objectForKey:TempUserData]) {
        AppDelegate *appdelegate =(AppDelegate*) [[UIApplication sharedApplication] delegate];
        NSMutableArray *marr = [NSMutableArray array];
        [marr addObject:[NSString stringWithFormat:@"%d",appdelegate.user.sex.intValue]];//性别
        [marr addObject:[NSString stringWithFormat:@"%d",appdelegate.user.birthday.intValue]];//年龄
        [marr addObject:[NSString stringWithFormat:@"%d",appdelegate.user.height.intValue]];//身高
        User_Item_Info* lastWeightItem = [User_Item_Info MR_findFirstWithPredicate:[NSPredicate predicateWithFormat:@"userId==%d AND itemId==%d",appdelegate.user.userId.intValue,[TestItemID getWeight]] sortedBy:@"testDate" ascending:false inContext:[NSManagedObjectContext MR_defaultContext]];
        [marr addObject:lastWeightItem];//体重
        User_Item_Info* lastPercentWaterItem = [User_Item_Info MR_findFirstWithPredicate:[NSPredicate predicateWithFormat:@"userId==%d AND itemId==%d",appdelegate.user.userId.intValue,[TestItemID getPercentWater]] sortedBy:@"testDate" ascending:false inContext:[NSManagedObjectContext MR_defaultContext]];
        [marr addObject:lastPercentWaterItem];//水分率
        [[NSUserDefaults standardUserDefaults]setObject:marr forKey:TempUserData];
    }
}
*/
//刷新界面
-(void)refreshUI:(User*)user
{
    [self loadHeadTestItem:user offset:-0.5];
    [self.navigationItem setTitle:user.nickName];
}

- (BOOL)canBecomeFirstResponder
{
    return YES;// default is NO
}

#pragma mark - 摇一摇相关方法
// 摇一摇开始摇动
- (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    NSLog(@"开始摇动");
    if(self.connectButton.selected)
    {
        //[vscaleMgr disconnect];
    }
    else
    {
        AudioServicesPlaySystemSound(1003);
        [vscaleMgr scan];
    }
    return;
}

// 摇一摇取消摇动
- (void)motionCancelled:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    NSLog(@"取消摇动");
    return;
}

// 摇一摇摇动结束
- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    if (event.subtype == UIEventSubtypeMotionShake) { // 判断是否是摇动结束
        NSLog(@"摇动结束");
    }
    return;
}

-(void)addEvent
{
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hisClicked:)];
    [_hisView addGestureRecognizer:singleTap];
    
    UITapGestureRecognizer *singleTap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(shareClicked:)];
    [_shareView addGestureRecognizer:singleTap1];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch

{
    
    return YES;
    
}

#pragma mark - 历史纪录
-(void)hisClicked:(UITapGestureRecognizer *)sender
{
    HistoryDataViewController * his = [self.storyboard instantiateViewControllerWithIdentifier:@"HistoryDataViewController"];
    [self.navigationController pushViewController:his animated:YES];
}

#pragma mark - 分享事件
-(void)shareClicked:(UITapGestureRecognizer *)sender
{
    NSLog(@"分享事件");
    AppDelegate *appdelegate =(AppDelegate*) [[UIApplication sharedApplication] delegate];
    //状态指数/基础代谢/体重/标准体重/体脂率/BMI/水份/蛋白质/肌肉/骨质
//    NSString* param = [NSString stringWithFormat:@"id=%ld&data=%.1f,%.1f,%.1f,%.1f,%.1f,%.1f,%.1f,%.1f,%.1f,%.1f,",appdelegate.user.userId.integerValue,share_ztzs,share_jcdx,share_tz,share_bztz,share_tzl,share_bmi,share_sf,share_dbz,share_jr,share_gz];
    NSString* param = [NSString stringWithFormat:@"id=%ld&data=%.1f,%.1f,%.1f,%.1f,%.1f,%.1f,%.1f,%.1f,%.1f,%.1f,&userInfo=%@,%d,%d,%d,",appdelegate.user.userId.integerValue,share_ztzs,share_jcdx,share_tz,share_bztz,share_tzl,share_bmi,share_sf,share_dbz,share_jr,share_gz,appdelegate.user.nickName,appdelegate.user.sex.intValue,appdelegate.user.birthday.intValue,appdelegate.user.height.intValue];

    
    [appdelegate updateUMSocial:param];
    NSString *shareText = [NSString stringWithFormat:@"我的身体状态指数为：%@，bodivis，您身边的健康专家！",_totalScoreLabel.text];             //分享内嵌文字
    
    UIImage *shareImage = [UIImage imageNamed:@"logo"];          //分享内嵌图片
    
    UMSocialSnsPlatform *emailPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToEmail];
    emailPlatform.bigImageName = @"TFShare";
    emailPlatform.displayName = @"bodivis";
    emailPlatform.snsClickHandler = ^(UIViewController *presentingController, UMSocialControllerService * socialControllerService, BOOL isPresentInController){
        AppCloundService* sevice = [[AppCloundService alloc] initWidthDelegate:self];
        [sevice shareTestInfo:appdelegate.user.userId.intValue weight:share_tz stateIndex:share_ztzs fatRate:share_tzl fat:share_zf muscle:share_jr water:share_sf bone:share_gz protein:share_dbz stepcount:share_bs burnCalories:share_rszf];
    };
    
    //如果得到分享完成回调，需要设置delegate为self
//    [UMSocialSnsService presentSnsIconSheetView:self appKey:@"540f1e0ffd98c51d1b02bae8" shareText:shareText shareImage:shareImage shareToSnsNames:[NSArray arrayWithObjects:UMShareToSina,UMShareToTencent,UMShareToQzone,UMShareToDouban,UMShareToWechatTimeline,UMShareToWechatSession,UMShareToEmail,UMShareToSms,nil] delegate:nil];
//    [UMSocialSnsService presentSnsIconSheetView:self appKey:@"540f1e0ffd98c51d1b02bae8" shareText:shareText shareImage:shareImage shareToSnsNames:[NSArray arrayWithObjects:UMShareToSina,UMShareToTencent,UMShareToQzone,UMShareToDouban,UMShareToWechatTimeline,UMShareToWechatSession,UMShareToSms,nil] delegate:nil];

    [UMSocialSnsService presentSnsIconSheetView:self appKey:@"540f1e0ffd98c51d1b02bae8" shareText:shareText shareImage:shareImage shareToSnsNames:[NSArray arrayWithObjects:UMShareToWechatSession,UMShareToWechatTimeline,UMShareToQQ,UMShareToQzone,UMShareToSina,nil] delegate:nil];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HealthStatusTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"HealthStatusTableViewCell"];
    UILabel* indicator =(UILabel*)[cell viewWithTag:100];
    UILabel* name =(UILabel*)[cell viewWithTag:200];
    UILabel* percent =(UILabel*)[cell viewWithTag:300];
    
    
    AppDelegate *appdelegate =(AppDelegate*) [[UIApplication sharedApplication] delegate];
    
    User* user = appdelegate.user;
    User_Item_Info* lastWeightItem = [User_Item_Info MR_findFirstWithPredicate:[NSPredicate predicateWithFormat:@"userId==%d AND itemId==%d",user.userId.intValue,[TestItemID getWeight]] sortedBy:@"testDate" ascending:false inContext:[NSManagedObjectContext MR_defaultContext]];
    
    //    NSArray* ws =[User_Item_Info MR_findAllWithPredicate:[NSPredicate predicateWithFormat:@"itemId==%d",[TestItemID getWeight]]];
    
    User_Item_Info* lastFatItem =[User_Item_Info MR_findFirstWithPredicate:[NSPredicate predicateWithFormat:@"userId==%d AND itemId==%d",user.userId.intValue,[TestItemID getFat]] sortedBy:@"testDate" ascending:false inContext:[NSManagedObjectContext MR_defaultContext]];
    
    User_Item_Info* lastWaterItem=[User_Item_Info MR_findFirstWithPredicate:[NSPredicate predicateWithFormat:@"userId==%d AND itemId==%d",user.userId.intValue,[TestItemID getTotalWater]] sortedBy:@"testDate" ascending:false inContext:[NSManagedObjectContext MR_defaultContext]];
    
    User_Item_Info* lastSclerotinItem=[User_Item_Info MR_findFirstWithPredicate:[NSPredicate predicateWithFormat:@"userId==%d AND itemId==%d",user.userId.intValue,[TestItemID getSclerotin]] sortedBy:@"testDate" ascending:false inContext:[NSManagedObjectContext MR_defaultContext]];
    
    User_Item_Info* lastMuscleItem =[User_Item_Info MR_findFirstWithPredicate:[NSPredicate predicateWithFormat:@"userId==%d AND itemId==%d",user.userId.intValue,[TestItemID getMuscle]] sortedBy:@"testDate" ascending:false inContext:[NSManagedObjectContext MR_defaultContext]];
    
    User_Item_Info* lastProteinItem =[User_Item_Info MR_findFirstWithPredicate:[NSPredicate predicateWithFormat:@"userId==%d AND itemId==%d",user.userId.intValue,[TestItemID getProtein]] sortedBy:@"testDate" ascending:false inContext:[NSManagedObjectContext MR_defaultContext]];
    NSNumber* userHeight= user.height;
    
    NSDate* today = [NSDate date];
    NSDateFormatter* format=[[NSDateFormatter alloc] init];
    format.dateFormat=@"yyyy-M-dd";
    NSString* now=[format stringFromDate:today];
    today = [format dateFromString:now];
    UserCoreValues* lastCoreValue=[UserCoreValues MR_findFirstWithPredicate:[NSPredicate predicateWithFormat:@"userId==%d And createTime>=%@",user.userId.intValue,today] sortedBy:@"createTime" ascending:false inContext:[NSManagedObjectContext MR_defaultContext]];
    if(lastCoreValue!=nil)
    {
        share_bs = lastCoreValue.stepCount.intValue;
        share_rszf = lastCoreValue.calorieValue.floatValue;
    }
    
    if([indexPath row]==0)
    {
        if(lastFatItem!=nil || lastWeightItem!=nil)
        {
            share_zf=lastFatItem.testValue.floatValue;
            NSNumber* pbf = [TestItemCalc calcPBF:lastWeightItem.testValue pFat:lastFatItem.testValue];
            NSNumber* minPbf = [TestItemCalc calcMinPBF:lastWeightItem.testValue pFat:lastFatItem.testValue pSexy:user.sex.intValue==1];
            NSNumber* maxPbf = [TestItemCalc calcMaxPBF:lastWeightItem.testValue pFat:lastFatItem.testValue pSexy:user.sex.intValue==1];
            int level=1;
            if(minPbf.doubleValue>=pbf.doubleValue)
            {
                level=0;
            }
            else if(maxPbf.doubleValue<=pbf.doubleValue)
            {
                level=2;
            }
            
            [cell setColorBarDetail:[NSString stringWithFormat:@"%3.1f",pbf.doubleValue] pMin:[NSString stringWithFormat:@"%3.1f",minPbf.doubleValue] pMax:[NSString stringWithFormat:@"%3.1f",maxPbf.doubleValue] pLevel:level];
            
            [indicator setText:[NSString stringWithFormat:@"%3.1f",pbf.doubleValue]];
            share_tzl=pbf.floatValue;
        }
        else
        {
//            [cell setColorBarDetail:@"无数据" pMin:@"" pMax:@"" pLevel:1];
            [cell setColorBarDetail:CustomLocalizedString(@"noData", nil) pMin:@"" pMax:@"" pLevel:1];
            [indicator setText:@"0.0"];
        }
        [percent setText:@"%"];
//        [name setText:@"体脂率"];
        [name setText:CustomLocalizedString(@"labelPBF", nil)];
        
        return cell;
    }
    if([indexPath row]==1)
    {
        if(lastWaterItem!=nil && lastWeightItem!=nil)
        {
            NSNumber* minWater = [TestItemCalc calcMinTotalWater:lastWeightItem.testValue];
            NSNumber* maxWater = [TestItemCalc calcMaxTotalWater:lastWeightItem.testValue];
            int level=1;
            if(minWater.doubleValue>=lastWaterItem.testValue.doubleValue)
            {
                level=0;
            }
            else if(maxWater.doubleValue<=lastWaterItem.testValue.doubleValue)
            {
                level=2;
            }
            [cell setColorBarDetail:[NSString stringWithFormat:@"%3.1f",lastWaterItem.testValue.doubleValue] pMin:[NSString stringWithFormat:@"%3.1f",minWater.doubleValue] pMax:[NSString stringWithFormat:@"%3.1f",maxWater.doubleValue] pLevel:level];
            
            [indicator setText:[NSString stringWithFormat:@"%3.1f",lastWaterItem.testValue.doubleValue]];
            share_sf=lastWaterItem.testValue.floatValue;
        }
        else
        {
//            [cell setColorBarDetail:@"无数据" pMin:@"" pMax:@"" pLevel:1];
            [cell setColorBarDetail:CustomLocalizedString(@"noData", nil) pMin:@"" pMax:@"" pLevel:1];
            [indicator setText:@"0"];
        }
        [percent setText:@"kg"];
//        [name setText:@"水分"];
        [name setText:CustomLocalizedString(@"labelWater", nil)];
        return cell;
    }
    if([indexPath row]==2)//骨质
    {
        if(lastSclerotinItem!=nil && lastWeightItem!=nil)
        {
            NSNumber* minSclerotin = [TestItemCalc calcMinSclerotin:lastWeightItem.testValue];
//            NSNumber* maxSclerotin = [TestItemCalc calcMaxSclerotin:lastWeightItem.testValue];
            NSNumber* maxSclerotin = [NSNumber numberWithLong:LONG_MAX];
            int level=1;
            if(minSclerotin.doubleValue>=lastSclerotinItem.testValue.doubleValue)
            {
                level=0;            }
            else if(maxSclerotin.doubleValue<=lastSclerotinItem.testValue.doubleValue)
            {
                level=2;
            }
//            [cell setColorBarDetail:[NSString stringWithFormat:@"%3.1f",lastSclerotinItem.testValue.doubleValue] pMin:[NSString stringWithFormat:@"%3.1f",minSclerotin.doubleValue] pMax:[NSString stringWithFormat:@"%3.1f",maxSclerotin.doubleValue] pLevel:level];
//            [cell setColorBarDetail:[NSString stringWithFormat:@"%3.1f",lastSclerotinItem.testValue.doubleValue] pMin:[NSString stringWithFormat:@"%3.1f",minSclerotin.doubleValue] pMax:@"无" pLevel:level];
            [cell setColorBarDetail:[NSString stringWithFormat:@"%3.1f",lastSclerotinItem.testValue.doubleValue] pMin:[NSString stringWithFormat:@"%3.1f",minSclerotin.doubleValue] pMax:CustomLocalizedString(@"nothing", nil) pLevel:level];

            
            [indicator setText:[NSString stringWithFormat:@"%3.1f",lastSclerotinItem.testValue.doubleValue]];
            share_gz=lastSclerotinItem.testValue.floatValue;
        }
        else
        {
//            [cell setColorBarDetail:@"无数据" pMin:@"" pMax:@"" pLevel:1];
            [cell setColorBarDetail:CustomLocalizedString(@"noData", nil) pMin:@"" pMax:@"" pLevel:1];
            [indicator setText:@"0"];
        }
        [percent setText:@"kg"];
//        [name setText:@"骨质"];
        [name setText:CustomLocalizedString(@"labelBone", nil)];
        return cell;
    }
    if([indexPath row]==3)
    {
        if(lastProteinItem!=nil && lastWeightItem!=nil)
        {
            NSNumber* minProtein = [TestItemCalc calcMinProtein:lastWeightItem.testValue];
            NSNumber* maxProtein = [TestItemCalc calcMaxProtein:lastWeightItem.testValue];
            int level=1;
            if(minProtein.doubleValue>=lastProteinItem.testValue.doubleValue)
            {
                level=0;
            }
            else if(maxProtein.doubleValue<=lastProteinItem.testValue.doubleValue)
            {
                level=2;
            }
            [cell setColorBarDetail:[NSString stringWithFormat:@"%3.1f",lastProteinItem.testValue.doubleValue] pMin:[NSString stringWithFormat:@"%3.1f",minProtein.doubleValue] pMax:[NSString stringWithFormat:@"%3.1f",maxProtein.doubleValue] pLevel:level];
            
            [indicator setText:[NSString stringWithFormat:@"%3.1f",lastProteinItem.testValue.doubleValue]];
            share_dbz=lastProteinItem.testValue.floatValue;
        }
        else
        {
//            [cell setColorBarDetail:@"无数据" pMin:@"" pMax:@"" pLevel:1];
            [cell setColorBarDetail:CustomLocalizedString(@"noData", nil) pMin:@"" pMax:@"" pLevel:1];
            [indicator setText:@"0"];
        }
        [percent setText:@"kg"];
//        [name setText:@"蛋白质"];
        [name setText:CustomLocalizedString(@"labelProtein", nil)];
        return cell;
    }
    if(userHeight.doubleValue>0 && lastMuscleItem!=nil)
    {
        NSNumber* minMuscle = [TestItemCalc calcMinMuscle:userHeight pSexy:user.sex.intValue==1];
        NSNumber* maxMuscle = [TestItemCalc calcMaxMuscle:userHeight pSexy:user.sex.intValue==1];
        int level=1;
        if(minMuscle.doubleValue>=lastMuscleItem.testValue.doubleValue)
        {
            level=0;
        }
        else if(maxMuscle.doubleValue<=lastMuscleItem.testValue.doubleValue)
        {
            level=2;
        }
        
        [cell setColorBarDetail:[NSString stringWithFormat:@"%3.1f",lastMuscleItem.testValue.doubleValue] pMin:[NSString stringWithFormat:@"%3.1f",minMuscle.doubleValue] pMax:[NSString stringWithFormat:@"%3.1f",maxMuscle.doubleValue] pLevel:level];
        
        [indicator setText:[NSString stringWithFormat:@"%3.1f",lastMuscleItem.testValue.doubleValue]];
        share_jr=lastMuscleItem.testValue.floatValue;
    }
    else
    {
//        [cell setColorBarDetail:@"无数据" pMin:@"" pMax:@"" pLevel:1];
        [cell setColorBarDetail:CustomLocalizedString(@"noData", nil) pMin:@"" pMax:@"" pLevel:1];
        [indicator setText:@"0"];
    }
    [percent setText:@"kg"];
//    [name setText:@"肌肉"];
    [name setText:CustomLocalizedString(@"labelMuscle", nil)];
    return cell;
}

-(void)updateDeviceStatus:(VCStatus)status
{
    switch (status) {
        case VC_STATUS_DISCONNECTED:
            self.connectButton.selected =false;
            [_blueStatus setTitle:CustomLocalizedString(@"labelYaoYiYao", nil) forState:UIControlStateNormal];
            NSLog(@"VScale disconnected");
            break;
        case VC_STATUS_DISCOVERED:
            NSLog(@"VScale discovered");
            //[self setIndicaterViewWithWeight:-0.5];
            break;
        case VC_STATUS_SERVICE_READY:
            //[self setIndicaterViewWithWeight:-0.5];
            self.connectButton.selected =true;
            //[self setIndicaterViewWithWeight:-0.5];
            [_blueStatus setTitle:CustomLocalizedString(@"alreadyConnect", nil) forState:UIControlStateNormal];
            NSLog(@"VScale ready");
            break;
        case VC_STATUS_CONNECTED:
            self.connectButton.selected =true;
            //[self setIndicaterViewWithWeight:-0.5];
            [_blueStatus setTitle:CustomLocalizedString(@"alreadyConnect", nil) forState:UIControlStateNormal];
            NSLog(@"VScale connected");
            break;
        case VC_STATUS_CACULATE:
            NSLog(@"VScale caculate");
            self.connectButton.selected =true;
            
//            [_blueStatus setTitle:@"已连接请上秤" forState:UIControlStateNormal];
            [_blueStatus setTitle:CustomLocalizedString(@"alreadyConnect", nil) forState:UIControlStateNormal];

            break;
        case VC_STATUS_HOLDING:
            NSLog(@"VScale holding");
            break;
        default:
            break;
    }
}

#pragma mark - 测试完成存储数据
-(void)updateUIData:(VTFatScaleTestResult*)result
{
    NSLog(@"%@",result);
    
    AppDelegate *appdelegate =(AppDelegate*) [[UIApplication sharedApplication] delegate];
    User* user = appdelegate.user;
    if(user==nil)
    {
        NSLog(@"测试无用户");
        return;
    }
    if(self.connectButton.selected==false)
    {
        return; // 未连接，或数据未计算完
    }
    if(vscaleMgr.curStatus!=VC_STATUS_CACULATE)
    {
        return;
    }
    if(result.weight==0 ||result.waterContent==0 || result.visceralFatContent==0)
    {
        return;
    }
    
    [self setIndicaterViewWithWeight:-0.5];
    
    FourpoleSteelyard* fsl = [[FourpoleSteelyard alloc] init:result.waterContent pWeight:result.weight pGender:user.sex.intValue pAge:user.birthday.intValue pHeight:user.height.doubleValue];
    NSDate* date=[NSDate date];
        User_Item_Info* weightItem =[self createNewTestItem:user.userId pItemID:[TestItemID getWeight] pValue:[NSNumber numberWithFloat:result.weight] pDate:date];
    
    User_Item_Info* pWaterItem=[self createNewTestItem:user.userId pItemID:[TestItemID getPercentWater] pValue:[NSNumber numberWithFloat:result.waterContent] pDate:date];
    
    User_Item_Info* sFatItem =[self createNewTestItem:user.userId pItemID:[TestItemID getSplanchnaPercentFat] pValue:[NSNumber numberWithFloat:result.visceralFatContent] pDate:date];//内脏脂肪率
    
    User_Item_Info* fatItem=[self createNewTestItem:user.userId pItemID:[TestItemID getFat] pValue:[NSNumber numberWithDouble:[fsl calcFatWeight]] pDate:date];
    
    User_Item_Info* warterItem=[self createNewTestItem:user.userId pItemID:[TestItemID getTotalWater] pValue:[NSNumber numberWithDouble:[fsl calcWaterWeight]] pDate:date];
    
    User_Item_Info* proteinItem=[self createNewTestItem:user.userId pItemID:[TestItemID getProtein] pValue:[NSNumber numberWithDouble:[fsl calcProteinWeight]] pDate:date];
    
    User_Item_Info* sclerotinItem=[self createNewTestItem:user.userId pItemID:[TestItemID getSclerotin] pValue:[NSNumber numberWithDouble:[fsl calcBoneWeight]] pDate:date];
    
    User_Item_Info* muscleItem=[self createNewTestItem:user.userId pItemID:[TestItemID getMuscle] pValue:[NSNumber numberWithDouble:[fsl calcMuscleWeight]] pDate:date];
    
    User_Item_Info* sMuscleItem=[self createNewTestItem:user.userId pItemID:[TestItemID getSMuscle] pValue:[NSNumber numberWithDouble:[fsl calcSMuscle]] pDate:date];
    NSNumber* standardMuslce=[TestItemCalc calcStandardMuscle:user.height pSexy:user.sex.intValue==1];
    double healthScore =[CalcGrades calcScore:muscleItem.testValue.doubleValue/standardMuslce.doubleValue fat:fatItem.testValue.doubleValue/result.weight p:proteinItem.testValue.doubleValue/result.weight m:sclerotinItem.testValue.doubleValue/result.weight g:user.sex.intValue a:user.birthday.intValue];
    
    User_Item_Info* healthScoreItem=[self createNewTestItem:user.userId pItemID:[TestItemID getHealthScore] pValue:[NSNumber numberWithDouble:healthScore] pDate:date];
    
    User_Item_Info* bodyAgeItem=[self createNewTestItem:user.userId pItemID:[TestItemID getBodyAge] pValue:[NSNumber numberWithDouble:[CalcGrades calcBodyAge:healthScore age:user.birthday.intValue gender:user.sex.intValue]] pDate:date];
    
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
    [self loadHeadTestItem:user offset:-0.5];
    [self.healthDataTableView reloadData];
    
    //测试完立即启动上传线程
    [[[DataSyncUtils alloc] init] SyncData];
    
    [vscaleMgr disconnect];
    //这里把personId改为了userId  如果没设置过“个人设定”则给出默认值
    PersonalSet *p=[PersonalSet MR_findFirstByAttribute:@"userId" withValue:[NSNumber numberWithInt:user.userId.intValue] inContext:[NSManagedObjectContext MR_defaultContext]];
    if(p==nil)
    {
        NSNumber* standardWeight =[TestItemCalc calcStandardWeight:user.height pSexy:user.sex.intValue==1];
        lastWeight=result.weight;
        AppCloundService* s= [[AppCloundService alloc] initWidthDelegate:self];
        [s addAndUpdatePersonalSet:user.userId.intValue targetWeight:standardWeight.doubleValue weekSubTarget:0.3 sportProp:50 foodProp:50 sleepTimeLength:@"7.5" stepLength:70 stepCount:1000 alertTime:@"08:00"];
    }
}


-(void)serviceSuccessed:(NSDictionary*)keyValues pMethod:(NSString*)method
{
    NSLog(@"method--%@",method);
    if([method isEqual:@"ShareTestInfoJson"])
    {
        if ([[keyValues allKeys] containsObject:@"res" ])
        {
            NSString *res = [keyValues objectForKey:@"res"];
            NSString* message;
            if([res isEqualToString:@"0"])
            {
                message=@"分享成功";
            }
            else
            {
                message=@"分享失败";
            }
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:CustomLocalizedString(@"tip", nil) message:message delegate:nil cancelButtonTitle:CustomLocalizedString(@"OK", nil) otherButtonTitles:nil, nil];
            [alert show];
        }
        return;
        
    }
    
    
    
    if ([method isEqualToString:@"GetUserDevicesJson"])
    {
        NSLog(@"获取用户设备类型:HealthStatusViewController.h");
    }
    else
    {
        if(keyValues.count>0 )
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
                    NSNumber* standardWeight =[TestItemCalc calcStandardWeight:user.height pSexy:user.sex.intValue==1];
                    p.targetWeight=standardWeight;
                    if (p.startDate==nil||p.startDate==NULL) {
                        NSDate *date = [NSDate date];
                        p.startDate=date;
                    }
                    p.weekTarget=[NSNumber numberWithFloat:0.3];
                    p.sportSubtract =[NSNumber numberWithFloat:50];
                    p.foodSubtract=[NSNumber numberWithFloat:50];
                    p.sleepTimeLength=[NSNumber numberWithFloat:7.5];
                    p.stepLength=[NSNumber numberWithInt:70];
                    p.stepTargetCount=[NSNumber numberWithInt:10000];
                    p.remindTime=@"08:00";
                    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
                }
                else
                {
                    NSLog(@"首页，个人设置保存失败，请检查您的信息是否正确。");
                }
            }
            else
            {
                NSLog(@"首页，个人设置保存失败，请检查您的信息是否正确。");
            }
        }
        else
        {
            NSLog(@"首页，登录失败，请检查您的用户密码是否正确。");
        }
    }
}

-(void)showAlertViewWithTitle:(NSString*)title message:(NSString*)message cancelAction:(NSString*)cancelAction OKAction:(NSString*)OKAction url:(NSString*)url{
    UIAlertController *controller = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    NSMutableAttributedString *alertControllerStr = [[NSMutableAttributedString alloc] initWithString:title];
    [alertControllerStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0, title.length)];
    [alertControllerStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:17] range:NSMakeRange(0, title.length)];
    //    [controller setValue:alertControllerStr forKey:@"attributedTitle"];
    
    UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:cancelAction style:UIAlertActionStyleCancel handler:nil];
    //    [actionCancel setValue:[UIColor redColor] forKey:@"titleTextColor"];
    
    if (OKAction) {
        UIAlertAction *actionOK = [UIAlertAction actionWithTitle:OKAction style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if (url) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
            }
            
        }];
        [controller addAction:actionOK];
    }
    [controller addAction:actionCancel];
    [self presentViewController:controller animated:YES completion:^{
    }];
    
    
    
}


-(void)serviceFailed:(NSString*) message pMethod:(NSString*)method
{
    if([method isEqual:@"ShareTestInfoJson"])
    {
        NSString* message=@"分享失败";
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:CustomLocalizedString(@"tip", nil) message:message delegate:nil cancelButtonTitle:CustomLocalizedString(@"OK", nil) otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    NSLog(@"首页，连接网络失败，请检查您的网络。");
}

-(User_Item_Info*)createNewTestItem:(NSNumber*)userID pItemID:(NSInteger)itemID pValue:(NSNumber*)value pDate:(NSDate*)date
{
    
    User_Item_Info* testItem =[User_Item_Info MR_createEntity];
    testItem.userId=userID;
    testItem.itemId=[NSNumber numberWithInteger:itemID];
    testItem.testDate=date;
    testItem.testValue = value;
    return testItem;
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

@end
