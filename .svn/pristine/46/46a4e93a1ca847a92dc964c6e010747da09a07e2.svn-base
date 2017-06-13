//
//  PeopleListViewController.m
//  TFHealth
//
//  Created by fei on 14-7-28.
//  Copyright (c) 2014年 studio37. All rights reserved.
//

#import "PeopleListViewController.h"
#import "AppCloundService.h"
#import "AppDelegate.h"
#import "PaternerTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "AddFriendAlertView.h"
@interface PeopleListViewController () <ServiceObjectDelegate,AddFiendAlertViewDelegate>
{
    UILabel *noFriendLabel;
    UIView *addFriendView;
}
@end

@implementation PeopleListViewController

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
    [self.navigationItem.leftBarButtonItem setImage:[UIImage imageNamed:@"back_btn"]];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 30, 30);
    [button setImage:[UIImage imageNamed:@"back_btn"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(backClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = left;
    
    dataArray = [[NSMutableArray alloc] initWithCapacity:0];
    noFriendLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
    noFriendLabel.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/3);
    
    noFriendLabel.textAlignment = NSTextAlignmentCenter;
    noFriendLabel.backgroundColor = [UIColor clearColor];
    noFriendLabel.textColor = [UIColor whiteColor];
    noFriendLabel.hidden = YES;
    [self.view addSubview:noFriendLabel];
    
    if ([_comfromType isEqualToString:@"1"]) {
        [self getActivityPeople];
        self.title = @"活跃用户";
        noFriendLabel.text = @"没有找到活跃用户，稍后再试吧";
    } else if ([_comfromType isEqualToString:@"2"]) {
        [self getLikePeople];
        self.title = @"与我相似用户";
        noFriendLabel.text = @"没有找到与我相似的用户，稍后再试吧";
    }
    
    [self setExtraCellLineHidden:_showListTableView];
    
    // Do any additional setup after loading the view.
}



-(void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}

-(void)backClicked {
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma request method

-(void)getActivityPeople {
    AppDelegate *appdelegate =(AppDelegate*) [[UIApplication sharedApplication] delegate];
    User* user = appdelegate.user;
    AppCloundService *service = [[AppCloundService alloc] initWidthDelegate:self];
    [service getActivityUsersWithUserId:[user.userId intValue]];
}
-(void)getLikePeople {
    AppDelegate *appdelegate =(AppDelegate*) [[UIApplication sharedApplication] delegate];
    User* user = appdelegate.user;
    AppCloundService *service = [[AppCloundService alloc] initWidthDelegate:self];
    [service getLikeUsersWithUserId:[user.userId intValue]];
    
}

-(void)addFriendWithFriendId:(int)friendId {
    AppDelegate *appdelegate =(AppDelegate*) [[UIApplication sharedApplication] delegate];
    User* user = appdelegate.user;
    AppCloundService *service = [[AppCloundService alloc] initWidthDelegate:self];
    [service addFriendWithUserId:[user.userId intValue] friendId:friendId time:[NSDate date]];
}

#pragma mark ServiceDelegate
-(void)serviceFailed:(NSString *)message pMethod:(NSString *)method {
    NSLog(@"request people failure");
}
-(void)serviceSuccessed:(NSDictionary *)keyValues pMethod:(NSString *)method {
    
    if ([method isEqualToString:@"GetActiveUsersJson"]) {
        if (dataArray.count > 0) {
            [dataArray removeAllObjects];
        }
        if ([keyValues count] > 0) {
            for (NSDictionary *dict in keyValues) {
                [dataArray addObject:dict];
            }
            noFriendLabel.hidden = YES;
        }else {
            noFriendLabel.hidden = NO;
        }
        [_showListTableView reloadData];
        
    } else if ([method isEqualToString:@"GetLikeUsersJson"]) {
        if (dataArray.count > 0) {
            [dataArray removeAllObjects];
        }
        
        if (keyValues.count > 0) {
            for (NSDictionary *dict in keyValues) {
                [dataArray addObject:dict];
            }
            noFriendLabel.hidden = YES;
        } else {
            noFriendLabel.hidden = NO;
        }
        [_showListTableView reloadData];
    }else if ([method isEqualToString:@"AddFriendsJson"]) {
        NSLog(@"addFriends result:%@",keyValues);
        if ([keyValues[@"res"] intValue] > 0) {
            [self showAlertWithTitle:@"恭喜" andMessage:@"添加好友成功"];
        } else {
            [self showAlertWithTitle:@"提示" andMessage:@"添加好友失败，请稍后再试，或者对方已经是您的好友了哦"];
        }
        
    }
}

#pragma mark UITableView Delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return dataArray.count;
    //    return 10;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 64;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    PaternerTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"PaternerTableViewCell"];
    
    if (dataArray.count > indexPath.row) {
        NSDictionary *dict = [dataArray objectAtIndex:indexPath.row];
        cell.nameLabel.text = dict[@"NickName"];
        NSString *string = [NSString stringWithFormat:@"%@%@",UserIcon_UrlPre,dict[@"UserIco"]];
        [cell.headView setImageWithURL:[NSURL URLWithString:string] placeholderImage:[UIImage imageNamed:@""]];
        cell.addButton.tag = 400+indexPath.row;
    }
    //    cell.nameLabel.text = @"aaaaa";
    return cell;
    
}

- (IBAction)cellButtonClicked:(UIButton *)sender {
    
    NSLog(@"select :%d",sender.tag);
    
    NSDictionary *dict = [dataArray objectAtIndex:sender.tag-400];
    [self showAlertWithTitle:@"提示" withDict:dict];
    
}


-(void)showAlertWithTitle:(NSString *)title withDict:(NSDictionary *)dict {
    
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    SDImageCache *imageCache = [manager imageCache];
    UIImage *image = [imageCache imageFromDiskCacheForKey:[NSString stringWithFormat:@"%@%@",UserIcon_UrlPre,dict[@"UserIco"]]];
    NSString *userId = [NSString stringWithFormat:@"%@",dict[@"UserID"]];
    NSString *string =  [NSString stringWithFormat:@"您要加 %@ 为好友么?",dict[@"NickName"]];
    AddFriendAlertView *view = [[AddFriendAlertView alloc] initWithFrame:CGRectMake(0, 0, 160, 130) andTitle:title andImage:image message:string delegate:self];
    view.tag = [userId intValue];
    [view show];
}


#pragma mark -- AddFriendAlertView Delegate
-(void)addFiendAlertView:(AddFriendAlertView *)addView ButtonClickedAtIndex:(NSInteger)buttonIndex {
    
    switch (buttonIndex) {
        case 0:
            [self addFriendWithFriendId:addView.tag];
            break;
        case 1:
            
            break;
        default:
            break;
    }
    
}


-(void)showAlertWithTitle:(NSString *)title andMessage:(NSString *)message {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
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

@end
