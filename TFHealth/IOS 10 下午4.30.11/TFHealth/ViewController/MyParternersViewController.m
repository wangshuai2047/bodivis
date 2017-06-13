//
//  MyParternersViewController.m
//  TFHealth
//
//  Created by hzth hzth－mac2 on 5/30/14.
//  Copyright (c) 2014 studio37. All rights reserved.
//

#import "MyParternersViewController.h"
#import "PPiFlatSegmentedControl.h"
#import "PaternerTableViewCell.h"
#import "RecommandTableViewCell.h"
#import "HealthStatusViewController.h"
#import "UIViewController+MMDrawerController.h"
#import "AppCloundService.h"
#import "AppDelegate.h"
#import "PeopleListViewController.h"
#import "UIImageView+WebCache.h"
@interface MyParternersViewController ()<PPiFlatSegmentedDelegate,UITableViewDataSource,UITableViewDelegate,ServiceObjectDelegate>{
    NSMutableArray *userPartenerArray;
    NSMutableArray *userIdArray;
    NSMutableArray *userIconArray;
    NSMutableArray *recommendArray;
    UILabel *noFriendLabel ;
    NSMutableDictionary *rankListDict;
    int  selectIndex;
    User* currentUser;
}
@property (weak, nonatomic) IBOutlet UITableView *paternerTableView;
@property (weak, nonatomic) IBOutlet UIImageView *headViewOfRange;
@property (weak, nonatomic) IBOutlet UILabel *nameOfRange;
@property (weak, nonatomic) IBOutlet UILabel *descriptionOfRange;
@property (weak, nonatomic) IBOutlet UIView *pyramidView;
@property (weak, nonatomic) IBOutlet UIScrollView *parternerScrollView;
@property (weak, nonatomic) IBOutlet UITableView *recommandTableView;
@property (weak, nonatomic) IBOutlet UIImageView *rankHeaderView;
@property (weak, nonatomic) IBOutlet UIImageView *rankLineView;

