//
//  PhaseReportViewController.m
//  TFHealth
//
//  Created by hzth hzth－mac2 on 6/7/14.
//  Copyright (c) 2014 studio37. All rights reserved.
//

#import "PhaseReportViewController.h"
#import "PhaseTimeTableViewCell.h"
#import "PhaseChartTableViewCell.h"
#import "LineGraphView.h"
#import "HealthStatusViewController.h"
#import "UIViewController+MMDrawerController.h"

@interface PhaseReportViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *phaseReportTableView;

@end

@implementation PhaseReportViewController

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
    self.phaseReportTableView.delegate = self;
    self.phaseReportTableView.dataSource = self;
    
    
    // Do any additional setup after loading the view.
}

- (IBAction)backButtonClikc:(id)sender {
    UIViewController * hsvc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"HealthStatusNavViewController"];
    //[self.mm_drawerController setCenterViewController:hsvc withCloseAnimation:YES completion:nil];
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
    
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PhaseTimeTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"PhaseTimeTableViewCell"];
    if (indexPath.row == 1) {
        PhaseChartTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"PhaseChartTableViewCell"];
        NSMutableArray * ArrayOfValues = [[NSMutableArray alloc] init];
        NSMutableArray * ArrayOfDates = [NSMutableArray arrayWithObjects:@"周一",@"周二",@"周三",@"周四",@"周五", nil];
        
        int totalNumber = 0;
        
        for (int i=0; i < 5; i++) {
            [ArrayOfValues addObject:[NSNumber numberWithInteger:(arc4random() % 70000)]]; // Random values for the graph
            // Dates for the X-Axis of the graph
            
            totalNumber = totalNumber + [[ArrayOfValues objectAtIndex:i] intValue]; // All of the values added together
        }
        
        // The labels to report the values of the graph when the user touches it
        NSMutableDictionary * dic = [[NSMutableDictionary alloc]init];
        float widthLine = 3.0;
        [dic setValue:[NSString stringWithFormat:@"%f",widthLine] forKey:@"widthLine"];
        
        [dic setValue:ArrayOfValues forKey:@"values"];
        [dic setValue:ArrayOfDates forKey:@"dates"];
        [dic setValue:[UIColor clearColor] forKey:@"colorTop"];
        [dic setValue:[UIColor clearColor] forKey:@"colorBottom"];
        [dic setValue:[UIColor yellowColor] forKey:@"colorLine"];
        [dic setValue:[UIColor whiteColor] forKey:@"colorXaxisLabel"];
        [dic setValue:[UIColor purpleColor] forKey:@"colorVerticalLine"];
        [dic setValue:[UIColor greenColor] forKey:@"bigRoundColor"];
        [dic setValue:[UIColor yellowColor] forKey:@"smallRoundColor"];
        [dic setValue:[UIColor clearColor] forKey:@"barGraphColor"];
        CGRect frame = cell.chartView.frame;
        frame.origin.x = 0;
        frame.origin.y = 0;
        
        LineGraphView * view = [[LineGraphView alloc]initWithDictionary:dic AndFrame:frame];
        NSArray * valuesArray = [NSArray arrayWithObjects:@"200",@"1000",@"40000",@"10",@"11111",@"11123",@"43532",nil];
        [view addLine:valuesArray];
        [cell.chartView addSubview:view];
        return cell;
    }
    else
    {
        if (indexPath.row==0) {
            UILabel *lable = [[UILabel alloc] init];
            CGRect size = CGRectMake(5, 5,245,47);
            lable.frame=size;
            lable.numberOfLines = 0;// 不可少Label属性之一
            lable.lineBreakMode = UILineBreakModeCharacterWrap;// 不可少Label属性之二
            lable.textColor= [UIColor colorWithWhite:255 alpha:1];
            lable.font=[UIFont systemFontOfSize:13.0];
            lable.text=@"在2月17日到3月10日期间，您共记录了20次热量补充记录，上图为热量补充曲线图，通过您的热量消耗来分析，在3月2日，您补充了";
            [cell.contentLable addSubview:lable];
        }
        else if (indexPath.row==2) {
            UILabel *lable = [[UILabel alloc] init];
            CGRect size = CGRectMake(5, 5,245,47);
            lable.frame=size;
            lable.numberOfLines = 0;// 不可少Label属性之一
            lable.lineBreakMode = UILineBreakModeCharacterWrap;// 不可少Label属性之二
            lable.textColor= [UIColor colorWithWhite:255 alpha:1];
            lable.font=[UIFont systemFontOfSize:13.0];
            lable.text=@"阶段目标70kg,历时20天，于3月10日已在成目标，减重方式经为健康。";
            [cell.contentLable addSubview:lable];
        }
        else if (indexPath.row==3) {
            UILabel *lable = [[UILabel alloc] init];
            CGRect size = CGRectMake(5, 5,245,47);
            lable.frame=size;
            lable.numberOfLines = 0;// 不可少Label属性之一
            lable.lineBreakMode = UILineBreakModeCharacterWrap;// 不可少Label属性之二
            lable.textColor= [UIColor colorWithWhite:255 alpha:1];
            lable.font=[UIFont systemFontOfSize:13.0];
            lable.text=@"在2月17日到3月10日期间，您共记录了20次热量补充记录，上图为热量补充曲线图，通过您的热量消耗来分析，在3月2日，您补充了";
            [cell.contentLable addSubview:lable];
        }
        else if (indexPath.row==4) {
            UILabel *lable = [[UILabel alloc] init];
            CGRect size = CGRectMake(5, 5,245,47);
            lable.frame=size;
            lable.numberOfLines = 0;// 不可少Label属性之一
            lable.lineBreakMode = UILineBreakModeCharacterWrap;// 不可少Label属性之二
            lable.textColor= [UIColor colorWithWhite:255 alpha:1];
            lable.font=[UIFont systemFontOfSize:13.0];
            lable.text=@"阶段目标70kg,历时20天，于3月10日已在成目标，减重方式经为健康。";
            [cell.contentLable addSubview:lable];
        }
        return cell;
    }
}
-(double)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==1) {
        PhaseChartTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"PhaseChartTableViewCell"];
        return cell.frame.size.height-10;
    }
    
    PhaseTimeTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"PhaseTimeTableViewCell"];
    if(indexPath.row==0)
    {
        return cell.frame.size.height+10;
    }
    return  cell.frame.size.height;
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
