//
//  MyParternersViewController.m
//  TFHealth
//
//  Created by hzth hzth－mac2 on 5/30/14.
//  Copyright (c) 2014 studio37. All rights reserved.
//

#import "RankingViewController.h"
#import "HealthStatusViewController.h"
#import "UIViewController+MMDrawerController.h"
#import "AppCloundService.h"
#import "AppDelegate.h"
#import "UIImageView+WebCache.h"
@interface RankingViewController ()<ServiceCallbackDelegate,ServiceObjectDelegate>{
    NSMutableDictionary *rankListDict;
    User* currentUser;
}

@property (weak, nonatomic) IBOutlet UIImageView *headViewOfRange;//头像
@property (weak, nonatomic) IBOutlet UILabel *nameOfRange;//用户名
@property (weak, nonatomic) IBOutlet UILabel *descriptionOfRange;//描述信息
@property (weak, nonatomic) IBOutlet UIView *pyramidView;//下侧排行view
@property (weak, nonatomic) IBOutlet UIImageView *rankHeaderView;//排行的头像
@property (weak, nonatomic) IBOutlet UIImageView *rankLineView;//指向头像的直线
@property (weak, nonatomic) IBOutlet UIView *rankView;//上侧背景view

#define ViewWidth 320
@end

@implementation RankingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (IBAction)backButtonClikc:(id)sender {
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.backBarButtonItem =[[UIBarButtonItem alloc] initWithTitle:@" " style:UIBarButtonItemStyleBordered target:nil action:nil];

    _headViewOfRange.layer.cornerRadius = _rankHeaderView.frame.size.width/2;
    _headViewOfRange.layer.borderWidth = 4;
    _headViewOfRange.layer.masksToBounds = YES;
    _headViewOfRange.layer.borderColor = [UIColor colorWithRed:109.0/255.0 green:145.0/255.0 blue:226.0/255.0 alpha:1].CGColor;
    
    
    _rankHeaderView.layer.cornerRadius = _rankHeaderView.frame.size.width/2;
    _rankHeaderView.layer.borderWidth = 4;
    _rankHeaderView.layer.masksToBounds = YES;
    _rankHeaderView.layer.borderColor = [UIColor colorWithRed:109.0/255.0 green:145.0/255.0 blue:226.0/255.0 alpha:1].CGColor;
    
    /*
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
     */
    
    
    AppDelegate *appdelegate =(AppDelegate*) [[UIApplication sharedApplication] delegate];
    currentUser = appdelegate.user;
    [self getBeatePesentageWithUserId:[currentUser.userId intValue]];
    
        if (currentUser!=nil) {
        if (currentUser.userIco!=nil&& currentUser.userIco!=NULL) {
            UIImage *image = [UIImage imageWithData:currentUser.userIco];
            [_headViewOfRange setImage:image];
            [_rankHeaderView setImage:image];
        }
        else
        {
            [_headViewOfRange setImage:[UIImage imageNamed:@"11_body9"]];
            [_rankHeaderView setImage:[UIImage imageNamed:@"11_body9"]];
        }
    }
    
    /*
    NSString *str = [NSString stringWithFormat:@"%@%d.png",UserIcon_UrlPre,[currentUser.userId intValue]];
    [_headViewOfRange setImageWithURL:[NSURL URLWithString:str] placeholderImage:[UIImage imageNamed:@""]];
    [_rankHeaderView setImageWithURL:[NSURL URLWithString:str] placeholderImage:[UIImage imageNamed:@""]];
     */
    
    [self initUI];
    
}

-(void)initUI
{
    UIColor *borderColor = [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:0.2];
    _rankView.layer.masksToBounds = YES;
    _rankView.layer.cornerRadius = 6.0;
    _rankView.layer.borderWidth = 1.0;
    _rankView.layer.borderColor = [borderColor CGColor];
    _rankView.layer.backgroundColor=[borderColor CGColor];
}

-(void)getBeatePesentageWithUserId:(int)userId {
    
    AppCloundService *service = [[AppCloundService alloc] initWidthDelegate:self];
    [service getBeatPercentageUserId:userId];
}

#pragma mark -- UITableView Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - AppCloundService Delegate -- 刘飞
-(void)serviceFailed:(NSString *)message pMethod:(NSString*)method{
    
}
-(void)serviceSuccessed:(NSDictionary *)keyValues pMethod:(NSString*)method{
    NSLog(@"request user friend success :%@",keyValues);
    //取我的伙伴 刷新列表
    
    if ([method isEqualToString:@"BeatPercentageJson"]) {
        if (keyValues[@"res"]) {
            NSString *str = [NSString stringWithFormat:@"%@",keyValues[@"res"]];
            [self setPecentageWith:str];
        }
    }
    
}

-(void)setPecentageWith:(NSString *)str {
    
    if ([str floatValue] > 0) {
        [UIView animateWithDuration:0.1 animations:^{
            float y = 180*[str floatValue]/100;
            _rankHeaderView.center = CGPointMake(_rankHeaderView.center.x, 180-y);
            _rankLineView.center = CGPointMake(_rankLineView.center.x, 180-y);
        }];
    } else {
        [UIView animateWithDuration:0.1 animations:^{
            _rankHeaderView.center = CGPointMake(_rankHeaderView.center.x, 180);
            _rankLineView.center = CGPointMake(_rankLineView.center.x, 180);
        }];
    }
    _nameOfRange.text = [NSString stringWithFormat:@"%@",currentUser.nickName];
//    _descriptionOfRange.text = [NSString stringWithFormat:@"您的身体状况击败了全国%@%%的用户",str];
    _descriptionOfRange.text = [NSString stringWithFormat:CustomLocalizedString(@"labelRankingListContent1", nil),str];
}

@end
