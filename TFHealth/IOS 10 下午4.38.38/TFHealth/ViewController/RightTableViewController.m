//
//  RightTableViewController.m
//  TFHealth
//
//  Created by nico on 14-5-15.
//  Copyright (c) 2014年 studio37. All rights reserved.
//

#import "RightTableViewController.h"
#import "PersonalSetViewController.h"
#import "SportsRecordsViewController.h"
#import "PhaseReportViewController.h"
#import "UIViewController+MMDrawerController.h"
#import "WriteVisitorInfViewController.h"
#import "HealthStatusViewController.h"
#import "User.h"
#import <CoreData/CoreData.h>
#import "DAContextMenuCell.h"
#import "CXAlertView.h"
#import "WriteFamilyInfViewController.h"
#import "AppDelegate.h"
#import "Members.h"
#import "HandRingViewController.h"
#import "NTSlidingViewController.h"
#import "AppCloundService.h"
#import "User_Item_Info.h"
#import "User_Comprehensive_Eval.h"
#import "UserCoreValues.h"
#import "DalidFood.h"
#import "LoginViewController.h"

@interface RightTableViewController ()
@property (nonatomic,retain) NSMutableArray *menus;
@property (nonatomic,retain) NSMutableArray *userids;
@property (weak, nonatomic) IBOutlet UILabel *nickLabel;
@end

@implementation RightTableViewController
@synthesize list = _list;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)setPropertiesOfHeadView:(UIImage*)headImage
{
    self.userView.layer.cornerRadius = self.userView.frame.size.width/2;
    self.userView.layer.borderWidth = 4;
    self.userView.layer.masksToBounds = YES;
    self.userView.layer.borderColor = UIColorFromRGB(0x343963).CGColor;
    self.userView.layer.contents = (id)[headImage CGImage];
}

- (IBAction)backButtonClikc:(id)sender {
    UIViewController * hsvc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"HealthStatusNavViewController"];
    [self.mm_drawerController setCenterViewController:hsvc withCloseAnimation:YES completion:nil];
    //[self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}

-(void)viewWillAppear:(BOOL)animated{
    [self initMenus];
    [self.tableView reloadData];
    [super viewWillAppear:animated];
    NSLog(@"Right will appear");
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    NSLog(@"Right did appear");
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    NSLog(@"Right will disappear");
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    NSLog(@"Right did disappear");
}

- (void)viewDidLoad
{
    //[MagicalRecord setupCoreDataStackWithStoreNamed:@"Healthdb.sqlite"];
    //User *person = [User MR_findFirst];
    //[person MR_deleteEntity];
    [super viewDidLoad];
    self.view.backgroundColor = UIColorFromRGB(0x1c2326);
    //[UITableView setSeparatorColor:[UIColor 0x2e383d ]];
    
    [self initUser];
    [self initMenus];
    
    self.userView.userInteractionEnabled = YES;
    UITapGestureRecognizer *singleTap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userHeadClikc:)];
    [self.userView addGestureRecognizer:singleTap1];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [self.tableView setSeparatorColor:UIColorFromRGB(0x2e383d)];
    
    UILongPressGestureRecognizer *gestureLongPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(gestureLongPress:)];
    gestureLongPress.minimumPressDuration =1;
    [self.tableView addGestureRecognizer:gestureLongPress];
}

- (IBAction)userHeadClikc:(id)sender {
    AppDelegate *appdelegate =(AppDelegate*) [[UIApplication sharedApplication] delegate];
    
    NSString *uId = [NSString stringWithFormat:@"%d",appdelegate.userId];
    User *_user = [User MR_findFirstByAttribute:@"userId" withValue:uId inContext:[NSManagedObjectContext MR_defaultContext]];
    if (_user!=nil) {
        appdelegate.user=_user;
    }
    if (appdelegate.deviceType!=0) {
        UIViewController * hsvc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"HealthStatusNavViewController"];
        [self.mm_drawerController setCenterViewController:hsvc withCloseAnimation:YES completion:nil];
    }
    else
    {
        //[self.mm_drawerController toggleDrawerSide:MMDrawerSideRight animated:YES completion:nil];
        
        HandRingViewController *vc2 = [[UIStoryboard storyboardWithName:@"Account" bundle:nil] instantiateViewControllerWithIdentifier:@"HandRingViewController"];
        
        UIViewController *vc3 = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"SportsRecordsViewController"];
        
        
        NTSlidingViewController *sliding = [[NTSlidingViewController alloc] initSlidingViewControllerWithTitle:@"运动" viewController:vc2];
        //[sliding addControllerWithTitle:@"运动" viewController:vc2];
        [sliding addControllerWithTitle:@"记录" viewController:vc3];
        
        vc2.superview=sliding;
        
        sliding.selectedLabelColor = [UIColor whiteColor];
        sliding.unselectedLabelColor = [UIColor colorWithRed:123.0/255.0 green:223.0/255.0 blue:240.0/255.0 alpha:1];
        [self.mm_drawerController setCenterViewController:sliding withCloseAnimation:YES completion:nil];
        [sliding transitionToViewControllerAtIndex:0];
    }
    //[self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
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
        self.nickLabel.text = _user.nickName;
    }
}

