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
#import "CXAlertView.h"
#import "AddFoodViewController.h"
#import "AppDelegate.h"

@interface TodayMealViewController ()<PPiFlatSegmentedDelegate,UITableViewDataSource,UITableViewDelegate> {
    NSDate *currentDate;
    NSMutableArray *tempArr;
    NSInteger tempIndex;
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

- (IBAction)previoutDateClicked:(id)sender {
    NSDateComponents *components = [[NSDateComponents alloc] init];
    components.day = -1;
    NSDate *date = [[NSCalendar currentCalendar] dateByAddingComponents:components toDate:currentDate options:0];
    currentDate = date;
    NSDateFormatter *formate = [[NSDateFormatter alloc] init];
//    [formate setDateFormat:@"yyyy年MM月dd日"];
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    if (appDelegate.languageIndex == 1) {//英文
        [formate setDateFormat:@"MM-dd-yyyy"];
    } else {
        [formate setDateFormat:@"yyyy年MM月dd日"];
    }
    _showDateLabel.text = [formate stringFromDate:currentDate];
    [self getDaliDataWithDate:currentDate];
    
}
- (IBAction)nextDateClicked:(id)sender {
    
    
    NSDateFormatter *formate = [[NSDateFormatter alloc] init];
//    [formate setDateFormat:@"yyyy年MM月dd日"];
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    if (appDelegate.languageIndex == 1) {//英文
        [formate setDateFormat:@"MM-dd-yyyy"];
    } else {
        [formate setDateFormat:@"yyyy年MM月dd日"];
    }
    if ([currentDate compare:[NSDate date]] >= 0) {
        return ;
    } else {
        NSDateComponents *components = [[NSDateComponents alloc] init];
        components.day = 1;
        NSDate *date = [[NSCalendar currentCalendar] dateByAddingComponents:components toDate:currentDate options:0];
        currentDate = date;
        NSDateFormatter *formate = [[NSDateFormatter alloc] init];
//        [formate setDateFormat:@"yyyy年MM月dd日"];
        AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
        if (appDelegate.languageIndex == 1) {//英文
            [formate setDateFormat:@"MM-dd-yyyy"];
        } else {
            [formate setDateFormat:@"yyyy年MM月dd日"];
        }
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
//    [formate setDateFormat:@"yyyy年MM月dd日"];
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    if (appDelegate.languageIndex == 1) {//英文
        [formate setDateFormat:@"MM-dd-yyyy"];
    } else {
        [formate setDateFormat:@"yyyy年MM月dd日"];
    }
    _showDateLabel.text = [formate stringFromDate:date];
    
    formate = [[NSDateFormatter alloc] init];
//    [formate setDateFormat:@"yyyy-MM-dd"];
    if (appDelegate.languageIndex == 1) {//英文
        [formate setDateFormat:@"MM-dd-yyyy"];
    } else {
        [formate setDateFormat:@"yyyy-MM-dd"];
    }
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
    
    NSMutableAttributedString *attring = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:CustomLocalizedString(@"todayCalories", nil),cal_dinner+cal_break+cal_lunch+cal_add]];
    NSString *ssss = [NSString stringWithFormat:@"%.1f",cal_dinner+cal_break+cal_lunch+cal_add];
    
    AppDelegate *appdelegate = [UIApplication sharedApplication].delegate;
    if (appdelegate.languageIndex == 1) {//英文
        [attring addAttribute:NSForegroundColorAttributeName value:[UIColor yellowColor] range:NSMakeRange(18, ssss.length+1)];
    } else {//中文
        [attring addAttribute:NSForegroundColorAttributeName value:[UIColor yellowColor] range:NSMakeRange(5, ssss.length+1)];

    }
    _cal_allDayLabel.attributedText = attring;
    
    [_mealDetailTableView reloadData];
    
}

-(void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
}

-(void)viewDidLayoutSubviews
{
    CGFloat height = self.mealDetailTableView.frame.size.height;
    self.mealDetailTableView.frame = CGRectMake(self.mealDetailTableView.frame.origin.x, self.mealDetailTableView.frame.origin.y, self.mealDetailTableView.frame.size.width, height - 10);
    [self getDaliDataWithDate:currentDate];
}

