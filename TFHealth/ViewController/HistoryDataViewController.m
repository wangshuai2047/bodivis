//
//  HistoryDataViewController.m
//  TFHealth
//
//  Created by hzth hzth－mac2 on 6/7/14.
//  Copyright (c) 2014 studio37. All rights reserved.
//

#import "HistoryDataViewController.h"
#import "PPiFlatSegmentedControl.h"
#import "NSString+FontAwesome.h"
#import "BEMSimpleLineGraphView.h"
#import "LineGraphView.h"
#import "HealthStatusViewController.h"
#import "UIViewController+MMDrawerController.h"
#import "AppDelegate.h"
#import "ReportModel.h"
#import "User_Item_Info.h"
#import "TestItemID.h"
#import "TestItemCalc.h"
#import "AppCloundService.h"
#import "User.h"
#import "WSLineChartView.h"
#import "MBProgressHUD.h"

@interface HistoryDataViewController ()<BEMSimpleLineGraphDelegate,PPiFlatSegmentedDelegate,ServiceObjectDelegate>
{
    NSMutableArray *allDataMarr;//用户存储历史数据
    int dateIndex,itemIndex;//分别存储周月季年的下标值,体重、脂肪、水分、肌肉的下标值，默认均为0第一项
    
    MBProgressHUD *loading;
    
}
@property (weak, nonatomic) IBOutlet UIView *ChartSuperView;
@property (strong,nonatomic) BEMSimpleLineGraphView * weightLineGraph;
@property (strong,nonatomic) BEMSimpleLineGraphView * fatLineGraph;
@property (strong, nonatomic) NSMutableArray *ArrayOfValues;
@property (strong, nonatomic) NSMutableArray *ArrayOfDates;
@property (weak, nonatomic) IBOutlet UIView *date_container;
@property (weak, nonatomic) IBOutlet UIView *chart_container;
@property (weak, nonatomic) IBOutlet UIView *chart_simple_container;
@property (nonatomic,copy)  NSDate* startDate;
@property (nonatomic,copy)  NSDate* endDate;
@property (assign, nonatomic) int days;
@property (weak, nonatomic) IBOutlet UILabel *date_label;
- (IBAction)beforeDateClicked:(id)sender;
- (IBAction)nextDateClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *dot1;
@property (weak, nonatomic) IBOutlet UIView *dot2;
@property (weak, nonatomic) IBOutlet UIView *dot3;
@property (weak, nonatomic) IBOutlet UIView *dot4;
@end

@implementation HistoryDataViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (IBAction)backButtonClikc:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 获取用户数据
//查询用户数据  type:1每周，2每月，3每季，4每年
-(void)getUserDataWithType:(int)type startDate:(NSDate*)startDate enDate:(NSDate*)enDate
{
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    loading = [MBProgressHUD showHUDAddedTo:appDelegate.window animated:YES];
    loading.dimBackground = YES;
    loading.animationType = 2;
    AppCloundService *service = [[AppCloundService alloc] initWidthDelegate:self];
    AppDelegate *appdelegate =(AppDelegate*) [[UIApplication sharedApplication] delegate];
    User* user = appdelegate.user;
    [service GetUserItemsByDateJsonWithappUserId:user.userId.intValue type:type startDate:startDate endDate:enDate];

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    allDataMarr = [NSMutableArray array];
    dateIndex = 0;
    itemIndex = 0;
    
    _endDate = [NSDate date];
    _startDate = [_endDate dateByAddingTimeInterval:(-7*24*60*60)];
    _days=7;
    
    [self initSegmentCtrl];
    
    [self initCalendarCtrl];
    
//    [self initChart];
    [self getUserDataWithType:dateIndex startDate:_startDate enDate:_endDate];
    
    [self initUI];
    
    //分别为体重、脂肪、水分、肌肉添加点击功能
    [self addBtnClick];
    
}