-(void) initMenus
{
    AppDelegate *appdelegate =(AppDelegate*) [[UIApplication sharedApplication] delegate];
    _menus=nil;
    _userids=nil;
    _menus= [[NSMutableArray alloc] init];
    _userids=[[NSMutableArray alloc]init];
    [_menus addObject:@"个人设定"];
    if (appdelegate.deviceType!=0) {//不是单独的手环用户
        [_menus addObject:@"家庭成员管理"];
        [_userids addObject:[NSString stringWithFormat:@"%d",0]];
        [_userids addObject:[NSString stringWithFormat:@"%d",0]];
        
        //NSArray *users = [User MR_findAllInContext:[NSManagedObjectContext MR_defaultContext]];
        
        NSString *uId = [NSString stringWithFormat:@"%d",appdelegate.userId];
        
        NSArray *users = [Members MR_findByAttribute:@"appUserId" withValue:uId inContext:[NSManagedObjectContext MR_defaultContext]];
        for (Members *member in users) {
            if (member.memberType.intValue==1) {
                continue;
            }
            User *user = [User MR_findFirstByAttribute:@"userId" withValue:member.userId inContext:[NSManagedObjectContext MR_defaultContext]];
            if (user!=nil && user.nickName != nil && user.nickName!= NULL && ![user.nickName isEqualToString:@""]) {
                [_menus addObject:[NSString stringWithFormat:@"   %@",user.nickName]];
                [_userids addObject:[NSString stringWithFormat:@"%d",user.userId.intValue]];
            }
        }
        [_menus addObject:@"访客模式"];
    }
    [_menus addObject:@"修改资料"];
    [_menus addObject:@"退出系统"];
    [_userids addObject:[NSString stringWithFormat:@"%d",0]];
    [_userids addObject:[NSString stringWithFormat:@"%d",0]];
    self.list = [NSArray arrayWithArray:_menus];
}

