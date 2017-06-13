//
//  LeftTableViewController.m
//  TFHealth
//
//  Created by nico on 14-5-15.
//  Copyright (c) 2014年 studio37. All rights reserved.
//

#import "LeftTableViewController.h"
#import "UIViewController+MMDrawerController.h"
#import "HealthStatusViewController.h"
#import "NTSlidingViewController.h"
#import "HandRingViewController.h"
#import "BodyAnalysisViewController.h"
#import "TodayMealViewController.h"
#import "AppDelegate.h"
#import "SportsRecordsViewController.h"
#import "AppCloundService.h"
#import "InstructionsViewController.h"

@interface LeftTableViewController ()
{
    NSIndexPath *indexPhone;
}
@property (weak, nonatomic) IBOutlet UIView *headView;

@end

@implementation LeftTableViewController
@synthesize list = _list;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark - 设置头像的图片
-(void)setPropertiesOfHeadView:(UIImage*)headImage
{
    self.headView.layer.cornerRadius = self.headView.frame.size.width/2;
    self.headView.layer.borderWidth = 5;
    self.headView.layer.masksToBounds = YES;
    self.headView.layer.borderColor = UIColorFromRGB(0x343963).CGColor;
    self.headView.layer.contents = (id)[headImage CGImage];
}
#pragma mark -
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = UIColorFromRGB(0x1c2326);
    
    AppCloundService *service = [[AppCloundService alloc] initWidthDelegate:self];
    [service isShowAppVersionDetectionAction];
    
    NSArray *array=nil;
    AppDelegate *appdelegate =(AppDelegate*) [[UIApplication sharedApplication] delegate];
    if (appdelegate.isShowVersion) {
        if (appdelegate.deviceType!=1) {//两者都有的用户
            array = [[NSArray alloc] initWithObjects:@"身体评估",@"运动伴侣", @"膳食管理", @"阶段报告", @"排行榜",@"帮助",@"检测版本",@"服务热线",nil];
        }
        else
        {//秤用户
            array = [[NSArray alloc] initWithObjects:@"身体评估", @"膳食管理", @"阶段报告", @"排行榜",@"帮助",@"检测版本",@"服务热线",nil];
        }
        
    } else {
        if (appdelegate.deviceType!=1) {//两者都有的用户
            array = [[NSArray alloc] initWithObjects:@"身体评估",@"运动伴侣", @"膳食管理", @"阶段报告", @"排行榜",@"帮助",@"服务热线",nil];
        }
        else
        {//秤用户
            array = [[NSArray alloc] initWithObjects:@"身体评估", @"膳食管理", @"阶段报告", @"排行榜",@"帮助",@"服务热线",nil];
        }
        
    }
    
    self.list = array;
    [self initUser];
    
    self.headView.userInteractionEnabled = YES;
    UITapGestureRecognizer *singleTap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backButtonClikc:)];
    [self.headView addGestureRecognizer:singleTap1];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [self.tableView setSeparatorColor:UIColorFromRGB(0x2e383d)];
}

-(void)initUser
{
    AppDelegate *appdelegate =(AppDelegate*) [[UIApplication sharedApplication] delegate];
    
    NSString *uId = [NSString stringWithFormat:@"%d",appdelegate.user.userId.intValue];
    User *_user = [User MR_findFirstByAttribute:@"userId" withValue:uId inContext:[NSManagedObjectContext MR_defaultContext]];
    if (_user!=nil) {
        if (_user.userIco!=nil&& _user.userIco!=NULL) {
            UIImage *image = [UIImage imageWithData:_user.userIco];
            [self setPropertiesOfHeadView:image];
        }
        else
        {
            [self setPropertiesOfHeadView:[UIImage imageNamed:@"11_body9"]];
        }
    }
}

#pragma mark - 点击头像
- (IBAction)backButtonClikc:(id)sender {
    UIViewController * hsvc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"HealthStatusNavViewController"];
    [self.mm_drawerController setCenterViewController:hsvc withCloseAnimation:YES completion:nil];
    //[self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}
