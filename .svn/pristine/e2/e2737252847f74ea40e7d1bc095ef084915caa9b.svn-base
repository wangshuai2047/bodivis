//
//  SportPaternersViewController.m
//  TFHealth
//
//  Created by hzth hzth－mac2 on 5/27/14.
//  Copyright (c) 2014 studio37. All rights reserved.
//

#import "SportPaternersViewController.h"
#import "SportItem.h"
#import "SportsRecordsViewController.h"
#import "SportsEventsViewController.h"
#import "UIViewController+MMDrawerController.h"
#import "Sport_Items.h"
#import "Sport_Item_Value.h"
@interface SportPaternersViewController ()
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;//显示日期的label
@property (weak, nonatomic) IBOutlet UILabel *calorieLabel;//显示多少卡路里的label，数字
@property (weak, nonatomic) IBOutlet UIButton *addButton;//添加按钮
@property (weak, nonatomic) IBOutlet UIScrollView *sportsScrollView;
@property (weak, nonatomic) IBOutlet UIView *date_container;
@property (weak, nonatomic) IBOutlet UIView *items_container;
@property (weak, nonatomic) IBOutlet UIView *cal_container;



@property (nonatomic,retain) NSMutableArray *didSportItemsArr;
#define Font 12

@end

@implementation SportPaternersViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
#pragma mark - 选择日期两个按钮响应
- (IBAction)forwardDateButtonClick:(id)sender {
    
}
- (IBAction)nextDateButtonClick:(id)sender {
    
}

- (IBAction)backButtonClikc:(id)sender {
    UIViewController * hsvc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"HealthStatusNavViewController"];
    //[self.mm_drawerController setCenterViewController:hsvc withCloseAnimation:YES completion:nil];
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}

-(void)viewWillAppear:(BOOL)animated {
    
    NSArray *array = [Sport_Item_Value MR_findAllInContext:[NSManagedObjectContext MR_defaultContext]];
    NSDate *date = [NSDate date];
    NSDateFormatter *formate = [[NSDateFormatter alloc] init];
    [formate setDateFormat:@"yyyy-MM-dd"];
    NSString *string = [formate stringFromDate:date];
    date = [formate dateFromString:string];
    _didSportItemsArr = [NSMutableArray arrayWithArray:[Sport_Item_Value MR_findByAttribute:@"testDate" withValue:date inContext:[NSManagedObjectContext MR_defaultContext]]];
    [self updateScrollViewData:_didSportItemsArr];
    float carli = 0;
    for (Sport_Item_Value *item in _didSportItemsArr) {
        carli += [item.consumptionCalories floatValue];
    }
    _calorieLabel.text = [NSString stringWithFormat:@"%.1f",carli];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSArray *sports = [Sport_Item_Value MR_findAllInContext:[NSManagedObjectContext MR_defaultContext]];
    NSLog(@"spots :%@",sports);
    if (sports.count > 0) {
        NSMutableArray *sportsArr = [NSMutableArray arrayWithArray:sports];
        [self updateScrollViewData:sportsArr];
    }
    // Do any additional setup after loading the view.
    [self initUI];
}

-(void)initUI
{
    UIColor *borderColor = [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:0.2];
    _date_container.layer.masksToBounds = YES;
    _date_container.layer.cornerRadius = 6.0;
    _date_container.layer.borderWidth = 1.0;
    _date_container.layer.borderColor = [borderColor CGColor];
    _date_container.layer.backgroundColor=[borderColor CGColor];
    
    _items_container.layer.masksToBounds = YES;
    _items_container.layer.cornerRadius = 6.0;
    _items_container.layer.borderWidth = 1.0;
    _items_container.layer.borderColor = [borderColor CGColor];
    _items_container.layer.backgroundColor=[borderColor CGColor];
    
    _cal_container.layer.masksToBounds = YES;
    _cal_container.layer.cornerRadius = 6.0;
    _cal_container.layer.borderWidth = 1.0;
    _cal_container.layer.borderColor = [borderColor CGColor];
    _cal_container.layer.backgroundColor=[borderColor CGColor];
}

-(void)getSportsItemsWithDate:(NSDate *)date {
    
}

- (IBAction)sportRecordButtonClick:(id)sender {
    SportsRecordsViewController * ssvc = [self.storyboard instantiateViewControllerWithIdentifier:@"SportsRecordsViewController"];
    [self.navigationController pushViewController:ssvc animated:YES];
}

-(void)updateScrollViewData:(NSMutableArray*)dataArray
{
    for (UIView * subview in self.sportsScrollView.subviews) {
        [subview removeFromSuperview];
    }
    
    float width = self.sportsScrollView.frame.size.width/2;
    float height = 50;
    self.sportsScrollView.contentSize = CGSizeMake(width*2,height*((dataArray.count+1)/2));
    for (int i = 0; i<(dataArray.count+1)/2; i++) {
        for (int j = 0 ; j<2;j++ )
        {
            if ((j+1)+i*2>dataArray.count) {
                break;
            }
            UIView * sportView = [[UIView alloc]initWithFrame:CGRectMake(width*j, i*height, width, height)];
            sportView.backgroundColor = [UIColor clearColor];
            UIImageView * iconImageView = [[UIImageView alloc]initWithFrame:CGRectMake(24, 24, 15, 15)];
            Sport_Item_Value * item_value = [dataArray objectAtIndex:i*2+j];
            Sport_Items *item = [[Sport_Items MR_findByAttribute:@"sportId" withValue:item_value.sportId inContext:[NSManagedObjectContext MR_defaultContext]] firstObject];
            iconImageView.image = [UIImage imageNamed:@"16_icon_youyong"];
            [sportView addSubview:iconImageView];
            
            UILabel * sportNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(47, 3, 50, 55)];
            sportNameLabel.textColor = UIColorFromRGB(0x9be2ff);
            sportNameLabel.text = item.sportName;
            sportNameLabel.font = [UIFont systemFontOfSize:Font];
            [sportView addSubview:sportNameLabel];
            
            UILabel * detailLabel = [[UILabel alloc]initWithFrame:CGRectMake(98, 3, 42, 55)];
            detailLabel.textColor = [UIColor whiteColor];
            detailLabel.text = [NSString stringWithFormat:@"%@ %@",item_value.movementTime,item.unit];
            detailLabel.textAlignment = NSTextAlignmentCenter;
            detailLabel.numberOfLines = 2;
            detailLabel.font = [UIFont systemFontOfSize:Font];
            [sportView addSubview:detailLabel];
            [self.sportsScrollView addSubview:sportView];
        }
    }
    
    
}
- (IBAction)addButtonClick:(id)sender {
    SportsEventsViewController * ssvc = [self.storyboard instantiateViewControllerWithIdentifier:@"SportsEventsViewController"];
    [self.navigationController pushViewController:ssvc animated:YES];
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