- (void)viewDidLoad
{

    [super viewDidLoad];
    PPiFlatSegmentedControl *segmented=[[PPiFlatSegmentedControl alloc] initWithFrame:CGRectMake(10,80, 300, 30) items:@[@{@"text":CustomLocalizedString(@"labelWeek", nil),@"icon":@"icon-time"},@{@"text":CustomLocalizedString(@"labelMonth", nil),@"icon":@"icon-calendar"},@{@"text":CustomLocalizedString(@"labelSeason", nil),@"icon":@"icon-smile"},@{@"text":CustomLocalizedString(@"labelYear", nil),@"icon":@"icon-cloud-download"}]iconPosition:IconPositionRight andSelectionBlock:^(NSUInteger segmentIndex) {
                                                                             
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
    
    _todayMeal_BreakArr = [[NSMutableArray alloc] initWithCapacity:0];
    _todayMeal_LounchArr = [[NSMutableArray alloc] initWithCapacity:0];
    _todayMeal_DinnerArr = [[NSMutableArray alloc] initWithCapacity:0];
    _todayMeal_AddArr = [[NSMutableArray alloc] initWithCapacity:0];
    
    //取当天的膳食记录
    currentDate = [NSDate date];
    
    tempArr = [NSMutableArray array];
    tempIndex = 0;
    
    //该方法放到viewDidLayoutSubviews中
//    [self getDaliDataWithDate:currentDate];
    
    UILongPressGestureRecognizer *gestureLongPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(gestureLongPress:)];
    gestureLongPress.minimumPressDuration =1;
    [self.mealDetailTableView addGestureRecognizer:gestureLongPress];
    
    [self downloadFoodDict];
}

-(void)initUI
{
    UIColor *borderColor = [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:0.2];
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
#pragma mark－ 添加餐点
- (IBAction)addButtonClick:(id)sender {
    /*
     FoodSuggestionsViewController * ssvc = [self.storyboard instantiateViewControllerWithIdentifier:@"FoodSuggestionsViewController"];
     ssvc.navBar.title = @"营养建议";
     ssvc.suggestion=@"根据您的体测成绩，建议您多吃新鲜蔬菜，如青菜可以补充VC，它可以让您更健康。";
     NTSlidingViewController *uv = (NTSlidingViewController *)superview;
     [UIView animateWithDuration:5.0 animations:^{
     uv.navigationBar.hidden=YES;
     }];
     [self presentPopupViewController:ssvc animated:YES completion:^(void) {
     
     }];
     */
    FoodRecordViewController * ssvc = [self.storyboard instantiateViewControllerWithIdentifier:@"FoodRecordViewController"];
    NTSlidingViewController *uv = (NTSlidingViewController *)superview;
    uv.superview=self;
    [uv setIndexText:1 txt:CustomLocalizedString(@"ChooseMeal", nil)];
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

#pragma mark - 长按手势
- (void)gestureLongPress:(UILongPressGestureRecognizer *)gestureRecognizer
{
    NSDateFormatter *formate = [[NSDateFormatter alloc] init];
//    [formate setDateFormat:@"yyyy年MM月dd日"];
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    if (appDelegate.languageIndex == 1) {//英文
        [formate setDateFormat:@"MM-dd-yyyy"];
    } else {
        [formate setDateFormat:@"yyyy年MM月dd日"];
    }
    _showDateLabel.text = [formate stringFromDate:currentDate];
    if ([self.showDateLabel.text isEqualToString:[formate stringFromDate:[NSDate date]]]) {
        CGPoint tmpPointTouch = [gestureRecognizer locationInView:self.mealDetailTableView];
        if (gestureRecognizer.state ==UIGestureRecognizerStateBegan) {
            NSIndexPath *indexPath = [self.mealDetailTableView indexPathForRowAtPoint:tmpPointTouch];
            if (indexPath == nil) {
                NSLog(@"not tableView");
            }else{
                switch (indexPath.section) {
                    case 0:
                        [self showDeleteAlertViewWithArr:_todayMeal_BreakArr index:indexPath.row];
                        break;
                    case 1:
                        [self showDeleteAlertViewWithArr:_todayMeal_LounchArr index:indexPath.row];
                        break;
                    case 2:
                        [self showDeleteAlertViewWithArr:_todayMeal_DinnerArr index:indexPath.row];
                        break;
                    case 3:
                        [self showDeleteAlertViewWithArr:_todayMeal_AddArr index:indexPath.row];
                        break;
                    default:
                        break;
                }
            }
        }

    }else{
//        CXAlertView *alertViewMe = [[CXAlertView alloc] initWithTitle:@"提示" message:@"只能删除今日膳食" cancelButtonTitle:@"好的"];
        UIAlertController *controller = [UIAlertController alertControllerWithTitle:CustomLocalizedString(@"tip", nil) message:CustomLocalizedString(@"OnlyDleTodayDiet", nil) preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *actionOK = [UIAlertAction actionWithTitle:CustomLocalizedString(@"OK", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [controller addAction:actionOK];
        [self presentViewController:controller animated:YES completion:^{
            
        }];
    }
}

#pragma mark - UITableViewDataSource
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
        cell.calorie.text = [NSString stringWithFormat:@"%@ %@",food.calorieValue,CustomLocalizedString(@"calories", nil)];
    }
    return cell;
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSArray * mealArray = [NSArray arrayWithObjects:CustomLocalizedString(@"FoodBreakfast", nil),CustomLocalizedString(@"FoodLunch", nil),CustomLocalizedString(@"FoodDinner", nil),CustomLocalizedString(@"extraMeal", nil), nil];
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

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDateFormatter *formate = [[NSDateFormatter alloc] init];
//    [formate setDateFormat:@"yyyy年MM月dd日"];
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    if (appDelegate.languageIndex == 1) {//英文
        [formate setDateFormat:@"MM-dd-yyyy"];
    } else {
        [formate setDateFormat:@"yyyy年MM月dd日"];
    }
    _showDateLabel.text = [formate stringFromDate:currentDate];
    if ([self.showDateLabel.text isEqualToString:[formate stringFromDate:[NSDate date]]]) {
        DalidFood *foodUpdated;
        switch (indexPath.section) {
            case 0:
                foodUpdated = _todayMeal_BreakArr[indexPath.row];
                break;
            case 1:
                foodUpdated = _todayMeal_LounchArr[indexPath.row];
                break;
            case 2:
                foodUpdated = _todayMeal_DinnerArr[indexPath.row];
                break;
            case 3:
                foodUpdated = _todayMeal_AddArr[indexPath.row];
                break;
            default:
                break;
        }
        FoodDictionary * fDictionary = [FoodDictionary MR_findFirstWithPredicate:[NSPredicate predicateWithFormat:@"foodId==%d",[foodUpdated.foodId intValue]]];
        if(fDictionary!=nil)
        {
            [self changeToAddFoodVC:fDictionary andDalidFood:foodUpdated];
        }
    }else{
        UIAlertController *controller = [UIAlertController alertControllerWithTitle:CustomLocalizedString(@"tip", nil) message:CustomLocalizedString(@"OnlyModTodayDiet", nil) preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *actionOK = [UIAlertAction actionWithTitle:CustomLocalizedString(@"OK", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [controller addAction:actionOK];
        [self presentViewController:controller animated:YES completion:^{
            
        }];
    }

}

-(void)changeToAddFoodVC:(FoodDictionary *)foodDict andDalidFood:(DalidFood*)foodDalid{
    
//    FoodRecordViewController * ssvc = [self.storyboard instantiateViewControllerWithIdentifier:@"FoodRecordViewController"];
//    NTSlidingViewController *uv = (NTSlidingViewController *)superview;
//    uv.superview=self;
//    [uv setIndexText:1 txt:@"选择膳食"];
//    ssvc.superview=uv;
//    [self presentPopupViewController:ssvc animated:true completion:nil];
    

    AddFoodViewController * afvc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"AddFoodViewController"];
    NTSlidingViewController *uv = (NTSlidingViewController *)superview;
    uv.superview = self;
    [uv setIndexText:1 txt:CustomLocalizedString(@"ModifyDietary", nil)];
    afvc.superview = uv;
    [afvc setFoodDictionary:foodDict];
    [afvc setDalidFood:foodDalid];
    afvc.isUpdate = 1; 
    [self presentPopupViewController:afvc animated:true completion:nil];
}

-(void)showDeleteAlertViewWithArr:(NSMutableArray*)foodArr index:(NSInteger)arrIndex
{
    CXAlertView *alertViewMe = [[CXAlertView alloc] initWithTitle:CustomLocalizedString(@"tip", nil) message:CustomLocalizedString(@"DelDietary", nil) cancelButtonTitle:nil];
    
    [alertViewMe addButtonWithTitle:CustomLocalizedString(@"cancel", nil)
                               type:CXAlertViewButtonTypeCancel
                            handler:^(CXAlertView *alertView, CXAlertButtonItem *button) {
                                [alertView dismiss];
                                
                            }];
    
    [alertViewMe addButtonWithTitle:CustomLocalizedString(@"yes", nil)
                               type:CXAlertViewButtonTypeDefault
                            handler:^(CXAlertView *alertView, CXAlertButtonItem *button) {
                                [alertView dismiss];
                                
                                tempArr = foodArr;
                                tempIndex = arrIndex;
                                
                                //userid
                                AppDelegate *appdelegate =(AppDelegate*) [[UIApplication sharedApplication] delegate];
                                User* user = appdelegate.user;
                                
                                //foodid
                                DalidFood *foodDeleted = [foodArr objectAtIndex:arrIndex];
                                NSDateFormatter *formater = [[NSDateFormatter alloc] init];
                                [formater setDateFormat:@"yyyy-MM-dd"];
                                NSString *string = [formater stringFromDate:foodDeleted.intakeDate];
                                AppCloundService* service = [[AppCloundService alloc] initWidthDelegate:self];
                                
                                [service deleteFoodInfoWithUserId:[user.userId intValue] foodId:[foodDeleted.foodId intValue] intakeValue:[NSString stringWithFormat:@"%.2f",foodDeleted.intakeValue.floatValue] calorieValuer:[NSString stringWithFormat:@"%.2f",foodDeleted.calorieValue.floatValue] intakeDate:string andType:[NSString stringWithFormat:@"%d",foodDeleted.type.intValue]];

                            }];
    
    
    
    [alertViewMe show];
}

#pragma mark - Serviece delegate
-(void)serviceSuccessed:(NSDictionary*)keyValues pMethod:(NSString*)method
{
    if ([method isEqualToString:@"DeleteFoodByIdJson"]) {
        if ([keyValues[@"res"] intValue] == 8) {
            NSLog(@"删除膳食成功");

            AppDelegate *appdelegate =(AppDelegate*) [[UIApplication sharedApplication] delegate];
            User* user = appdelegate.user;
            DalidFood *foodDeleted = [tempArr objectAtIndex:tempIndex];
            // NSPredicate
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"userId==%d AND foodId==%d AND intakeValue==%f AND calorieValue==%f AND intakeDate==%@ AND type==%d",user.userId.intValue,foodDeleted.foodId.intValue,foodDeleted.intakeValue.floatValue,foodDeleted.calorieValue.floatValue,foodDeleted.intakeDate,foodDeleted.type.intValue];
            
            NSArray *foodsArr = [DalidFood MR_findAllWithPredicate:predicate];
            
            if (foodsArr.count>0) {
                for (DalidFood *food in foodsArr) {
                    
                    if (food == [foodsArr objectAtIndex:0]) {
                        [food MR_deleteEntity];
                    }
                    
                }
                [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
            }
           
            NSDateFormatter *formate = [[NSDateFormatter alloc] init];
//            [formate setDateFormat:@"yyyy年MM月dd日"];
            AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
            if (appDelegate.languageIndex == 1) {//英文
                [formate setDateFormat:@"MM-dd-yyyy"];
            } else {
                [formate setDateFormat:@"yyyy年MM月dd日"];
            }
            NSDate *date = [formate dateFromString:self.showDateLabel.text];
            [self getDaliDataWithDate:date];
            
        }else{
            NSLog(@"删除膳食失败");
        }
        
    }else if ([method isEqualToString:@"LanguageGetFoodDictionaryJson"])
    { //返回系统膳食
        /*
         if (_foodArray.count > 0) {
         [_foodArray removeAllObjects];
         }
         */
        
        for (NSDictionary * dic in keyValues) {
            
            NSArray *array = [FoodDictionary MR_findByAttribute:@"foodId" withValue:dic[@"FoodID"]  inContext:[NSManagedObjectContext MR_defaultContext]];
            if (array.count > 0) {
                FoodDictionary *fDictionary = array[0];
                [fDictionary setClassId:[NSNumber numberWithInt:[dic[@"ClassId"]intValue]]];
                if (dic[@"FoodName"]!=nil&& (NSNull *)dic[@"FoodName"] != [NSNull null]) {
                    [fDictionary setFoodName:dic[@"FoodName"]];
                }
                [fDictionary setFoodId:[NSNumber numberWithInt:[dic[@"FoodID"]intValue]]];
                [fDictionary setGramValue:[NSNumber numberWithInt:[dic[@"GramValue"] intValue]]];
                [fDictionary setCaloriesValue:[NSNumber numberWithInt:[dic[@"CaloriesValue"]intValue]]];
                [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
            } else {
                FoodDictionary *fDictionary = [FoodDictionary MR_createEntity];
                [fDictionary setClassId:[NSNumber numberWithInt:[dic[@"ClassId"]intValue]]];
                if (dic[@"FoodName"]!=nil&& (NSNull *)dic[@"FoodName"] != [NSNull null]) {
                    [fDictionary setFoodName:dic[@"FoodName"]];
                }
                [fDictionary setFoodId:[NSNumber numberWithInt:[dic[@"FoodID"]intValue]]];
                [fDictionary setGramValue:[NSNumber numberWithInt:[dic[@"GramValue"] intValue]]];
                [fDictionary setCaloriesValue:[NSNumber numberWithInt:[dic[@"CaloriesValue"]intValue]]];
                [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
            }
        }
    }
}

-(void)serviceFailed:(NSString*) message pMethod:(NSString*)method;
{
    NSLog(@"删除失败");
}

-(void)PPiFlatSegmentedSelectedSegAtIndex:(int)index
{
    
}

#pragma mark - 下载食物
-(void)downloadFoodDict
{
    AppCloundService * foodArrayRequest = [[AppCloundService alloc]initWidthDelegate:self];
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    //        [foodArrayRequest getFoodDictionary];
    if (appDelegate.languageIndex == 1) {//英语
        [foodArrayRequest LanguageGetFoodDictionary:2];
    } else {
        [foodArrayRequest LanguageGetFoodDictionary:1];
    }
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
