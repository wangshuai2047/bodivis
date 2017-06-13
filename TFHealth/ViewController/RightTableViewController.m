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
#import "FamilyManagementViewController.h"
#import "MoreLanguageViewController.h"

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
    
     [self initUser];
     [self initMenus];
     [self.tableView reloadData];
    
    [super viewWillAppear:animated];
//    NSLog(@"Right will appear");
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
//    NSLog(@"Right did appear");
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
//    NSLog(@"Right will disappear");
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
//    NSLog(@"Right did disappear");
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
    
    NSString *uId = [NSString stringWithFormat:@"%d",appdelegate.user.userId.intValue];
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
        
        
        NTSlidingViewController *sliding = [[NTSlidingViewController alloc] initSlidingViewControllerWithTitle:CustomLocalizedString(@"Sports", nil) viewController:vc2];
        //[sliding addControllerWithTitle:@"运动" viewController:vc2];
        [sliding addControllerWithTitle:CustomLocalizedString(@"Record", nil) viewController:vc3];
        
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
        self.nickLabel.text = _user.nickName;
    }
}
//右侧表格视图布局
-(void) initMenus
{
    AppDelegate *appdelegate =(AppDelegate*) [[UIApplication sharedApplication] delegate];
    _menus=nil;
    _userids=nil;
    _menus= [[NSMutableArray alloc] init];
    _userids=[[NSMutableArray alloc]init];
    [_menus addObject:CustomLocalizedString(@"labelPersonalSetting", nil)];//个人设定
    if (appdelegate.deviceType!=0) {//不是单独的手环用户
        [_menus addObject:CustomLocalizedString(@"labelFamilyMembersManagement", nil)];//家庭成员管理
        [_userids addObject:[NSString stringWithFormat:@"%d",0]];//除了添加的家庭成员是自己的userid其他全部是0
        [_userids addObject:[NSString stringWithFormat:@"%d",0]];
        
        
//        NSString *uId = [NSString stringWithFormat:@"%d",appdelegate.userId];
//        
//        NSArray *AllUsers = [Members MR_findByAttribute:@"appUserId" withValue:uId inContext:[NSManagedObjectContext MR_defaultContext]];
//        
//        NSArray *users = [AllUsers sortedArrayUsingComparator:^NSComparisonResult(Members *p1, Members *p2){
//            return [p1.userId compare:p2.userId];
//        }];
//        
//        for (Members *member in users) {
//            if (member.memberType.intValue==1) {
//                continue;
//            }
//            User *user = [User MR_findFirstByAttribute:@"userId" withValue:member.userId inContext:[NSManagedObjectContext MR_defaultContext]];
//            if (user!=nil && user.nickName != nil && user.nickName!= NULL && ![user.nickName isEqualToString:@""]) {
//                [_menus addObject:[NSString stringWithFormat:@"   %@",user.nickName]];
//                [_userids addObject:[NSString stringWithFormat:@"%d",user.userId.intValue]];
//            }
//        }
        [_menus addObject:CustomLocalizedString(@"labelGuestMode", nil)];//访客模式
        [_userids addObject:[NSString stringWithFormat:@"%d",0]];
    }
    [_menus addObject:CustomLocalizedString(@"labelModifyDatabase", nil)];//修改资料
    [_menus addObject:CustomLocalizedString(@"labelSwitchLanguage", nil)];//切换语言
    [_menus addObject:CustomLocalizedString(@"labelExitAccount", nil)];//退出账户
    [_userids addObject:[NSString stringWithFormat:@"%d",0]];//除了添加的家庭成员是自己的userid其他全部是0
    [_userids addObject:[NSString stringWithFormat:@"%d",0]];
    [_userids addObject:[NSString stringWithFormat:@"%d",0]];
    self.list = [NSArray arrayWithArray:_menus];
}

