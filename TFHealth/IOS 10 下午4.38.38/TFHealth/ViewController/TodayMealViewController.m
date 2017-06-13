//
//  TodayMealViewController.m
//  TFHealth
//
//  Created by hzth hzth－mac2 on 6/13/14.
//  Copyright (c) 2014 studio37. All rights reserved.
//

#import "TodayMealViewController.h"
#import "PPiFlatSegmentedControl.h"
#import "MealFoodTableViewCell.h"
#import "UIViewController+MMDrawerController.h"
#import "MealCalendarViewController.h"
#import "FoodRecordViewController.h"
#import "APPCloundService.h"
#import "AppDelegate.h"
#import "DalidFood.h"
#import "UIViewController+CWPopup.h"
#import "NTSlidingViewController.h"

@interface TodayMealViewController ()<PPiFlatSegmentedDelegate,UITableViewDataSource,UITableViewDelegate> {
    NSDate *currentDate;
}
@property (weak, nonatomic) IBOutlet UITableView *mealDetailTableView;
@property (nonatomic,retain) NSMutableArray *todayMealArray;
@property (nonatomic,retain) NSMutableArray *todayMeal_BreakArr;
@property (nonatomic,retain) NSMutableArray *todayMeal_LounchArr;
@property (nonatomic,retain) NSMutableArray *todayMeal_DinnerArr;
@property (nonatomic,retain) NSMutableArray *todayMeal_AddArr;

@property (weak, nonatomic) IBOutlet UILabel *showDateLabel;

@property (weak, nonatomic) IBOutlet UILabel *cal_morningLabel;
@property (weak, nonatomic) IBOutlet UILabel *cal_afternoonLabel;
@property (weak, nonatomic) IBOutlet UILabel *cal_eveningLabel;
@property (weak, nonatomic) IBOutlet UILabel *cal_addLabel;
@property (weak, nonatomic) IBOutlet UILabel *cal_allDayLabel;
@property (weak, nonatomic) IBOutlet UIView *today_date_container;


@end

@implementation TodayMealViewController
@synthesize superview;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated {
    
}
- (IBAction)previoutDateClicked:(id)sender {
    NSDateComponents *components = [[NSDateComponents alloc] init];
    components.day = -1;
    NSDate *date = [[NSCalendar currentCalendar] dateByAddingComponents:components toDate:currentDate options:0];
    currentDate = date;
    NSDateFormatter *formate = [[NSDateFormatter alloc] init];
    [formate setDateFormat:@"yyyy年MM月dd日"];
    _showDateLabel.text = [formate stringFromDate:currentDate];
    [self getDaliDataWithDate:currentDate];
    
}
- (IBAction)nextDateClicked:(id)sender {
    
    
    NSDateFormatter *formate = [[NSDateFormatter alloc] init];
    [formate setDateFormat:@"yyyy年MM月dd日"];
    if ([currentDate compare:[NSDate date]] >= 0) {
        return ;
    } else {
        NSDateComponents *components = [[NSDateComponents alloc] init];
        components.day = 1;
        NSDate *date = [[NSCalendar currentCalendar] dateByAddingComponents:components toDate:currentDate options:0];
        currentDate = date;
        NSDateFormatter *formate = [[NSDateFormatter alloc] init];
        [formate setDateFormat:@"yyyy年MM月dd日"];
        _showDateLabel.text = [formate stringFromDate:currentDate];
        [self getDaliDataWithDate:currentDate];
    }
    
}