- (void)didReceiveMemoryWarning
{
    self.list = nil;
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return self.list.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *TableSampleIdentifier = @"TableSampleIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
                             TableSampleIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:TableSampleIdentifier];
    }
    
    NSUInteger row = [indexPath row];
    cell.textLabel.text = [self.list objectAtIndex:row];
    cell.textLabel.textColor = UIColorFromRGB(0x7881c6);
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    
    cell.selectedBackgroundView = [[[UIView alloc] initWithFrame:cell.frame] init];
    cell.selectedBackgroundView.backgroundColor = UIColorFromRGB(0x373c6a);
    
    return cell;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [self.mm_drawerController setCenterViewController:segue.destinationViewController withCloseAnimation:YES completion:nil];
}
/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    AppCloundService *service = [[AppCloundService alloc] initWidthDelegate:self];
    [service isShowAppVersionDetectionAction];
    
     NSArray *array=nil;
     AppDelegate *appdelegate =(AppDelegate*) [[UIApplication sharedApplication] delegate];
    if (appdelegate.languageIndex == 1) {
        if (appdelegate.isShowVersion) {
            if (appdelegate.deviceType!=1) {//两者都有的用户
                //有运动伴侣,有检测版本
                //@"身体评估",@"运动伴侣", @"膳食管理", @"阶段报告", @"排行榜",@"帮助",@"检测版本",@"服务热线"
                array = [[NSArray alloc] initWithObjects:CustomLocalizedString(@"labelBodyAssessment", nil),CustomLocalizedString(@"labelSportsMate", nil), CustomLocalizedString(@"labelDiteManagement", nil), CustomLocalizedString(@"labelInterimReport", nil),CustomLocalizedString(@"labelRankingList", nil),CustomLocalizedString(@"labelHelp", nil),CustomLocalizedString(@"labelTestVersion", nil),nil];
            }
            else
            {//秤用户
                //无运动伴侣,有检测版本
                //@"身体评估", @"膳食管理", @"阶段报告", @"排行榜",@"帮助",@"检测版本",@"服务热线"
                //array = [[NSArray alloc] initWithObjects:@"身体评估", @"膳食管理", @"阶段报告", @"排行榜",@"帮助",@"检测版本",@"服务热线",nil];
                array = [[NSArray alloc] initWithObjects:CustomLocalizedString(@"labelBodyAssessment", nil), CustomLocalizedString(@"labelDiteManagement", nil), CustomLocalizedString(@"labelInterimReport", nil),CustomLocalizedString(@"labelRankingList", nil),CustomLocalizedString(@"labelHelp", nil),CustomLocalizedString(@"labelTestVersion", nil),nil];
            }
            
        } else {
            //有运动伴侣,无检测版本
            //@"身体评估",@"运动伴侣", @"膳食管理", @"阶段报告", @"排行榜",@"帮助",@"服务热线"
            if (appdelegate.deviceType!=1) {//两者都有的用户
                //array = [[NSArray alloc] initWithObjects:@"身体评估",@"运动伴侣", @"膳食管理", @"阶段报告", @"排行榜",@"帮助",@"服务热线",nil];
                array = [[NSArray alloc] initWithObjects:CustomLocalizedString(@"labelBodyAssessment", nil),CustomLocalizedString(@"labelSportsMate", nil), CustomLocalizedString(@"labelDiteManagement", nil), CustomLocalizedString(@"labelInterimReport", nil),CustomLocalizedString(@"labelRankingList", nil),CustomLocalizedString(@"labelHelp", nil),nil];
            }
            else
            {//秤用户
                //无运动伴侣,无检测版本
                //@"身体评估", @"膳食管理", @"阶段报告", @"排行榜",@"帮助",@"服务热线"
                //array = [[NSArray alloc] initWithObjects:@"身体评估", @"膳食管理", @"阶段报告", @"排行榜",@"帮助",@"服务热线",nil];
                array = [[NSArray alloc] initWithObjects:CustomLocalizedString(@"labelBodyAssessment", nil), CustomLocalizedString(@"labelDiteManagement", nil), CustomLocalizedString(@"labelInterimReport", nil),CustomLocalizedString(@"labelRankingList", nil),CustomLocalizedString(@"labelHelp", nil),nil];
            }
            
        }
    } else { //中文
        if (appdelegate.isShowVersion) {
            if (appdelegate.deviceType!=1) {//两者都有的用户
                //有运动伴侣,有检测版本
                //@"身体评估",@"运动伴侣", @"膳食管理", @"阶段报告", @"排行榜",@"帮助",@"检测版本",@"服务热线"
                array = [[NSArray alloc] initWithObjects:CustomLocalizedString(@"labelBodyAssessment", nil),CustomLocalizedString(@"labelSportsMate", nil), CustomLocalizedString(@"labelDiteManagement", nil), CustomLocalizedString(@"labelInterimReport", nil),CustomLocalizedString(@"labelRankingList", nil),CustomLocalizedString(@"labelHelp", nil),CustomLocalizedString(@"labelTestVersion", nil),CustomLocalizedString(@"labelHotline", nil),nil];
            }
            else
            {//秤用户
                //无运动伴侣,有检测版本
                //@"身体评估", @"膳食管理", @"阶段报告", @"排行榜",@"帮助",@"检测版本",@"服务热线"
                //array = [[NSArray alloc] initWithObjects:@"身体评估", @"膳食管理", @"阶段报告", @"排行榜",@"帮助",@"检测版本",@"服务热线",nil];
                array = [[NSArray alloc] initWithObjects:CustomLocalizedString(@"labelBodyAssessment", nil), CustomLocalizedString(@"labelDiteManagement", nil), CustomLocalizedString(@"labelInterimReport", nil),CustomLocalizedString(@"labelRankingList", nil),CustomLocalizedString(@"labelHelp", nil),CustomLocalizedString(@"labelTestVersion", nil),CustomLocalizedString(@"labelHotline", nil),nil];
            }
            
        } else {
            //有运动伴侣,无检测版本
            //@"身体评估",@"运动伴侣", @"膳食管理", @"阶段报告", @"排行榜",@"帮助",@"服务热线"
            if (appdelegate.deviceType!=1) {//两者都有的用户
                //array = [[NSArray alloc] initWithObjects:@"身体评估",@"运动伴侣", @"膳食管理", @"阶段报告", @"排行榜",@"帮助",@"服务热线",nil];
                array = [[NSArray alloc] initWithObjects:CustomLocalizedString(@"labelBodyAssessment", nil),CustomLocalizedString(@"labelSportsMate", nil), CustomLocalizedString(@"labelDiteManagement", nil), CustomLocalizedString(@"labelInterimReport", nil),CustomLocalizedString(@"labelRankingList", nil),CustomLocalizedString(@"labelHelp", nil),CustomLocalizedString(@"labelHotline", nil),nil];
            }
            else
            {//秤用户
                //无运动伴侣,无检测版本
                //@"身体评估", @"膳食管理", @"阶段报告", @"排行榜",@"帮助",@"服务热线"
                //array = [[NSArray alloc] initWithObjects:@"身体评估", @"膳食管理", @"阶段报告", @"排行榜",@"帮助",@"服务热线",nil];
                array = [[NSArray alloc] initWithObjects:CustomLocalizedString(@"labelBodyAssessment", nil), CustomLocalizedString(@"labelDiteManagement", nil), CustomLocalizedString(@"labelInterimReport", nil),CustomLocalizedString(@"labelRankingList", nil),CustomLocalizedString(@"labelHelp", nil),CustomLocalizedString(@"labelHotline", nil),nil];
            }
            
        }
    }
    
    
    self.list = array;
    [self initUser];
    [self.tableView reloadData];
    