#define ViewWidth 320
@end
enum
{
    TableViewTypeParterner,
    TableViewTypeRecommand
};
@implementation MyParternersViewController
-(void)viewDidAppear:(BOOL)animated
{
    self.parternerScrollView.contentSize = CGSizeMake(ViewWidth*3, 439);
    self.parternerScrollView.pagingEnabled = YES;
    [self.parternerScrollView setContentOffset:CGPointMake(ViewWidth*selectIndex, 0) animated:YES] ;
    
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (IBAction)backButtonClikc:(id)sender {
    //    UIViewController * hsvc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"HealthStatusNavViewController"];
    //[self.mm_drawerController setCenterViewController:hsvc withCloseAnimation:YES completion:nil];
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    selectIndex = 0;
    self.navigationItem.backBarButtonItem =[[UIBarButtonItem alloc] initWithTitle:@" " style:UIBarButtonItemStyleBordered target:nil action:nil];
    
    noFriendLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
    noFriendLabel.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/3);
    noFriendLabel.text = @"您还没有伙伴哦，快去找伙伴吧";
    noFriendLabel.textAlignment = NSTextAlignmentCenter;
    noFriendLabel.backgroundColor = [UIColor clearColor];
    noFriendLabel.textColor = [UIColor whiteColor];
    noFriendLabel.hidden = YES;
    [self.parternerScrollView addSubview:noFriendLabel];
    
    userPartenerArray = [[NSMutableArray alloc] initWithCapacity:0];
    userIdArray = [[NSMutableArray alloc] initWithCapacity:0];
    userIconArray = [[NSMutableArray alloc] initWithCapacity:0];
    recommendArray = [[NSMutableArray alloc] initWithObjects:@"活跃用户",@"与我相似的", nil];
    PPiFlatSegmentedControl *segmented=[[PPiFlatSegmentedControl alloc] initWithFrame:CGRectMake(12,80, 292, 30) items:@[@{@"text":@"我的伙伴",@"icon":@""},@{@"text":@"排行榜",@"icon":@""},@{@"text":@"推荐",@"icon":@""}                                                                                                                                         ]iconPosition:IconPositionRight andSelectionBlock:^(NSUInteger segmentIndex) {}];
    segmented.color=[UIColor clearColor];
    segmented.borderWidth=1;
    segmented.borderColor= COLOR(54, 148, 254, 1);
    segmented.selectedColor=COLOR(54, 148, 254, 1);;
    segmented.textAttributes=@{NSFontAttributeName:[UIFont systemFontOfSize:13],
                               NSForegroundColorAttributeName:[UIColor whiteColor]};
    segmented.selectedTextAttributes=@{NSFontAttributeName:[UIFont systemFontOfSize:13],
                                       NSForegroundColorAttributeName:[UIColor whiteColor]};
    
    segmented.enabled = YES;
    segmented.delegate = self;
    segmented.userInteractionEnabled  = YES;
    [segmented addTarget:self action:@selector(segmentClick:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:segmented];
    
    
    self.paternerTableView.delegate = self;
    self.paternerTableView.dataSource = self;
    self.paternerTableView.tag = TableViewTypeParterner;
    
    
    self.recommandTableView.delegate = self;
    self.recommandTableView.dataSource =self;
    self.recommandTableView.tag = TableViewTypeRecommand;
    
    [self getMyParterner];
    
    [self setExtraCellLineHidden:self.paternerTableView];
    
    _headViewOfRange.layer.cornerRadius = _rankHeaderView.frame.size.width/2;
    _headViewOfRange.layer.borderWidth = 5;
    _headViewOfRange.layer.masksToBounds = YES;
    _headViewOfRange.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    
    _rankHeaderView.layer.cornerRadius = _rankHeaderView.frame.size.width/2;
    _rankHeaderView.layer.borderWidth = 5;
    _rankHeaderView.layer.masksToBounds = YES;
    _rankHeaderView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    
    
    AppDelegate *appdelegate =(AppDelegate*) [[UIApplication sharedApplication] delegate];
    currentUser = appdelegate.user;
    [self getBeatePesentageWithUserId:[currentUser.userId intValue]];
    
    NSString *str = [NSString stringWithFormat:@"%@%d.png",UserIcon_UrlPre,[currentUser.userId intValue]];
    [_headViewOfRange setImageWithURL:[NSURL URLWithString:str] placeholderImage:[UIImage imageNamed:@""]];
    [_rankHeaderView setImageWithURL:[NSURL URLWithString:str] placeholderImage:[UIImage imageNamed:@""]];
    
}

-(void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}

-(void)getMyParterner {
    
    AppCloundService *service = [[AppCloundService alloc] initWidthDelegate:self];
    [service getUserFriendsWithUserId:[currentUser.userId intValue]];
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


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView.tag == TableViewTypeParterner) {
        return userPartenerArray.count;
    }
    if (tableView.tag == TableViewTypeRecommand) {
        return recommendArray.count;
    }
    return 2;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView.tag == TableViewTypeRecommand) {
        return 64;
    }
    if (tableView.tag == TableViewTypeParterner) {
        return 60;
    }
    return 44;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == TableViewTypeParterner) {
        PaternerTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"PaternerTableViewCell"];
        if (userPartenerArray.count > indexPath.row) {
            NSDictionary *dict = [userPartenerArray objectAtIndex:indexPath.row];
            cell.nameLabel.text = dict[@"NickName"];
            NSString *str = [NSString stringWithFormat:@"%@%@",UserIcon_UrlPre,dict[@"UserIco"]];
            [cell.headView setImageWithURL:[NSURL URLWithString:str] placeholderImage:[UIImage imageNamed:@""]];
        }
        
        return cell;
    }
    if (tableView.tag == TableViewTypeRecommand) {
        RecommandTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"RecommandTableViewCell"];
        cell.nameLabel.text = [recommendArray objectAtIndex:indexPath.row];
        return cell;
    }
    
    return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView.tag == TableViewTypeParterner) {
        //        NSDictionary *dict = [userPartenerArray objectAtIndex:indexPath.row];
        //        [self getBeatePesentageWithUserId:[dict[@"UserID"] intValue]];
        
    }else if (tableView.tag == TableViewTypeRecommand) {
        PeopleListViewController *pvc = [self.storyboard instantiateViewControllerWithIdentifier:@"PeopleListViewController"];
        
        if (indexPath.row == 0) {
            [pvc setComfromType:@"1"];
        } else if (indexPath.row == 1) {
            [pvc setComfromType:@"2"];
        }
        [self.navigationController pushViewController:pvc animated:YES];
    }
    
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
    
    if ([method isEqualToString:@"GetUserFriendsJson"]) {
        if (userPartenerArray.count > 0) {
            [userPartenerArray removeAllObjects];
        }
        if (keyValues.count > 0) {
            noFriendLabel.hidden = YES;
            for (NSDictionary *dict in keyValues) {
                [userPartenerArray addObject:dict];
            }
            [self.paternerTableView reloadData];
        }else {
            noFriendLabel.hidden = NO;
        }
        
    } else if ([method isEqualToString:@"BeatPercentageJson"]) {
        if (keyValues[@"res"]) {
            NSString *str = [NSString stringWithFormat:@"%@",keyValues[@"res"]];
            [self setPecentageWith:str];
        }
    }
    
}

-(void)setPecentageWith:(NSString *)str {
    
    if ([str floatValue] > 0) {
        [UIView animateWithDuration:0.1 animations:^{
            _rankHeaderView.center = CGPointMake(_rankHeaderView.center.x, 180*[str floatValue]/100);
            _rankLineView.center = CGPointMake(_rankLineView.center.x, 180*[str floatValue]/100);
        }];
    } else {
        [UIView animateWithDuration:0.1 animations:^{
            _rankHeaderView.center = CGPointMake(_rankHeaderView.center.x, 180);
            _rankLineView.center = CGPointMake(_rankLineView.center.x, 180);
        }];
    }
    _nameOfRange.text = [NSString stringWithFormat:@"%@",currentUser.nickName];
    _descriptionOfRange.text = [NSString stringWithFormat:@"您的身体状况击败了全国%@%%的用户",str];
    
    
    
}

#pragma mark - 分段选择器选择了index
-(void)PPiFlatSegmentedSelectedSegAtIndex:(int)index
{
    
    if (index == 0) { //我的伙伴
        
        [self getMyParterner];
    } else if (index == 1) {
        
    }else if (index == 2) {
        
    }
    selectIndex = index;
    [self.parternerScrollView setContentOffset:CGPointMake(index*ViewWidth, 0)];
    
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