-(void)getDaliDataWithDate:(NSDate *)date {
    
    [_todayMeal_BreakArr removeAllObjects];
    [_todayMeal_LounchArr removeAllObjects];
    [_todayMeal_DinnerArr removeAllObjects];
    [_todayMeal_AddArr removeAllObjects];
    
    NSDateFormatter *formate = [[NSDateFormatter alloc] init];
    [formate setDateFormat:@"yyyy年MM月dd日"];
    _showDateLabel.text = [formate stringFromDate:date];
    
    formate = [[NSDateFormatter alloc] init];
    [formate setDateFormat:@"yyyy-MM-dd"];
    NSString *string = [formate stringFromDate:currentDate];
    NSDate *paraDate = [formate dateFromString:string];
    
    NSArray *array = [DalidFood MR_findByAttribute:@"intakeDate" withValue:paraDate inContext:[NSManagedObjectContext MR_defaultContext]];
    for (DalidFood *foodD in array) {
        if ([foodD.type intValue] == 0) {
            [_todayMeal_BreakArr addObject:foodD];
        }else if ([foodD.type intValue] == 1) {
            [_todayMeal_LounchArr addObject:foodD];
        }else if ([foodD.type intValue] == 2) {
            [_todayMeal_DinnerArr addObject:foodD];
        } else if ([foodD.type intValue] == 3) {
            [_todayMeal_AddArr addObject:foodD];
        }
        
        
    }
    float cal_break=0;
    for (DalidFood *d in _todayMeal_BreakArr) {
        cal_break += [d.calorieValue floatValue];
    }
    _cal_morningLabel.text = [NSString stringWithFormat:@"%.1f",cal_break];
    float cal_lunch = 0;
    for (DalidFood *d in _todayMeal_LounchArr) {
        cal_lunch += [d.calorieValue floatValue];
    }
    _cal_afternoonLabel.text = [NSString stringWithFormat:@"%.1f",cal_lunch];
    float cal_dinner = 0;
    for (DalidFood *d in _todayMeal_DinnerArr) {
        cal_dinner += [d.calorieValue floatValue];
    }
    _cal_eveningLabel.text = [NSString stringWithFormat:@"%.1f",cal_dinner];
    
    float cal_add = 0;
    for (DalidFood *d in _todayMeal_AddArr) {
        cal_add += [d.calorieValue floatValue];
    }
    _cal_addLabel.text = [NSString stringWithFormat:@"%.1f",cal_add];
    
    NSMutableAttributedString *attring = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"今日摄入 %.1f 卡路里",cal_dinner+cal_break+cal_lunch+cal_add]];
    NSString *ssss = [NSString stringWithFormat:@"%.1f",cal_dinner+cal_break+cal_lunch+cal_add];
    [attring addAttribute:NSForegroundColorAttributeName value:[UIColor yellowColor] range:NSMakeRange(5, ssss.length+1)];
    _cal_allDayLabel.attributedText = attring;
    
    [_mealDetailTableView reloadData];
    
}
- (void)viewDidLoad
{

    [super viewDidLoad];
    PPiFlatSegmentedControl *segmented=[[PPiFlatSegmentedControl alloc] initWithFrame:CGRectMake(10,80, 300, 30) items:@[@{@"text":@"周",@"icon":@"icon-time"},@{@"text":@"月",@"icon":@"icon-calendar"},@{@"text":@"季",@"icon":@"icon-smile"},@{@"text":@"年",@"icon":@"icon-cloud-download"}]iconPosition:IconPositionRight andSelectionBlock:^(NSUInteger segmentIndex) {
                                                                             
                                                                         }];
    segmented.color=[UIColor clearColor];
    segmented.borderWidth=1;
    segmented.borderColor= COLOR(54, 148, 254, 1);
    segmented.selectedColor=COLOR(54, 148, 254, 1);;
    segmented.textAttributes=@{NSFontAttributeName:[UIFont systemFontOfSize:13],
                               NSForegroundColorAttributeName:[UIColor whiteColor]};
    segmented.selectedTextAttributes=@{NSFontAttributeName:[UIFont systemFontOfSize:13],
                                       NSForegroundColorAttributeName:[UIColor whiteColor]};
    
    segmented.enabled = YES;
    segmented.userInteractionEnabled  = YES;
    [segmented addTarget:self action:@selector(segmentClick:) forControlEvents:UIControlEventValueChanged];
    segmented.delegate = self;
    //    [self.view addSubview:segmented];
    self.mealDetailTableView.delegate = self;
    self.mealDetailTableView.dataSource = self;
    [self initUI];
    
    //取当天的膳食记录
    currentDate = [NSDate date];
    
    
    _todayMeal_BreakArr = [[NSMutableArray alloc] initWithCapacity:0];
    _todayMeal_LounchArr = [[NSMutableArray alloc] initWithCapacity:0];
    _todayMeal_DinnerArr = [[NSMutableArray alloc] initWithCapacity:0];
    _todayMeal_AddArr = [[NSMutableArray alloc] initWithCapacity:0];
    [self getDaliDataWithDate:currentDate];
    
    // Do any additional setup after loading the view.
}

-(void)initUI
{
    UIColor *borderColor = [UIColor colorWithRed:255.0 green:255.0 blue:255.0 alpha:0.2];
    _today_date_container.layer.masksToBounds = YES;
    _today_date_container.layer.cornerRadius = 6.0;
    _today_date_container.layer.borderWidth = 1.0;
    _today_date_container.layer.borderColor = [borderColor CGColor];
    _today_date_container.layer.backgroundColor=[borderColor CGColor];
}