//    NSLog(@"Left will appear");
}



-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
//    NSLog(@"Left did appear");
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
//    NSLog(@"Left will disappear");
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
//    NSLog(@"Left did disappear");
}

#pragma mark - Table view delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AppDelegate *appdelegate =(AppDelegate*) [[UIApplication sharedApplication] delegate];
    if (appdelegate.languageIndex == 1) {//英文
        if (indexPath.row ==0) {
            //身体评估
            BodyAnalysisViewController *vc1 = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"BodyAnalysisViewController"];//评估报告
            
            UIViewController *vc2 = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ComponentAnalysisViewController"];//深度分析
            
            //labelAssessmentReport
            //        NTSlidingViewController *sliding = [[NTSlidingViewController alloc] initSlidingViewControllerWithTitle:@"评估报告" viewController:vc1];
            NTSlidingViewController *sliding = [[NTSlidingViewController alloc] initSlidingViewControllerWithTitle:CustomLocalizedString(@"labelAssessmentReport", nil) viewController:vc1];
            vc1.superview=sliding;
            //        [sliding addControllerWithTitle:@"深度分析" viewController:vc2];
            [sliding addControllerWithTitle:CustomLocalizedString(@"labelDeepAnalysis", nil) viewController:vc2];
            
            sliding.unselectedLabelColor = [UIColor whiteColor];
            sliding.selectedLabelColor = [UIColor colorWithRed:123.0/255.0 green:223.0/255.0 blue:240.0/255.0 alpha:1];
            
            [self.mm_drawerController setCenterViewController:sliding withCloseAnimation:YES completion:nil];
        }
        if (indexPath.row ==1) {
            if (appdelegate.deviceType!=1) {
                //两者都有 运动伴侣
                [self loadSportMenu];
            }
            else
            {
                //秤用户 膳食管理
                [self loadFoodMenu];
            }
        }
        else if(indexPath.row==2)
        {
            if (appdelegate.deviceType!=1)
            {
                //两者都有 膳食管理
                [self loadFoodMenu];
            }
            else
            {
                //秤用户 阶段报告
                [self loadReport];
            }
        }
        else if(indexPath.row ==3)
        {
            if (appdelegate.deviceType!=1)
            {
                //两者都有 阶段报告
                [self loadReport];
            }
            else
            {
                //秤用户 排行榜
                [self loadRank];
            }
        }
        else if(indexPath.row ==4)
        {
            if (appdelegate.deviceType!=1)
            {
                //两者都有 排行榜
                [self loadRank];
            }
            else
            {
                //秤用户 帮助
                [self loadHelper];
            }
        }
        else if(indexPath.row==5)
        {
            if (appdelegate.deviceType!=1)
            {
                //两者都有 帮助
                [self loadHelper];
            }
            else
            {
                //秤用户
                if (appdelegate.isShowVersion) {
                    //检测版本
                    [self loadVersionDetection];
                    //当离开某行时，让某行的选中状态消失
                } else {
                    //秤用户 客服电话
                    indexPhone = indexPath;
                    [self loadPhone];
                }
                
                [tableView deselectRowAtIndexPath:indexPath animated:YES];
            }
        }
        else if(indexPath.row==6)
        {
            if (appdelegate.deviceType!=1)
            {
                //两者都有
                if (appdelegate.isShowVersion) {
                    //检测版本
                    [self loadVersionDetection];
                    
                }else{
                    //客服电话
//                    indexPhone = indexPath;
//                    [self loadPhone];
                }
            }
            else
            {
                //秤用户 客服电话
//                indexPhone = indexPath;
//                [self loadPhone];
                
            }
            //当离开某行时，让某行的选中状态消失
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
        }
