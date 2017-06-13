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

@interface HistoryDataViewController ()<BEMSimpleLineGraphDelegate,PPiFlatSegmentedDelegate>
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
- (void)viewDidLoad
{
    [super viewDidLoad];
    _endDate = [NSDate date];
    _startDate = [_endDate dateByAddingTimeInterval:(-7*24*60*60)];
    _days=7;
    
    [self initSegmentCtrl];
    
    [self initCalendarCtrl];
    
    [self initChart];
    
    [self initUI];
}

-(void)initSegmentCtrl
{
    PPiFlatSegmentedControl *segmented=[[PPiFlatSegmentedControl alloc] initWithFrame:CGRectMake(10,80, 300, 30) items:@[@{@"text":@"周",@"icon":@"icon-time"},@{@"text":@"月",@"icon":@"icon-calendar"},@{@"text":@"季",@"icon":@"icon-smile"},@{@"text":@"年",@"icon":@"icon-cloud-download"}]iconPosition:IconPositionRight andSelectionBlock:^(NSUInteger segmentIndex) {}];
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
    //水分
    NSArray * waters = [User_Item_Info MR_findAllSortedBy:@"testDate" ascending:YES withPredicate:[NSPredicate predicateWithFormat:@"userId==%d AND itemId==%d AND testDate>=%@ And testDate < %@",user.userId.intValue,[TestItemID getTotalWater],_startDate,_endDate] inContext:[NSManagedObjectContext MR_defaultContext]];
    //肌肉
    NSArray * muscles = [User_Item_Info MR_findAllSortedBy:@"testDate" ascending:YES withPredicate:[NSPredicate predicateWithFormat:@"userId==%d AND itemId==%d AND testDate>=%@ And testDate < %@",user.userId.intValue,[TestItemID getMuscle],_startDate,_endDate] inContext:[NSManagedObjectContext MR_defaultContext]];
    
    NSMutableArray* tmpLables=[self getXLables];
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
                NSLog(@"x=%.2f",x);
                NSLog(@"y=%.2f",y);
                weightSum += info.testValue.floatValue;
                weightCount++;
                weightAllCount++;
                weightAllValueSum+=info.testValue.floatValue;
            }
        }
        float weightAvg =0;
        if(weightCount>0)weightAvg=weightSum/weightCount;
        [weightValues addObject: [NSNumber numberWithFloat:weightAvg]];
        
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
    }

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
    NSDateFormatter *formateymd = [[NSDateFormatter alloc] init];
    [formateymd setDateFormat:@"yy年M月d日"];
    NSDateFormatter *formatmd = [[NSDateFormatter alloc] init];
    [formatmd setDateFormat:@"M月d日"];
    
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

-(void)initUI
{
    UIColor *borderColor = [UIColor colorWithRed:255.0 green:255.0 blue:255.0 alpha:0.2];
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

#pragma PPi delegate
-(void)PPiFlatSegmentedSelectedSegAtIndex:(int)index
{
    switch (index) {
        case 1:
            _days=30;
            _endDate = [NSDate date];
            _startDate = [_endDate dateByAddingTimeInterval:(-30*24*60*60)];
            break;
        case 2:
            _days=90;
            _endDate = [NSDate date];
            _startDate = [_endDate dateByAddingTimeInterval:(-90*24*60*60)];
            break;
        case 3:
            _days=365;
            _endDate = [NSDate date];
            _startDate = [_endDate dateByAddingTimeInterval:(-365*24*60*60)];
            break;
        default:
            _days=7;
            _endDate = [NSDate date];
            _startDate = [_endDate dateByAddingTimeInterval:(-7*24*60*60)];
            break;
    }
    [self initCalendarCtrl];
    [self initChart];
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
    [self initChart];
}

- (IBAction)nextDateClicked:(id)sender {
    _endDate = [_endDate dateByAddingTimeInterval:(1*24*60*60)];
    _startDate = [_startDate dateByAddingTimeInterval:(1*24*60*60)];
    [self initCalendarCtrl];
    [self initChart];
}
@end