#pragma mark - 长按手势绑定方法（删除家庭成员）
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
            
            if (focusSection == 0 && focusRow >= 2 && focusRow <_list.count-3 )
            {
                CXAlertView *alertViewMe = [[CXAlertView alloc] initWithTitle:CustomLocalizedString(@"tip", nil) message:CustomLocalizedString(@"DelSelectUser", nil) cancelButtonTitle:nil];
                
                [alertViewMe addButtonWithTitle:CustomLocalizedString(@"cancel", nil)
                                           type:CXAlertViewButtonTypeCancel
                                        handler:^(CXAlertView *alertView, CXAlertButtonItem *button) {
                                            [alertView dismiss];
                                        }];
                
                // This is a demo for multiple line of title.
                [alertViewMe addButtonWithTitle:CustomLocalizedString(@"yes", nil)
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
                                            
                                            AppDelegate *appdelegate =(AppDelegate*) [[UIApplication sharedApplication] delegate];
                                            
                                            NSString *uId = [NSString stringWithFormat:@"%d",appdelegate.userId];
                                            User *_user = [User MR_findFirstByAttribute:@"userId" withValue:uId inContext:[NSManagedObjectContext MR_defaultContext]];
                                            if (_user!=nil) {
                                                
                                                appdelegate.user=_user;
                                                
                                                //发送通知更新主界面
                                                [[NSNotificationCenter defaultCenter]postNotificationName:@"refreshMainUI" object:_user];
                                            }
                                            
                                            [self initMenus];
                                            //NSLog(@"nickName==%@",nickName);
                                            [self.tableView reloadData];
                                        }];
                
                
                
                [alertViewMe show];

            }
            
        }
    }
}

-(void)serviceSuccessed:(NSDictionary*)keyValues pMethod:(NSString*)method
{
    NSLog(@"删除成功");
}