//        else if (indexPath.row == 7)
//        {
//            if (appdelegate.deviceType!=1)
//            {
//                //两者都有 客服电话
//                indexPhone = indexPath;
//                [self loadPhone];
//                //当离开某行时，让某行的选中状态消失
//                [tableView deselectRowAtIndexPath:indexPath animated:YES];
//            }
//        }
    } else {
        if (indexPath.row ==0) {
            //身体评估
            BodyAnalysisViewController *vc1 = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"BodyAnalysisViewController"];//评估报告
            
            UIViewController *vc2 = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ComponentAnalysisViewController"];//深度分析
            
            //labelAssessmentReport
            //        NTSlidingViewController *sliding = [[NTSlidingViewController alloc] initSlidingViewControllerWithTitle:@"评估报告" viewController:vc1];
            NTSlidingViewController *sliding = [[NTSlidingViewController alloc] initSlidingViewControllerWithTitle:CustomLocalizedString(@"labelAssessmentReport", nil) viewController:vc1];
            vc1.superview=sliding;
            //        [sliding addControllerWithTitle:@"深度分析" viewController:vc2];
            [sliding addControllerWithTitle:CustomLocalizedString(@"labelDeepAnalysis", nil) viewController:vc2];
            
            sliding.unselectedLabelColor = [UIColor whiteColor];
            sliding.selectedLabelColor = [UIColor colorWithRed:123.0/255.0 green:223.0/255.0 blue:240.0/255.0 alpha:1];
            
            [self.mm_drawerController setCenterViewController:sliding withCloseAnimation:YES completion:nil];
        }
        if (indexPath.row ==1) {
            if (appdelegate.deviceType!=1) {
                //两者都有 运动伴侣
                [self loadSportMenu];
            }
            else
            {
                //秤用户 膳食管理
                [self loadFoodMenu];
            }
        }
        else if(indexPath.row==2)
        {
            if (appdelegate.deviceType!=1)
            {
                //两者都有 膳食管理
                [self loadFoodMenu];
            }
            else
            {
                //秤用户 阶段报告
                [self loadReport];
            }
        }
        else if(indexPath.row ==3)
        {
            if (appdelegate.deviceType!=1)
            {
                //两者都有 阶段报告
                [self loadReport];
            }
            else
            {
                //秤用户 排行榜
                [self loadRank];
            }
        }
        else if(indexPath.row ==4)
        {
            if (appdelegate.deviceType!=1)
            {
                //两者都有 排行榜
                [self loadRank];
            }
            else
            {
                //秤用户 帮助
                [self loadHelper];
            }
        }
        else if(indexPath.row==5)
        {
            if (appdelegate.deviceType!=1)
            {
                //两者都有 帮助
                [self loadHelper];
            }
            else
            {
                //秤用户
                if (appdelegate.isShowVersion) {
                    //检测版本
                    [self loadVersionDetection];
                    //当离开某行时，让某行的选中状态消失
                } else {
                    //秤用户 客服电话
                    indexPhone = indexPath;
                    [self loadPhone];
                }
                
                [tableView deselectRowAtIndexPath:indexPath animated:YES];
            }
        }
        else if(indexPath.row==6)
        {
            if (appdelegate.deviceType!=1)
            {
                //两者都有
                if (appdelegate.isShowVersion) {
                    //检测版本
                    [self loadVersionDetection];
                    
                }else{
                    //客服电话
                    indexPhone = indexPath;
                    [self loadPhone];
                }
            }
            else
            {
                //秤用户 客服电话
                indexPhone = indexPath;
                [self loadPhone];
                
            }
            //当离开某行时，让某行的选中状态消失
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
        }
        else if (indexPath.row == 7)
        {
            if (appdelegate.deviceType!=1)
            {
                //两者都有 客服电话
                indexPhone = indexPath;
                [self loadPhone];
                //当离开某行时，让某行的选中状态消失
                [tableView deselectRowAtIndexPath:indexPath animated:YES];
            }
        }
    }
    
}