/*
 根据请求数据处理页面
 */
-(void)setSubViewValus {
    
}

- (IBAction)backButtonClikc:(id)sender {
    UIViewController * hsvc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"HealthStatusNavViewController"];
    //[self.mm_drawerController setCenterViewController:hsvc withCloseAnimation:YES completion:nil];
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}

- (IBAction)calendarButtonClick:(id)sender {
    MealCalendarViewController * ssvc = [self.storyboard instantiateViewControllerWithIdentifier:@"MealCalendarViewController"];
    //[self.navigationController pushViewController:ssvc animated:YES];
    [self presentPopupViewController:ssvc animated:true completion:nil];
    
}

- (IBAction)addButtonClick:(id)sender {
    FoodRecordViewController * ssvc = [self.storyboard instantiateViewControllerWithIdentifier:@"FoodRecordViewController"];
    NTSlidingViewController *uv = (NTSlidingViewController *)superview;
    uv.superview=self;
    [uv setIndexText:1 txt:@"选择膳食"];
    ssvc.superview=uv;
    [self presentPopupViewController:ssvc animated:true completion:nil];
}
     

- (void)dismissPopup {
    if (self.popupViewController != nil) {
        [self dismissPopupViewControllerAnimated:YES completion:^{
            NTSlidingViewController *uv = (NTSlidingViewController *)superview;
            [UIView animateWithDuration:0.1 animations:^{
                uv.navigationBar.hidden=NO;
            }];
            NSLog(@"popup view dismissed");
        }];
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return _todayMeal_BreakArr.count;
            break;
        case 1:
            return _todayMeal_LounchArr.count;
            break;
        case 2:
            return _todayMeal_DinnerArr.count;
            break;
        case 3:
            return _todayMeal_AddArr.count;
            break;
        default:
            break;
    }
    return 1;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MealFoodTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"MealFoodTableViewCell"];
    
    cell.foodNameLabel.text = @"设置食物名";
    cell.numLabel.text = @"500g";
    cell.calorie.text = @"120卡路里";
    DalidFood *food;
    switch (indexPath.section) {
        case 0:
            food = [_todayMeal_BreakArr objectAtIndex:indexPath.row];
            break;
        case 1:
            food = [_todayMeal_LounchArr objectAtIndex:indexPath.row];
            break;
        case 2:
            food = [_todayMeal_DinnerArr objectAtIndex:indexPath.row];
            break;
        case 3:
            food = [_todayMeal_AddArr objectAtIndex:indexPath.row];
            break;
        default:
            break;
    }
    if (food) {
        cell.foodNameLabel.text = food.foodName;
        cell.numLabel.text = [NSString stringWithFormat:@"%@ g", food.intakeValue];
        cell.calorie.text = [NSString stringWithFormat:@"%@ 卡路里",food.calorieValue];
    }
    return cell;
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSArray * mealArray = [NSArray arrayWithObjects:@"早餐食品",@"午餐食品",@"晚餐食品",@"加餐食品", nil];
    NSArray * imageNameArray = [NSArray arrayWithObjects:@"24_icon_breakfast_big",@"24_icon_lunch_big",@"24_icon_dinner_big",@"24_icon_breakfast_big",nil];
    UIView * header = [[UIView alloc]initWithFrame:CGRectMake(15, 0, 294, 30)];
    header.backgroundColor = UIColorFromRGB(0x6cbbff);
    UIView * headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 30)];
    headerView.backgroundColor = [UIColor clearColor];
    [headerView addSubview:header];
    
    UILabel * mealLabel = [[UILabel alloc]initWithFrame:CGRectMake(25, 0, 100, 30)];
    mealLabel.text = [mealArray objectAtIndex:section];
    mealLabel.font = [UIFont systemFontOfSize:13];
    mealLabel.textColor = [UIColor whiteColor];
    [headerView addSubview:mealLabel];
    
    UIImageView * mealImageView = [[UIImageView alloc]initWithFrame:CGRectMake(275, 0, 28, 28)];
    [mealImageView setImage:[UIImage imageNamed:[imageNameArray objectAtIndex:section]]];
    [headerView addSubview:mealImageView];
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 35;//section头部高度
}

-(void)PPiFlatSegmentedSelectedSegAtIndex:(int)index
{
    
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