-(void)serviceFailed:(NSString*) message pMethod:(NSString*)method
{
    NSLog(@"删除失败");
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
    for (UIView *obj in [cell.contentView subviews]) {
        [obj removeFromSuperview];
    }
    if (cell == nil) {
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:TableSampleIdentifier];
    }
    
    NSUInteger row = [indexPath row];
    UIView * whiteView = [[UIView alloc]initWithFrame:CGRectMake(15, 22, 4, 4)];
    whiteView.tag=999;
    whiteView.layer.cornerRadius = 2;
    whiteView.layer.backgroundColor = UIColorFromRGB(0xcff7fe).CGColor;
    [cell.contentView addSubview:whiteView];
    whiteView.hidden = YES;
    if (row>=2 && indexPath.row<_list.count-4) {
        whiteView.hidden = NO;
    }
    else
    {
        whiteView.hidden = YES;
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
    if (appdelegate.deviceType==0) {//手环用户
        if (indexPath.row == 0) {
            PersonalSetViewController * psvc = [[UIStoryboard storyboardWithName:@"Account" bundle:nil] instantiateViewControllerWithIdentifier:@"PersonalSetNavViewController"];
            [self.mm_drawerController setCenterViewController:psvc withCloseAnimation:YES completion:nil];
        }
        if (indexPath.row == 1)
        {
            /*这里修改用户资料*/
            /*
            WriteFamilyInfViewController * srvc = [[UIStoryboard storyboardWithName:@"Account" bundle:nil] instantiateViewControllerWithIdentifier:@"WriteFamilyInfViewController"];
            
            [self.mm_drawerController setCenterViewController:srvc withCloseAnimation:YES completion:nil];
            srvc.isModifyMode=1;
            [srvc loadUserInfo];
             */
            
            WriteFamilyInfViewController * srvc = [[UIStoryboard storyboardWithName:@"Account" bundle:nil] instantiateViewControllerWithIdentifier:@"WriteFamilyInfViewController"];
            UINavigationController *nav=[[UINavigationController alloc] initWithRootViewController:srvc];
            srvc.navigationItem.title = CustomLocalizedString(@"labelModifyDatabase", nil);
            [self.mm_drawerController setCenterViewController:nav withCloseAnimation:YES completion:nil];
            srvc.isModifyMode=1;
        }
        if (indexPath.row == 2) {
            //跳转到切换语言界面
            MoreLanguageViewController *languagesViewVC = [[MoreLanguageViewController alloc]init];
            [self.mm_drawerController setCenterViewController:languagesViewVC withCloseAnimation:YES completion:nil];
        }
        if (indexPath.row == 3)
        {
            /*退出登录*/
            [self BackOutSystemToLogin];
            
        }
    }
    else
    {//秤用户，或两者都有
        if (indexPath.row == 0) {
            //个人设定
            PersonalSetViewController * psvc = [[UIStoryboard storyboardWithName:@"Account" bundle:nil] instantiateViewControllerWithIdentifier:@"PersonalSetNavViewController"];
            [self.mm_drawerController setCenterViewController:psvc withCloseAnimation:YES completion:nil];
        }
        else if (indexPath.row == 1)
        {
            //跳转到家庭成员管理界面
            FamilyManagementViewController *familyManagementVC = [[FamilyManagementViewController alloc]init];
            [self.mm_drawerController setCenterViewController:familyManagementVC withCloseAnimation:YES completion:nil];
            
        }
        else if (indexPath.row >= 2 && indexPath.row<_list.count-4)
        {//家庭成员
            
            //这里需要把家人用户ID赋值到AppDelegate中
            //这里是所有的
            AppDelegate *appdelegate =(AppDelegate*) [[UIApplication sharedApplication] delegate];
            
            UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
            
            int focusRow = (int)[indexPath row];
            NSString *uid = [_userids objectAtIndex:focusRow];
            
            User *_user = [User MR_findFirstByAttribute:@"userId" withValue:uid inContext:[NSManagedObjectContext MR_defaultContext]];
            if (_user!=nil) {
                appdelegate.user=_user;
            }
            //跳到主界面健康状态界面
            HealthStatusViewController * srvc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"HealthStatusNavViewController"];
            [self.mm_drawerController setCenterViewController:srvc withCloseAnimation:YES completion:nil];
        }
        else if (indexPath.row == _list.count-4)
        {
            /*访客模式*/
            UIViewController * srvc = [[UIStoryboard storyboardWithName:@"Account" bundle:nil] instantiateViewControllerWithIdentifier:@"WriteVisitorInfNavViewController"];
            [self.mm_drawerController setCenterViewController:srvc withCloseAnimation:YES completion:nil];
        }
        else if (indexPath.row == _list.count-3)
        {
            /*这里修改用户资料*/
            
            WriteFamilyInfViewController * srvc = [[UIStoryboard storyboardWithName:@"Account" bundle:nil] instantiateViewControllerWithIdentifier:@"WriteFamilyInfViewController"];
            UINavigationController *nav=[[UINavigationController alloc] initWithRootViewController:srvc];
            srvc.navigationItem.title = CustomLocalizedString(@"labelModifyDatabase", nil);
            [self.mm_drawerController setCenterViewController:nav withCloseAnimation:YES completion:nil];
            srvc.isModifyMode=1;
            
        }
        else if (indexPath.row == _list.count - 2){
            //跳转到切换语言界面
            MoreLanguageViewController *languagesViewVC = [[MoreLanguageViewController alloc]init];
            [self.mm_drawerController setCenterViewController:languagesViewVC withCloseAnimation:YES completion:nil];
        }
        else if (indexPath.row == _list.count-1)
        {
            //退出登录
            [self BackOutSystemToLogin];
            
        }
        
    }

}

//退出登录
-(void)BackOutSystemToLogin
{
    /*退出登录*/
    //获取用户信息
    AppDelegate *appdelegate =(AppDelegate*) [[UIApplication sharedApplication] delegate];
    
    NSString *uId = [NSString stringWithFormat:@"%d",appdelegate.userId];
    User *_user = [User MR_findFirstByAttribute:@"userId" withValue:uId inContext:[NSManagedObjectContext MR_defaultContext]];
    _user.loginType = [NSNumber numberWithBool:NO];//退出登录
    [[NSManagedObjectContext MR_defaultContext] MR_save];
    
    //跳转到登录界面
    LoginViewController *loginVc = [[UIStoryboard storyboardWithName:@"Account" bundle:nil] instantiateViewControllerWithIdentifier:@"LoginViewController"];
    
    [appdelegate setRootWindow:loginVc];
}

@end