-(void)loadSportMenu
{
    //UIViewController *vc1 = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"SportSuggestionsViewController"];
    
    //运动
    HandRingViewController *vc2 = [[UIStoryboard storyboardWithName:@"Account" bundle:nil] instantiateViewControllerWithIdentifier:@"HandRingViewController"];
    //记录
    SportsRecordsViewController *vc3 = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"SportsRecordsViewController"];
    
    
    NTSlidingViewController *sliding = [[NTSlidingViewController alloc] initSlidingViewControllerWithTitle:CustomLocalizedString(@"Sports", nil) viewController:vc2];
    //[sliding addControllerWithTitle:@"运动" viewController:vc2];
    [sliding addControllerWithTitle:CustomLocalizedString(@"Record", nil) viewController:vc3];
    
    vc2.superview=sliding;
    vc3.superview=sliding;
    vc2.recordview=vc3;
    
    
    sliding.selectedLabelColor = [UIColor whiteColor];
    sliding.unselectedLabelColor = [UIColor colorWithRed:123.0/255.0 green:223.0/255.0 blue:240.0/255.0 alpha:1];
    
    [self.mm_drawerController setCenterViewController:sliding withCloseAnimation:YES completion:nil];
}

-(void)loadFoodMenu
{
    //UIViewController *vc1 = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"FoodSuggestionsViewController"];
    
    TodayMealViewController *vc2 = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"TodayMealViewController"];
    
    UIViewController *vc3 = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"MealCalendarViewController"];
    
    
    NTSlidingViewController *sliding = [[NTSlidingViewController alloc] initSlidingViewControllerWithTitle:CustomLocalizedString(@"TodayMeal", nil) viewController:vc2];
    vc2.superview=sliding;
    
    //[sliding addControllerWithTitle:@"膳食" viewController:vc2];
    [sliding addControllerWithTitle:CustomLocalizedString(@"Record", nil) viewController:vc3];
    
    sliding.unselectedLabelColor = [UIColor whiteColor];
    sliding.selectedLabelColor = [UIColor colorWithRed:123.0/255.0 green:223.0/255.0 blue:240.0/255.0 alpha:1];
    
    [self.mm_drawerController setCenterViewController:sliding withCloseAnimation:YES completion:nil];
}