-(void)addBtnClick
{

    for (UIView *view in self.chart_simple_container.subviews) {
        
        for (UIView *subView in view.subviews) {
            if ([subView isKindOfClass:[UILabel class]]) {
                UILabel *label = (UILabel*)subView;
                if ([label.text isEqualToString:CustomLocalizedString(@"labelWeight", nil)]) {
                    //体重
                    
                    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
                    btn.frame = CGRectMake(0, 0, view.frame.size.width, view.frame.size.height);
                    btn.backgroundColor = [UIColor clearColor];
                    btn.tag = 1;
                    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
                    [view addSubview:btn];
                    
                    
                }
                else if ([label.text isEqualToString:CustomLocalizedString(@"labelFat", nil)])
                {
                    //脂肪
                    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
                    btn.frame = CGRectMake(0, 0, view.frame.size.width, view.frame.size.height);
                    btn.backgroundColor = [UIColor clearColor];
                    btn.tag = 2;
                    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
                    [view addSubview:btn];
                    
                }
                else if ([label.text isEqualToString:CustomLocalizedString(@"labelWater", nil)])
                {
                    //水分
                    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
                    btn.frame = CGRectMake(0, 0, view.frame.size.width, view.frame.size.height);
                    btn.backgroundColor = [UIColor clearColor];
                    btn.tag = 3;
                    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
                    [view addSubview:btn];
                    
                }
                else if ([label.text isEqualToString:CustomLocalizedString(@"labelMuscle", nil)])
                {
                    //肌肉
                    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
                    btn.frame = CGRectMake(0, 0, view.frame.size.width, view.frame.size.height);
                    btn.backgroundColor = [UIColor clearColor];
                    btn.tag = 4;
                    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
                    [view addSubview:btn];
                    
                }
            }
        }
    }
}