- (void)gestureLongPress:(UILongPressGestureRecognizer *)gestureRecognizer
{
    CGPoint tmpPointTouch = [gestureRecognizer locationInView:self.tableView];
    if (gestureRecognizer.state ==UIGestureRecognizerStateBegan) {
        NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:tmpPointTouch];
        if (indexPath == nil) {
            NSLog(@"not tableView");
        }else{
            int focusSection = [indexPath section];
            int focusRow = [indexPath row];
            
            CXAlertView *alertViewMe = [[CXAlertView alloc] initWithTitle:@"询问" message:@"您确实要删除选中用户及其本地相关的测试信息吗？" cancelButtonTitle:nil];
            
            // This is a demo for multiple line of title.
            [alertViewMe addButtonWithTitle:@"是的"
                                       type:CXAlertViewButtonTypeDefault
                                    handler:^(CXAlertView *alertView, CXAlertButtonItem *button) {
                                        [alertView dismiss];
                                        
                                        NSLog(@"%d",focusSection);
                                        NSLog(@"%d",focusRow);
                                        NSString *uid = [_userids objectAtIndex:focusRow];
                                        
                                        
                                        //NSString *nickName = [_menus objectAtIndex:focusRow];
                                        //nickName = [nickName stringByReplacingOccurrencesOfString:@" " withString:@""];
                                        //BOOL result = [User MR_deleteAllMatchingPredicate:[NSPredicate predicateWithFormat:@"nickName==%@",nickName] inContext:[NSManagedObjectContext MR_defaultContext]];
                                        BOOL user_del_result = [User MR_deleteAllMatchingPredicate:[NSPredicate predicateWithFormat:@"userId==%@",uid] inContext:[NSManagedObjectContext MR_defaultContext]];
                                        
                                        BOOL member_del_result = [Members MR_deleteAllMatchingPredicate:[NSPredicate predicateWithFormat:@"userId==%@",uid] inContext:[NSManagedObjectContext MR_defaultContext]];
                                        
                                        BOOL iteminfo_del_result = [User_Item_Info MR_deleteAllMatchingPredicate:[NSPredicate predicateWithFormat:@"userId==%@",uid] inContext:[NSManagedObjectContext MR_defaultContext]];
                                        
                                        BOOL comp_del_result = [User_Comprehensive_Eval MR_deleteAllMatchingPredicate:[NSPredicate predicateWithFormat:@"userId==%@",uid] inContext:[NSManagedObjectContext MR_defaultContext]];
                                        
                                        BOOL core_del_result = [UserCoreValues MR_deleteAllMatchingPredicate:[NSPredicate predicateWithFormat:@"userId==%@",uid] inContext:[NSManagedObjectContext MR_defaultContext]];
                                        
                                        BOOL food_del_result = [DalidFood MR_deleteAllMatchingPredicate:[NSPredicate predicateWithFormat:@"userId==%@",uid] inContext:[NSManagedObjectContext MR_defaultContext]];
                                        /*
                                         
                                         #import "User_Item_Info.h"
                                         #import "User_Comprehensive_Eval.h"
                                         #import "UserCoreValues.h"
                                         #import "DalidFood.h"
                                         */
                                        
                                        [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
                                        
                                        AppCloundService* s= [[AppCloundService alloc] initWidthDelegate:self];
                                        [s deleteMemberWithMemberId:[uid intValue]];
                                        
                                        [self initMenus];
                                        //NSLog(@"nickName==%@",nickName);
                                        [self.tableView reloadData];
                                    }];
            
            [alertViewMe addButtonWithTitle:@"取消"
                                       type:CXAlertViewButtonTypeCancel
                                    handler:^(CXAlertView *alertView, CXAlertButtonItem *button) {
                                        [alertView dismiss];
                                    }];
            
            [alertViewMe show];
        }
    }
}

-(void)serviceSuccessed:(NSDictionary*)keyValues pMethod:(NSString*)method
{
    
}