-(void)loadReport
{
    UIViewController * prvc = [[UIStoryboard storyboardWithName:@"Account" bundle:nil]instantiateViewControllerWithIdentifier:@"ReportNavViewController"];
    
    [self.mm_drawerController setCenterViewController:prvc withCloseAnimation:YES completion:nil];
}

-(void)loadRank
{
    UIViewController * spvc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"RankingNavViewController"];
    
    [self.mm_drawerController setCenterViewController:spvc withCloseAnimation:YES completion:nil];
}

-(void)loadHelper
{
    
//    UIViewController *vc2 = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"UseInstructionsNavViewController"];
    InstructionsViewController *vc2 = [[InstructionsViewController alloc]init];
    [self.mm_drawerController setCenterViewController:vc2 withCloseAnimation:YES completion:nil];
    
}

//检测版本
-(void)loadVersionDetection
{
//    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/cn/app/bodivis/id918151882?mt=8"]];
//    NSLog(@"版本号:%@",[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]);
    
    AppCloundService *service = [[AppCloundService alloc] initWidthDelegate:self];
    [service appVersionDetectionWithAppType];
    
}

//服务热线
-(void)loadPhone
{
    //客服在线时间：8:00-20:30
    
//    UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"提示" message:@"客服在线时间：8:00-20:30" preferredStyle:UIAlertControllerStyleAlert];
//    UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
//    UIAlertAction *actionCall = [UIAlertAction actionWithTitle:@"呼叫" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel://4006508849"]];
//    }];
//    [self presentViewController:controller animated:YES completion:^{
//    }];
//
//    [controller addAction:actionCancel];
//    [controller addAction:actionCall];
    
    [self showAlertViewWithTitle:CustomLocalizedString(@"tip", nil) message:CustomLocalizedString(@"Hotline", nil) cancelAction:CustomLocalizedString(@"cancel", nil) OKAction:CustomLocalizedString(@"call", nil) url:@"tel://4006508849"];
    
}

#pragma mark -- Serviece delegate
-(void)serviceFailed:(NSString *)message pMethod:(NSString*)method{
    NSLog(@"upload food info failure:%@",message);
}
-(void)serviceSuccessed:(NSDictionary *)keyValues pMethod:(NSString*)method{

    if ([method isEqualToString:@"GetAppVersionJson"]) {//检测版本
        if (keyValues[@"Version_Num"] != nil) {
            NSString *appStoreVersion = keyValues[@"Version_Num"];
            NSString *localVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
            if ([appStoreVersion isEqualToString:localVersion]) {
                [self showAlertViewWithTitle:CustomLocalizedString(@"tip", nil) message:CustomLocalizedString(@"LatestVersion", nil) cancelAction:CustomLocalizedString(@"OK",nil) OKAction:nil url:nil];
            }
            else
            {
                NSString *remark = keyValues[@"Remark"];
                [self showAlertViewWithTitle:CustomLocalizedString(@"NewVersion", nil) message:remark cancelAction:CustomLocalizedString(@"cancel", nil) OKAction:CustomLocalizedString(@"update", nil) url:keyValues[@"Url"]];
            }
        }
        
    }else if ([method isEqualToString:@"isOpenCheckVersionJson"]){
        if ([keyValues[@"res"] intValue] == 1){//显示检测版本
            AppDelegate *appdelegate =(AppDelegate*) [[UIApplication sharedApplication] delegate];
            appdelegate.isShowVersion = 1;
        }else{//不显示检测版本
            AppDelegate *appdelegate =(AppDelegate*) [[UIApplication sharedApplication] delegate];
            appdelegate.isShowVersion = 0;
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


@end