-(void)initSegmentCtrl
{
    PPiFlatSegmentedControl *segmented=[[PPiFlatSegmentedControl alloc] initWithFrame:CGRectMake(10,80, 300, 30) items:@[@{@"text":CustomLocalizedString(@"labelWeek", nil),@"icon":@"icon-time"},@{@"text":CustomLocalizedString(@"labelMonth", nil),@"icon":@"icon-calendar"},@{@"text":CustomLocalizedString(@"labelSeason", nil),@"icon":@"icon-smile"},@{@"text":CustomLocalizedString(@"labelYear", nil),@"icon":@"icon-cloud-download"}]iconPosition:IconPositionRight andSelectionBlock:^(NSUInteger segmentIndex) {}];
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
    segmented.delegate=self;
    [segmented addTarget:self action:@selector(segmentClick:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:segmented];
}

-(void)initSingleChartWithXArray:(NSArray*)xArray YArray:(NSArray*)yArray YMax:(CGFloat)yMax YMin:(CGFloat)yMin lineColor:(UIColor*)lineColor
{
    int isubview =0;
    for(UIView* view in self.ChartSuperView.subviews)
    {
        if (isubview>1) {
            [view removeFromSuperview];
        }
        isubview++;
    }
    WSLineChartView *wsLineView = [[WSLineChartView alloc]initWithFrame:CGRectMake(-10, self.chart_simple_container.frame.size.height, self.ChartSuperView.frame.size.width, self.ChartSuperView.frame.size.height - self.chart_simple_container.frame.size.height - 10) xTitleArray:xArray yValueArray:yArray yMax:yMax yMin:0 lineColor:lineColor];
    [self.ChartSuperView addSubview:wsLineView];
}

#pragma mark - 点击切换体重、脂肪、水分、肌肉
-(void)btnClick:(UIButton*)sender
{
    itemIndex = (int)(sender.tag - 1);
    [self getUserDataWithType:dateIndex startDate:_startDate enDate:_endDate];
}


-(void)initChart
{
    int isubview =0;
    for(UIView* view in self.ChartSuperView.subviews)
    {
        if (isubview>1) {
            [view removeFromSuperview];
        }
        isubview++;
    }
    
    NSDateFormatter *formate = [[NSDateFormatter alloc] init];
    [formate setDateFormat:@"yyyy-MM-dd"];
    NSDateFormatter *mdformat = [[NSDateFormatter alloc] init];
    [formate setDateFormat:@"M-d"];
    
    AppDelegate *appdelegate =(AppDelegate*) [[UIApplication sharedApplication] delegate];
    User* user = appdelegate.user;
    
    NSMutableArray* xLables=[NSMutableArray arrayWithCapacity:7];
    NSMutableArray* weightValues=[NSMutableArray arrayWithCapacity:7];
    NSMutableArray* fatValues =[NSMutableArray arrayWithCapacity:7];
    NSMutableArray* waterValues =[NSMutableArray arrayWithCapacity:7];
    NSMutableArray* muscleValues =[NSMutableArray arrayWithCapacity:7];
    
    //脂肪
    NSArray * fats = [User_Item_Info MR_findAllSortedBy:@"testDate" ascending:YES withPredicate:[NSPredicate predicateWithFormat:@"userId==%d AND itemId==%d AND testDate>=%@ And testDate < %@",user.userId.intValue,[TestItemID getFat],_startDate,_endDate] inContext:[NSManagedObjectContext MR_defaultContext]];
    
    //体重
    NSArray * weights = [User_Item_Info MR_findAllSortedBy:@"testDate" ascending:YES withPredicate:[NSPredicate predicateWithFormat:@"userId==%d AND itemId==%d AND testDate>=%@ And testDate < %@",user.userId.intValue,[TestItemID getWeight],_startDate,_endDate] inContext:[NSManagedObjectContext MR_defaultContext]];
    
//    NSArray * weights = [User_Item_Info MR_findAllSortedBy:@"testDate" ascending:YES withPredicate:[NSPredicate predicateWithFormat:@"userId==%d AND itemId==%d",user.userId.intValue,[TestItemID getWeight]] inContext:[NSManagedObjectContext MR_defaultContext]];
//    NSLog(@"weights: %@",weights);
//    User_Item_Info *aaa = weights[0];
//    User_Item_Info *bbb = weights[1];
//    NSLog(@"weights[0]: %@",aaa.testDate);
//    NSLog(@"weights[1]: %@",bbb.testDate);
    
    //水分
    NSArray * waters = [User_Item_Info MR_findAllSortedBy:@"testDate" ascending:YES withPredicate:[NSPredicate predicateWithFormat:@"userId==%d AND itemId==%d AND testDate>=%@ And testDate < %@",user.userId.intValue,[TestItemID getTotalWater],_startDate,_endDate] inContext:[NSManagedObjectContext MR_defaultContext]];
    //肌肉
    NSArray * muscles = [User_Item_Info MR_findAllSortedBy:@"testDate" ascending:YES withPredicate:[NSPredicate predicateWithFormat:@"userId==%d AND itemId==%d AND testDate>=%@ And testDate < %@",user.userId.intValue,[TestItemID getMuscle],_startDate,_endDate] inContext:[NSManagedObjectContext MR_defaultContext]];
    
    NSMutableArray* tmpLables=[self getXLables];
//    NSMutableArray* tmpLables=[self getXLablesWithThirty];
    NSDate *date = _startDate;
    float weightAllCount=0;
    float fatAllCount=0;
    float waterAllCount=0;
    float muscleAllCount=0;

    float weightAllValueSum=0;
    float fatAllValueSum=0;
    float waterAllValueSum=0;
    float muscleAllValueSum=0;
    
    for (int i=0; i<tmpLables.count; i++) {
        NSDate *date1 = [tmpLables objectAtIndex:i];
        if (i==0) {
            date1=[date dateByAddingTimeInterval:(24*60*60)];
        }
        int weightCount=0;
        float weightSum=0;
        for (int j =0; j<weights.count; j++) {
            User_Item_Info* info = [weights objectAtIndex:j];
            float x =[info.testDate timeIntervalSinceDate:date];
            float y =[info.testDate timeIntervalSinceDate:date1];
            if (x>=0&&y<0 && info.testValue>0) {
//                NSLog(@"x=%.2f",x);
//                NSLog(@"y=%.2f",y);
                weightSum += info.testValue.floatValue;
                weightCount++;
                weightAllCount++;
                weightAllValueSum+=info.testValue.floatValue;
            }
        }
        float weightAvg =0;
        if(weightCount>0)weightAvg=weightSum/weightCount;
        [weightValues addObject: [NSNumber numberWithFloat:weightAvg]];
//        NSLog(@"counts--%ld",weightValues.count);
        int fatCount=0;
        float fatSum=0;
        for (int j =0; j<fats.count; j++) {
            User_Item_Info* info = [fats objectAtIndex:j];
            float x =[info.testDate timeIntervalSinceDate:date];
            float y =[info.testDate timeIntervalSinceDate:date1];
            if (x>=0&&y<0 && info.testValue>0)  {
                fatSum += info.testValue.floatValue;
                fatCount++;
                fatAllCount++;
                fatAllValueSum+=info.testValue.floatValue;
            }
        }
        float fatAvg =0;
        if(fatCount>0)fatAvg=fatSum/fatCount;
        [fatValues addObject: [NSNumber numberWithFloat:fatAvg]];
        
        int waterCount=0;
        float waterSum=0;
        for (int j =0; j<waters.count; j++) {
            User_Item_Info* info = [waters objectAtIndex:j];
            float x =[info.testDate timeIntervalSinceDate:date];
            float y =[info.testDate timeIntervalSinceDate:date1];
            if (x>=0&&y<0 && info.testValue>0)  {
                waterSum += info.testValue.floatValue;
                waterCount++;
                waterAllCount++;
                waterAllValueSum+=info.testValue.floatValue;
            }
        }
        float waterAvg =0;
        if(waterCount>0)waterAvg=waterSum/waterCount;
        [waterValues addObject: [NSNumber numberWithFloat:waterAvg]];
        
        int muscleCount=0;
        float muscleSum=0;
        for (int j =0; j<muscles.count; j++) {
            User_Item_Info* info = [muscles objectAtIndex:j];
            float x =[info.testDate timeIntervalSinceDate:date];
            float y =[info.testDate timeIntervalSinceDate:date1];
            if (x>=0&&y<0 && info.testValue>0)  {
                muscleSum += info.testValue.floatValue;
                muscleCount++;
                muscleAllCount++;
                muscleAllValueSum+=info.testValue.floatValue;
            }
        }
        float muscleAvg =0;
        if(muscleCount>0)muscleAvg=muscleSum/muscleCount;
        [muscleValues addObject: [NSNumber numberWithFloat:muscleAvg]];
        
        [xLables addObject:[formate stringFromDate:date1]];
        date=date1;
    }//此处forin循环停止处

    //报告图表
    NSMutableArray * ArrayOfValues = [[NSMutableArray alloc] init];
    NSMutableArray * ArrayOfDates = xLables;
    
    ArrayOfValues = weightValues;
    // The labels to report the values of the graph when the user touches it
    NSMutableDictionary * dic = [[NSMutableDictionary alloc]init];
    float widthLine = 2.0;
    [dic setValue:[NSString stringWithFormat:@"%f",widthLine] forKey:@"widthLine"];
    
    [dic setValue:ArrayOfValues forKey:@"values"];
    [dic setValue:ArrayOfDates forKey:@"dates"];
    [dic setValue:[UIColor clearColor] forKey:@"colorTop"];
    [dic setValue:[UIColor clearColor] forKey:@"colorBottom"];
    [dic setValue:[UIColor yellowColor] forKey:@"colorLine"];
    [dic setValue:[UIColor whiteColor] forKey:@"colorXaxisLabel"];
    [dic setValue:[UIColor whiteColor] forKey:@"colorVerticalLine"];
    [dic setValue:[UIColor greenColor] forKey:@"bigRoundColor"];
    [dic setValue:[UIColor lightTextColor] forKey:@"smallRoundColor"];
    [dic setValue:[UIColor clearColor] forKey:@"barGraphColor"];
    
    LineGraphView * view = [[LineGraphView alloc]initWithDictionary:dic AndFrame:CGRectMake(20, 50, 250, 260)];
    [view addLine: [NSArray arrayWithArray:fatValues]];
    [view addWaterLine: [NSArray arrayWithArray:waterValues]];
    [view addMuscleLine: [NSArray arrayWithArray:muscleValues]];
    
    [self.ChartSuperView addSubview:view];
}

-(void)initCalendarCtrl
{
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    NSDateFormatter *formateymd = [[NSDateFormatter alloc] init];
    if (appDelegate.languageIndex == 1) { //英文
        [formateymd setDateFormat:@"MM/dd/yy"];
    } else {
        [formateymd setDateFormat:@"yy年M月d日"];
    }
    
    NSDateFormatter *formatmd = [[NSDateFormatter alloc] init];
    
    if (appDelegate.languageIndex == 1) {
        [formatmd setDateFormat:@"M/d"];
    } else {
        [formatmd setDateFormat:@"M月d日"];
    }
    
    NSDate *tmp=[_startDate dateByAddingTimeInterval:(1*24*60*60)];
    
    if (_days>90) {
        _date_label.text = [NSString stringWithFormat:@"%@ - %@",[formateymd stringFromDate:tmp],[formateymd stringFromDate:_endDate]];
    }
    else
    {
        _date_label.text = [NSString stringWithFormat:@"%@ - %@",[formatmd stringFromDate:tmp],[formatmd stringFromDate:_endDate]];
    }
}

-(NSMutableArray*) getXLables
{
    NSMutableArray *lables = [NSMutableArray arrayWithCapacity:7];
    
    //[lables addObject:_startDate];
    int step = _days / 7;
    if (_days%7>0) {
        step++;
    }
    for (int i=1; i<=7; i++) {
        NSDate *nextDay=[_startDate dateByAddingTimeInterval:(i*step*24*60*60)];
        [lables addObject:nextDay];
    }
    return lables;
}

-(NSMutableArray*) getXLablesWithSeven
{
    NSMutableArray *lables = [NSMutableArray arrayWithCapacity:7];
    
    //[lables addObject:_startDate];
    int step = _days / 7;
    NSDate *nextDay;
    for (int i=1; i<=7; i++) {
        nextDay=[_startDate dateByAddingTimeInterval:(i*step*24*60*60)];
        [lables addObject:nextDay];
    }
    return lables;
}

-(NSMutableArray*) getXLablesWithThirty
{
    NSMutableArray *lables = [NSMutableArray arrayWithCapacity:7];
    
    int step = _days / 30;
    NSDate *nextDay;
    for (int i=1; i<=29; i++) {
        nextDay=[_startDate dateByAddingTimeInterval:(i*step*24*60*60)];
        [lables addObject:nextDay];
    }
    [lables addObject:_endDate];
    return lables;
}

-(void)initUI
{
    UIColor *borderColor = [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:0.2];
    _date_container.layer.masksToBounds = YES;
    _date_container.layer.cornerRadius = 6.0;
    _date_container.layer.borderWidth = 1.0;
    _date_container.layer.borderColor = [borderColor CGColor];
    _date_container.layer.backgroundColor=[borderColor CGColor];
    
    _chart_simple_container.layer.masksToBounds = YES;
    //_chart_simple_container.layer.cornerRadius = 6.0;
    _chart_simple_container.layer.borderWidth = 1.0;
    _chart_simple_container.layer.borderColor = [borderColor CGColor];
    _chart_simple_container.layer.backgroundColor=[borderColor CGColor];
    
    _chart_container.layer.masksToBounds = YES;
    _chart_container.layer.cornerRadius = 6.0;
    _chart_container.layer.borderWidth = 1.0;
    _chart_container.layer.borderColor = [borderColor CGColor];
    _chart_container.layer.backgroundColor=[borderColor CGColor];
    
    _dot1.layer.masksToBounds = YES;
    _dot1.layer.cornerRadius = 8.0;
    _dot1.layer.borderWidth = 1.0;
    _dot1.layer.borderColor = [UIColor colorWithRed:192.0/255.0 green:255.0/255.0 blue:140.0/255.0 alpha:1].CGColor;
    _dot1.layer.backgroundColor=[UIColor colorWithRed:192.0/255.0 green:255.0/255.0 blue:140.0/255.0 alpha:1].CGColor;
    
    _dot2.layer.masksToBounds = YES;
    _dot2.layer.cornerRadius = 8.0;
    _dot2.layer.borderWidth = 1.0;
    _dot2.layer.borderColor = [UIColor colorWithRed:255.0/255.0 green:247.0/255.0 blue:140.0/255.0 alpha:1].CGColor;
    _dot2.layer.backgroundColor=[UIColor colorWithRed:255.0/255.0 green:247.0/255.0 blue:140.0/255.0 alpha:1].CGColor;
    
    _dot3.layer.masksToBounds = YES;
    _dot3.layer.cornerRadius = 8.0;
    _dot3.layer.borderWidth = 1.0;
    _dot3.layer.borderColor = [UIColor colorWithRed:255.0/255.0 green:208.0/255.0 blue:140.0/255.0 alpha:1].CGColor;
    _dot3.layer.backgroundColor=[UIColor colorWithRed:255.0/255.0 green:208.0/255.0 blue:140.0/255.0 alpha:1].CGColor;
    
    _dot4.layer.masksToBounds = YES;
    _dot4.layer.cornerRadius = 8.0;
    _dot4.layer.borderWidth = 1.0;
    _dot4.layer.borderColor = [UIColor colorWithRed:140.0/255.0 green:234.0/255.0 blue:255.0/255.0 alpha:1].CGColor;
    _dot4.layer.backgroundColor=[UIColor colorWithRed:140.0/255.0 green:234.0/255.0 blue:255.0/255.0 alpha:1].CGColor;
    
}
#pragma mark - PPi delegate 切换周/月/季/年
-(void)PPiFlatSegmentedSelectedSegAtIndex:(int)index
{
    switch (index) {
        case 1:
            dateIndex = 1;
            _days=30;
            _endDate = [NSDate date];
            _startDate = [_endDate dateByAddingTimeInterval:(-30*24*60*60)];
            break;
        case 2:
            dateIndex = 2;
            _days=90;
            _endDate = [NSDate date];
            _startDate = [_endDate dateByAddingTimeInterval:(-90*24*60*60)];
            break;
        case 3:
            dateIndex = 3;
            _days=365;
            _endDate = [NSDate date];
            _startDate = [_endDate dateByAddingTimeInterval:(-365*24*60*60)];
            break;
        default://周
            dateIndex = 0;
            _days=7;
            _endDate = [NSDate date];
            _startDate = [_endDate dateByAddingTimeInterval:(-7*24*60*60)];
            break;
    }
    [self initCalendarCtrl];
    [self getUserDataWithType:dateIndex startDate:_startDate enDate:_endDate];
//    [self initChart];
}

#pragma mark - SimpleLineGraph Data Source

- (int)numberOfPointsInGraph {
    return (int)[self.ArrayOfValues count];
}

- (float)valueForIndex:(NSInteger)index {
    return [[self.ArrayOfValues objectAtIndex:index] floatValue];
}

#pragma mark - SimpleLineGraph Delegate

- (int)numberOfGapsBetweenLabels
{
    return 0;
}

- (NSString *)labelOnXAxisForIndex:(NSInteger)index
{
    return [self.ArrayOfDates objectAtIndex:index];
}

- (void)didTouchGraphWithClosestIndex:(int)index
{
    //    self.labelValues.text = [NSString stringWithFormat:@"%@", [self.ArrayOfValues objectAtIndex:index]];
    //
    //    self.labelDates.text = [NSString stringWithFormat:@"in %@", [self.ArrayOfDates objectAtIndex:index]];
}

- (void)didReleaseGraphWithClosestIndex:(float)index
{
    //    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
    //        self.labelValues.alpha = 0.0;
    //        self.labelDates.alpha = 0.0;
    //    } completion:^(BOOL finished){
    //
    //        self.labelValues.text = [NSString stringWithFormat:@"%i", totalNumber];
    //        self.labelDates.text = @"between 2000 and 2010";
    //
    //        [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
    //            self.labelValues.alpha = 1.0;
    //            self.labelDates.alpha = 1.0;
    //        } completion:nil];
    //    }];
    
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

- (IBAction)beforeDateClicked:(id)sender {
    _endDate = [_endDate dateByAddingTimeInterval:(-1*24*60*60)];
    _startDate = [_startDate dateByAddingTimeInterval:(-1*24*60*60)];
    [self initCalendarCtrl];
    [self getUserDataWithType:dateIndex startDate:_startDate enDate:_endDate];
//    [self initChart];
}

- (IBAction)nextDateClicked:(id)sender {
    //若查询日期超过今天则给出提示
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSDate *nowDate = [NSDate date];
    NSString *nowStr = [dateFormatter stringFromDate:nowDate];
    
    NSDate *tmpNextDate = [_endDate dateByAddingTimeInterval:(1*24*60*60)];
    NSString *tmpNextStr = [dateFormatter stringFromDate:tmpNextDate];
    
    if ([nowStr compare:tmpNextStr] == -1) {
        [self showAlertWithTitle:CustomLocalizedString(@"tip", nil) Message:CustomLocalizedString(@"QueryMoreData", nil)];
        return;
    }
    
    _endDate = [_endDate dateByAddingTimeInterval:(1*24*60*60)];
    _startDate = [_startDate dateByAddingTimeInterval:(1*24*60*60)];
    [self initCalendarCtrl];
    [self getUserDataWithType:dateIndex startDate:_startDate enDate:_endDate];
//    [self initChart];
}

-(void)serviceSuccessed:(NSDictionary*)keyValues pMethod:(NSString*)method
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [loading hide:YES];
        
    });
    NSLog(@"Successedmethod -- %@",method);
    if ([method isEqualToString:@"GetUserItemsByDateJson"]) {
        if (keyValues == nil) {
            //无返回内容，表示有错误
            [self showAlertWithTitle:CustomLocalizedString(@"tip", nil) Message:CustomLocalizedString(@"ReQuery", nil)];
        } else {
            //有返回内容
            /*
            [allDataMarr removeAllObjects];
            for (NSDictionary *dict in keyValues) {
                NSString *str = dict[@"TestDate"];
                NSString *strDate = [str substringToIndex:10];
                NSMutableDictionary *Mdict = [NSMutableDictionary dictionaryWithObjectsAndKeys:strDate,@"TestDate",[NSString stringWithFormat:@"%@",dict[@"JiRou"]],@"JiRou",[NSString stringWithFormat:@"%@",dict[@"Weight"]],@"Weight",[NSString stringWithFormat:@"%@",dict[@"ZhiFang"]],@"ZhiFang",[NSString stringWithFormat:@"%@",dict[@"ZongShui"]],@"ZongShui", nil];
                [allDataMarr addObject:Mdict];
            }
            //将获取到的服务器数据和显示日期进行比较
            
            //获取日期数组
            NSMutableArray *datesArr = [NSMutableArray array];
            if (dateIndex ==0) {//周
                datesArr = [self getXLablesWithSeven];
            } else {
                datesArr = [self getXLablesWithThirty];
            }
            
            //将本地时间中的日期转换为字符串
            NSMutableArray *dateStrLocalArr = [NSMutableArray array];
            for (NSDate *date in datesArr) {
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                [dateFormatter setDateFormat:@"yyyy-MM-dd"];
                NSString *strDate = [dateFormatter stringFromDate:date];
                [dateStrLocalArr addObject:strDate];
            }
            //将服务器获取的数据时间中的日期转换为字符串
            NSMutableArray *dateStrNetlArr = [NSMutableArray array];
            for (NSDictionary *dict in allDataMarr) {
                NSString *str = dict[@"TestDate"];
                NSString *strDate = [str substringToIndex:10];
                [dateStrNetlArr addObject:strDate];
            }
            
            for (NSString *strDate in dateStrLocalArr) {
                if (![dateStrNetlArr containsObject:strDate]) {
                    NSDictionary *addDict = [NSDictionary dictionaryWithObjectsAndKeys:@"0",@"JiRou",strDate,@"TestDate",@"0",@"Weight",@"0",@"ZhiFang",@"0",@"ZongShui", nil];
                    [allDataMarr addObject:addDict];
                }
            }
            
            //allDataMarr按时间进行升序排序
            [allDataMarr sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
                NSDictionary *dict1 = (NSDictionary*)obj1;
                NSDictionary *dict2 = (NSDictionary*)obj2;
                return [dict1[@"TestDate"] compare:dict2[@"TestDate"]];
            }];
            
            //体重、脂肪、水分、肌肉的具体数组
            NSMutableArray *itemArray = [NSMutableArray array];
            //画线颜色
            UIColor *lineColor;
            switch (itemIndex) {
                case 0:
                    for (NSDictionary *dict in allDataMarr) {
                        [itemArray addObject:dict[@"Weight"]];
                    }
                    lineColor = [UIColor colorWithRed:192.0/255.0 green:255.0/255.0 blue:140.0/255.0 alpha:1];
                    break;
                case 1:
                    for (NSDictionary *dict in allDataMarr) {
                        [itemArray addObject:dict[@"ZhiFang"]];
                    }
                    lineColor = [UIColor colorWithRed:255.0/255.0 green:247.0/255.0 blue:140.0/255.0 alpha:1];
                    
                    break;
                case 2:
                    for (NSDictionary *dict in allDataMarr) {
                        [itemArray addObject:dict[@"ZongShui"]];
                    }
                    lineColor = [UIColor colorWithRed:255.0/255.0 green:208.0/255.0 blue:140.0/255.0 alpha:1];
                    break;
                case 3:
                    for (NSDictionary *dict in allDataMarr) {
                        [itemArray addObject:dict[@"JiRou"]];
                    }
                    lineColor = [UIColor colorWithRed:140.0/255.0 green:234.0/255.0 blue:255.0/255.0 alpha:1];
                    break;
                    
                default:
                    break;
            }
            
            NSMutableArray *showDateArr = [NSMutableArray array];
            for (NSString *strDate in dateStrLocalArr) {
                NSString *subStr = [strDate substringWithRange:NSMakeRange(5, 5)];
                [showDateArr addObject:subStr];
            }
            //获取最大值显示为y轴
            NSInteger max = [[itemArray valueForKeyPath:@"@max.floatValue"] integerValue];
            
            [self initSingleChartWithXArray:showDateArr YArray:itemArray YMax:max + 10 YMin:0 lineColor:lineColor];
            */
            
            
            [allDataMarr removeAllObjects];
            for (NSDictionary *dict in keyValues) {
                NSString *str = dict[@"TestDate"];
                NSString *strDate = [str substringToIndex:10];
                NSMutableDictionary *Mdict = [NSMutableDictionary dictionaryWithObjectsAndKeys:strDate,@"TestDate",[NSString stringWithFormat:@"%@",dict[@"JiRou"]],@"JiRou",[NSString stringWithFormat:@"%@",dict[@"Weight"]],@"Weight",[NSString stringWithFormat:@"%@",dict[@"ZhiFang"]],@"ZhiFang",[NSString stringWithFormat:@"%@",dict[@"ZongShui"]],@"ZongShui", nil];
                [allDataMarr addObject:Mdict];
            }
            
            //allDataMarr按时间进行升序排序
            [allDataMarr sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
                NSDictionary *dict1 = (NSDictionary*)obj1;
                NSDictionary *dict2 = (NSDictionary*)obj2;
                return [dict1[@"TestDate"] compare:dict2[@"TestDate"]];
            }];
            
            //将服务器获取的数据时间中的日期转换为字符串
            NSMutableArray *dateStrNetlArr = [NSMutableArray array];
            for (NSDictionary *dict in allDataMarr) {
                NSString *str = dict[@"TestDate"];
                NSString *strDate = [str substringToIndex:10];
                [dateStrNetlArr addObject:strDate];
            }
            
            //体重、脂肪、水分、肌肉的具体数组
            NSMutableArray *itemArray = [NSMutableArray array];
            //画线颜色
            UIColor *lineColor;
            switch (itemIndex) {
                case 0:
                    for (NSDictionary *dict in allDataMarr) {
                        [itemArray addObject:dict[@"Weight"]];
                    }
                    lineColor = [UIColor colorWithRed:192.0/255.0 green:255.0/255.0 blue:140.0/255.0 alpha:1];
                    break;
                case 1:
                    for (NSDictionary *dict in allDataMarr) {
                        [itemArray addObject:dict[@"ZhiFang"]];
                    }
                    lineColor = [UIColor colorWithRed:255.0/255.0 green:247.0/255.0 blue:140.0/255.0 alpha:1];
                    
                    break;
                case 2:
                    for (NSDictionary *dict in allDataMarr) {
                        [itemArray addObject:dict[@"ZongShui"]];
                    }
                    lineColor = [UIColor colorWithRed:255.0/255.0 green:208.0/255.0 blue:140.0/255.0 alpha:1];
                    break;
                case 3:
                    for (NSDictionary *dict in allDataMarr) {
                        [itemArray addObject:dict[@"JiRou"]];
                    }
                    lineColor = [UIColor colorWithRed:140.0/255.0 green:234.0/255.0 blue:255.0/255.0 alpha:1];
                    break;
                    
                default:
                    break;
            }
            
            NSMutableArray *showDateArr = [NSMutableArray array];
            for (NSString *strDate in dateStrNetlArr) {
                NSString *subStr = [strDate substringWithRange:NSMakeRange(5, 5)];
                [showDateArr addObject:subStr];
            }
            //获取最大值显示为y轴
            NSInteger max = [[itemArray valueForKeyPath:@"@max.floatValue"] integerValue];
            
            [self initSingleChartWithXArray:showDateArr YArray:itemArray YMax:max + 10 YMin:0 lineColor:lineColor];
             
        }
        
    }
    
}

-(void)serviceFailed:(NSString*) message pMethod:(NSString*)method
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [loading hide:YES];
        
    });
    NSLog(@"Failedmethod -- %@",method);
}

-(void)showAlertWithTitle:(NSString*)title Message:(NSString*)message
{
    UIAlertController *controller = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *actionOK = [UIAlertAction actionWithTitle:CustomLocalizedString(@"OK", nil) style:UIAlertActionStyleCancel handler:nil];
    [controller addAction:actionOK];
    [self presentViewController:controller animated:YES completion:nil];
}

@end
