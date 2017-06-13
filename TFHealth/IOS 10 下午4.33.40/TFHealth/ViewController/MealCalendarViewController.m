//
//  MealCalendarViewController.m
//  TFHealth
//
//  Created by hzth hzth－mac2 on 6/12/14.
//  Copyright (c) 2014 studio37. All rights reserved.
//

#import "MealCalendarViewController.h"
#import "PPiFlatSegmentedControl.h"
#import "LineGraphView.h"
#import "AppDelegate.h"
#import "DalidFood.h"

@interface MealCalendarViewController ()
@property (weak, nonatomic) IBOutlet UIView *chartSuperView;
@property (strong, nonatomic) NSMutableArray *ArrayOfValues;
@property (strong, nonatomic) NSMutableArray *ArrayOfDates;
@property (weak, nonatomic) IBOutlet UIView *date_container;
@property (weak, nonatomic) IBOutlet UIView *chart_container;
@property (nonatomic,copy)  NSDate* startDate;
@property (nonatomic,copy)  NSDate* endDate;
@property (assign, nonatomic) int days;
@property (weak, nonatomic) IBOutlet UILabel *date_label;
- (IBAction)beforeDateClicked:(id)sender;
- (IBAction)nextDateClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *dot1;
@end

@implementation MealCalendarViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (IBAction)backButtonClick:(id)sender {
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

-(void)initChart
{
    for(UIView* view in self.chartSuperView.subviews)
    {
        [view removeFromSuperview];
    }
    
    NSDateFormatter *formate = [[NSDateFormatter alloc] init];
    [formate setDateFormat:@"yyyy-MM-dd"];
    NSDateFormatter *mdformat = [[NSDateFormatter alloc] init];
    [formate setDateFormat:@"M-d"];
    
    AppDelegate *appdelegate =(AppDelegate*) [[UIApplication sharedApplication] delegate];
    User* user = appdelegate.user;
    
    NSMutableArray* xLables=[NSMutableArray arrayWithCapacity:7];
    NSMutableArray* foodValues=[NSMutableArray arrayWithCapacity:7];

    NSArray * foods = [DalidFood MR_findAllSortedBy:@"intakeDate" ascending:YES withPredicate:[NSPredicate predicateWithFormat:@"userId==%d AND (intakeDate >= %@) AND (intakeDate < %@)",user.userId.intValue,_startDate,_endDate] inContext:[NSManagedObjectContext MR_defaultContext]];
    
    NSMutableArray* tmpLables=[self getXLables];
    NSDate *date = _startDate;

    for (int i=0; i<tmpLables.count; i++) {
        NSDate *date1 = [tmpLables objectAtIndex:i];
        if (i==0) {
            date1=[date dateByAddingTimeInterval:(24*60*60)];
        }
        int foodCount=0;
        float foodSum=0;
        for (int j =0; j<foods.count; j++) {
            DalidFood* info = [foods objectAtIndex:j];
            float x =[info.intakeDate timeIntervalSinceDate:date];
            float y =[info.intakeDate timeIntervalSinceDate:date1];
            if (x>=0&&y<0 && info.calorieValue>0){
                foodSum += info.calorieValue.floatValue;
                foodCount++;
            }
        }
        float foodAvg =0;
        if(foodCount>0)foodAvg=foodSum/foodCount;
        [foodValues addObject: [NSNumber numberWithFloat:foodAvg]];
        [xLables addObject:[formate stringFromDate:date1]];
        date=date1;
    }
    
    //报告图表
    NSMutableArray * ArrayOfValues = [[NSMutableArray alloc] init];
    NSMutableArray * ArrayOfDates = xLables;
    
    ArrayOfValues = foodValues;
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
    [dic setValue:[UIColor yellowColor] forKey:@"smallRoundColor"];
    [dic setValue:[UIColor clearColor] forKey:@"barGraphColor"];
    
    LineGraphView * view = [[LineGraphView alloc]initWithDictionary:dic AndFrame:CGRectMake(20, 5, 250, 230)];
    [self.chartSuperView addSubview:view];
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

-(void)initSegmentCtrl
{
    PPiFlatSegmentedControl *segmented=[[PPiFlatSegmentedControl alloc] initWithFrame:CGRectMake(10,80, 300, 30) items:@[@{@"text":@"周",@"icon":@"icon-time"},@{@"text":@"月",@"icon":@"icon-calendar"},@{@"text":@"季",@"icon":@"icon-coffee"},@{@"text":@"年",@"icon":@"icon-cloud-download"}]iconPosition:IconPositionRight andSelectionBlock:^(NSUInteger segmentIndex) {}];
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

-(void)initUI
{
    UIColor *borderColor = [UIColor colorWithRed:255.0 green:255.0 blue:255.0 alpha:0.2];
    _date_container.layer.masksToBounds = YES;
    _date_container.layer.cornerRadius = 6.0;
    _date_container.layer.borderWidth = 1.0;
    _date_container.layer.borderColor = [borderColor CGColor];
    _date_container.layer.backgroundColor=[borderColor CGColor];
    
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
