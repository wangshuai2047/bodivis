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

@interface LeftTableViewController ()
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
    NSArray *array=nil;
    AppDelegate *appdelegate =(AppDelegate*) [[UIApplication sharedApplication] delegate];
    if (appdelegate.deviceType!=1) {//两者都有的用户
         array = [[NSArray alloc] initWithObjects:@"身体评估",@"运动伴侣", @"膳食管理", @"阶段报告", @"排行榜",@"帮助",nil];
    }
    else
    {//秤用户
         array = [[NSArray alloc] initWithObjects:@"身体评估", @"膳食管理", @"阶段报告", @"排行榜",@"帮助",nil];
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
    
    NSString *uId = [NSString stringWithFormat:@"%d",appdelegate.userId];
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
    /*
    NSArray *array=nil;
    AppDelegate *appdelegate =(AppDelegate*) [[UIApplication sharedApplication] delegate];
    if (appdelegate.deviceType!=1) {//两者都有的用户
        array = [[NSArray alloc] initWithObjects:@"身体评估",@"运动伴侣", @"膳食管理", @"阶段报告", @"排行榜",@"帮助",nil];
    }
    else
    {//秤用户
        array = [[NSArray alloc] initWithObjects:@"身体评估", @"膳食管理", @"阶段报告", @"排行榜",@"帮助",nil];
    }
    self.list = array;
    [self initUser];
    [self.tableView reloadData];
    */
    NSLog(@"Left will appear");
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    NSLog(@"Left did appear");
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    NSLog(@"Left will disappear");
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    NSLog(@"Left did disappear");
}

#pragma mark - Table view delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AppDelegate *appdelegate =(AppDelegate*) [[UIApplication sharedApplication] delegate];
    if (indexPath.row ==0) {
        //身体评估
        BodyAnalysisViewController *vc1 = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"BodyAnalysisViewController"];//评估报告
        
        UIViewController *vc2 = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ComponentAnalysisViewController"];//深度分析
        
        
        NTSlidingViewController *sliding = [[NTSlidingViewController alloc] initSlidingViewControllerWithTitle:@"评估报告" viewController:vc1];
        vc1.superview=sliding;
        [sliding addControllerWithTitle:@"深度分析" viewController:vc2];
        
        sliding.selectedLabelColor = [UIColor whiteColor];
        sliding.unselectedLabelColor = [UIColor colorWithRed:123.0/255.0 green:223.0/255.0 blue:240.0/255.0 alpha:1];
        
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
    }
}

-(void)loadSportMenu
{
    //UIViewController *vc1 = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"SportSuggestionsViewController"];
    //运动
    HandRingViewController *vc2 = [[UIStoryboard storyboardWithName:@"Account" bundle:nil] instantiateViewControllerWithIdentifier:@"HandRingViewController"];
    //记录
    SportsRecordsViewController *vc3 = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"SportsRecordsViewController"];
    
    
    NTSlidingViewController *sliding = [[NTSlidingViewController alloc] initSlidingViewControllerWithTitle:@"运动" viewController:vc2];
    //[sliding addControllerWithTitle:@"运动" viewController:vc2];
    [sliding addControllerWithTitle:@"记录" viewController:vc3];
    
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
    
    
    NTSlidingViewController *sliding = [[NTSlidingViewController alloc] initSlidingViewControllerWithTitle:@"膳食" viewController:vc2];
    vc2.superview=sliding;
    
    //[sliding addControllerWithTitle:@"膳食" viewController:vc2];
    [sliding addControllerWithTitle:@"记录" viewController:vc3];
    
    sliding.selectedLabelColor = [UIColor whiteColor];
    sliding.unselectedLabelColor = [UIColor colorWithRed:123.0/255.0 green:223.0/255.0 blue:240.0/255.0 alpha:1];
    
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
    //UIViewController *vc1 = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"HealthKnowledgeViewController"];
    
    UIViewController *vc2 = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"UseInstructionsNavViewController"];
    
    //UIViewController *vc3 = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"AboutViewController"];
    
    [self.mm_drawerController setCenterViewController:vc2 withCloseAnimation:YES completion:nil];
    
    //NTSlidingViewController *sliding = [[NTSlidingViewController alloc] initSlidingViewControllerWithTitle:@"健康知识" viewController:vc1];
    //[sliding addControllerWithTitle:@"使用说明" viewController:vc2];
    //[sliding addControllerWithTitle:@"关于" viewController:vc3];
    
    //sliding.selectedLabelColor = [UIColor whiteColor];
    //sliding.unselectedLabelColor = [UIColor colorWithRed:123.0/255.0 green:223.0/255.0 blue:240.0/255.0 alpha:1];
    
    //[self.mm_drawerController setCenterViewController:sliding withCloseAnimation:YES completion:nil];
}


@end