-(void)serviceFailed:(NSString*) message pMethod:(NSString*)method
{
    
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
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
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
    
    if (row>=2 && indexPath.row<_list.count-2) {
        UIView * whiteView = [[UIView alloc]initWithFrame:CGRectMake(15, 22, 4, 4)];
        whiteView.tag=999;
        whiteView.layer.cornerRadius = 2;
        whiteView.layer.backgroundColor = UIColorFromRGB(0xcff7fe).CGColor;
        [cell addSubview:whiteView];
    }
    cell.textLabel.text = [self.list objectAtIndex:row];
    
    cell.textLabel.textColor = UIColorFromRGB(0x7881c6);
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    //cell.backgroundColor = UIColorFromRGB(0x1c2326);
    //cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.selectedBackgroundView = [[[UIView alloc] initWithFrame:cell.frame] init];
    cell.selectedBackgroundView.backgroundColor = UIColorFromRGB(0x373c6a);
    
    return cell;
    
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

#pragma mark - Table view delegate

/*
 - (void)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
 {
 UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
 cell.textLabel.highlighted = YES;
 cell.textLabel.highlightedTextColor = UIColorFromRGB(0x373c6a);
 }
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    /*
     UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
     cell.textLabel.highlighted = YES;
     cell.textLabel.highlightedTextColor = UIColorFromRGB(0x373c6a);
     */
    
    AppDelegate *appdelegate =(AppDelegate*) [[UIApplication sharedApplication] delegate];
    if (appdelegate.deviceType==0) {
        if (indexPath.row == 0) {
            PersonalSetViewController * psvc = [[UIStoryboard storyboardWithName:@"Account" bundle:nil] instantiateViewControllerWithIdentifier:@"PersonalSetNavViewController"];
            [self.mm_drawerController setCenterViewController:psvc withCloseAnimation:YES completion:nil];
        }
        if (indexPath.row == 1)
        {
            /*这里修改用户资料*/
            WriteFamilyInfViewController * srvc = [[UIStoryboard storyboardWithName:@"Account" bundle:nil] instantiateViewControllerWithIdentifier:@"WriteFamilyInfViewController"];
            
            [self.mm_drawerController setCenterViewController:srvc withCloseAnimation:YES completion:nil];
            srvc.isModifyMode=1;
            [srvc loadUserInfo];
        }
        if (indexPath.row == 2)
        {
            LoginViewController *loginVc = [[UIStoryboard storyboardWithName:@"Account" bundle:nil] instantiateViewControllerWithIdentifier:@"LoginViewController"];
            [self.mm_drawerController setCenterViewController:loginVc withCloseAnimation:YES completion:nil];

        }
    }
    else
    {
        if (indexPath.row == 0) {
            PersonalSetViewController * psvc = [[UIStoryboard storyboardWithName:@"Account" bundle:nil] instantiateViewControllerWithIdentifier:@"PersonalSetNavViewController"];
            [self.mm_drawerController setCenterViewController:psvc withCloseAnimation:YES completion:nil];
        }
        else if (indexPath.row == 1)
        {
            SportsRecordsViewController * srvc = [[UIStoryboard storyboardWithName:@"Account" bundle:nil] instantiateViewControllerWithIdentifier:@"WriteFamilyInfNavViewController"];
            [self.mm_drawerController setCenterViewController:srvc withCloseAnimation:YES completion:nil];
        }
        else if (indexPath.row >= 3 && indexPath.row<_list.count-3)
        {
            
            //这里需要把家人用户ID赋值到AppDelegate中
            
            AppDelegate *appdelegate =(AppDelegate*) [[UIApplication sharedApplication] delegate];
            
            UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
            
            int focusRow = [indexPath row];
            NSString *uid = [_userids objectAtIndex:focusRow];
            
            User *_user = [User MR_findFirstByAttribute:@"userId" withValue:uid inContext:[NSManagedObjectContext MR_defaultContext]];
            /*
             NSString *nickName = cell.textLabel.text;
             nickName = [nickName stringByReplacingOccurrencesOfString:@" " withString:@""];
             
             User *_user = [User MR_findFirstByAttribute:@"nickName" withValue:nickName inContext:[NSManagedObjectContext MR_defaultContext]];
             */
            if (_user!=nil) {
                appdelegate.user=_user;
            }
            HealthStatusViewController * srvc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"HealthStatusNavViewController"];
            [self.mm_drawerController setCenterViewController:srvc withCloseAnimation:YES completion:nil];
        }
        else if (indexPath.row == _list.count-3)
        {
            UIViewController * srvc = [[UIStoryboard storyboardWithName:@"Account" bundle:nil] instantiateViewControllerWithIdentifier:@"WriteVisitorInfNavViewController"];
            [self.mm_drawerController setCenterViewController:srvc withCloseAnimation:YES completion:nil];
            /*
             WriteVisitorInfViewController * ssvc = [self.storyboard instantiateViewControllerWithIdentifier:@"WriteVisitorInfViewController"];
             [self.navigationController pushViewController:ssvc animated:YES];*/
        }
        else if (indexPath.row == _list.count-2)
        {
            /*这里修改用户资料*/
            WriteFamilyInfViewController * srvc = [[UIStoryboard storyboardWithName:@"Account" bundle:nil] instantiateViewControllerWithIdentifier:@"WriteFamilyInfViewController"];
            
            [self.mm_drawerController setCenterViewController:srvc withCloseAnimation:YES completion:nil];
            srvc.isModifyMode=1;
            [srvc loadUserInfo];
        }
        else if (indexPath.row == _list.count-1)
        {
            
            LoginViewController *loginVc = [[UIStoryboard storyboardWithName:@"Account" bundle:nil] instantiateViewControllerWithIdentifier:@"LoginViewController"];
            [self.mm_drawerController setCenterViewController:loginVc withCloseAnimation:YES completion:nil];

        }
        /*
         else if(indexPath.row==_list.count-1)
         {
         UIViewController * sivc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"SystemInformationsNavViewController"];
         
         [self.mm_drawerController setCenterViewController:sivc withCloseAnimation:YES completion:nil];
         }
         */
    }
}

@end
