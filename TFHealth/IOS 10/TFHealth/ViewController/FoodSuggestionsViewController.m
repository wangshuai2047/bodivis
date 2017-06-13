//
//  FoodSuggestionsViewController.m
//  TFHealth
//
//  Created by chenzq on 14-7-29.
//  Copyright (c) 2014年 studio37. All rights reserved.
//

#import "FoodSuggestionsViewController.h"
#import "SportSuggestionsViewController.h"
#import "AddSportViewController.h"
#import "AppCloundService.h"
#import "PersonalSet.h"
#import "User_Item_Info.h"
#import "TestItemID.h"
#import "TestItemCalc.h"
#import "AppDelegate.h"
#import "ServiceCallbackDelegate.h"

@interface FoodSuggestionsViewController ()<ServiceObjectDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *text_view_container;

@end

@implementation FoodSuggestionsViewController

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
    //[self setSuggestionText:self.suggestion];
    // Do any additional setup after loading the view.
    [self initUI];
    [self loadSportPrescription];
}

-(void)loadSportPrescription
{
    AppDelegate *appdelegate =(AppDelegate*) [[UIApplication sharedApplication] delegate];
    User* user = appdelegate.user;
    
    PersonalSet *pinfo = [PersonalSet MR_findFirstWithPredicate:[NSPredicate predicateWithFormat:@"userId==%d",user.userId.intValue] sortedBy:@"startDate" ascending:false inContext:[NSManagedObjectContext MR_defaultContext]];
    
    User_Item_Info *muscleInfo = [User_Item_Info MR_findFirstWithPredicate:[NSPredicate predicateWithFormat:@"userId==%d AND itemId==%d",user.userId.intValue,[TestItemID getMuscle]] sortedBy:@"testDate" ascending:false inContext:[NSManagedObjectContext MR_defaultContext]];
    
    User_Item_Info *weightInfo = [User_Item_Info MR_findFirstWithPredicate:[NSPredicate predicateWithFormat:@"userId==%d AND itemId==%d",user.userId.intValue,[TestItemID getWeight]] sortedBy:@"testDate" ascending:false inContext:[NSManagedObjectContext MR_defaultContext]];
    
    User_Item_Info *fatInfo = [User_Item_Info MR_findFirstWithPredicate:[NSPredicate predicateWithFormat:@"userId==%d AND itemId==%d",user.userId.intValue,[TestItemID getFat]] sortedBy:@"testDate" ascending:false inContext:[NSManagedObjectContext MR_defaultContext]];
    
    if (muscleInfo==nil|| weightInfo==nil|| fatInfo==nil) {
        //没有测试，这里直接退出
        return;
    }
    float muscleValue = muscleInfo.testValue.floatValue;
    NSNumber *weight = weightInfo.testValue;
    NSNumber *fat = fatInfo.testValue;
    
    int sex = user.sex.intValue;
    float weektarget = 0.3;
    float sporttarget=50;
    float foodtarget=50;
    if (pinfo!=nil) {
        weektarget = pinfo.weekTarget.floatValue;
        sporttarget=pinfo.sportSubtract.floatValue;
        foodtarget = pinfo.foodSubtract.floatValue;
    }
    bool sex1 = sex==1?true:false;
    float minMuscle =[TestItemCalc calcMinMuscle:user.height pSexy:sex1].floatValue;
    float maxMuscle =[TestItemCalc calcMaxMuscle:user.height pSexy:sex1].floatValue;
    float pbf = [TestItemCalc calcPBF:weight pFat:fat].floatValue;
    
    AppCloundService* s= [[AppCloundService alloc] initWidthDelegate:self];
    [s getFoodPrescription:user.userId.intValue sex:sex pbf:pbf muscle:muscleValue m1:(minMuscle+maxMuscle)/2 m2:minMuscle weeksubtact:weektarget sporttarget:sporttarget foodtarget:foodtarget];
    
}

-(void)serviceSuccessed:(NSDictionary*)keyValues pMethod:(NSString*)method
{
    if(keyValues.count>0)
    {
        //早餐
        NSArray *Breakfast = [keyValues objectForKey:@"Breakfast"];
        if (![Breakfast isEqual:[NSNull null]]&&Breakfast.count >= 1) {
            [self addViewItems:Breakfast foodType:1];
        }
        //早餐合计卡路里
        float BreakfastCaloriesValue = [[keyValues objectForKey:@"BreakfastCaloriesValue"] floatValue];
        [self addViewItem:[NSString stringWithFormat:@"%.1f",BreakfastCaloriesValue] isTotal:false];
        
        
        //午餐
        NSArray *Lunch = [keyValues objectForKey:@"Lunch"];
        if (![Lunch isEqual:[NSNull null]]&&Lunch.count >= 1 ) {
            [self addViewItems:Lunch foodType:2];
        }
        //午餐合计卡路里
        float LunchCaloriesValue = [[keyValues objectForKey:@"LunchCaloriesValue"] floatValue];
        [self addViewItem:[NSString stringWithFormat:@"%.1f",LunchCaloriesValue] isTotal:false];
        
        
        //晚餐
        NSArray *Dinner = [keyValues objectForKey:@"Dinner"];
        if (![Dinner isEqual:[NSNull null]]&&Dinner.count >= 1) {
            [self addViewItems:Dinner foodType:3];
        }
        
        //晚餐合计卡路里
        float DinnerCaloriesValue = [[keyValues objectForKey:@"DinnerCaloriesValue"] floatValue];
        [self addViewItem:[NSString stringWithFormat:@"%.1f",DinnerCaloriesValue] isTotal:false];
        
        
        //全天合计卡路里
        float DayCaloriesValue = [[keyValues objectForKey:@"DayCaloriesValue"] floatValue];
        [self addViewItem:[NSString stringWithFormat:@"%.1f",DayCaloriesValue] isTotal:true];
        
    }
    else
    {
        [self addViewItem:@"分析营养建议失败，请检查您的网络连接是否正常。" isTotal:false];
    }
}

-(void)serviceFailed:(NSString*) message pMethod:(NSString*)method
{
    [self addViewItem:@"连接网络失败，请检查您的网络连接是否正常。" isTotal:false];
}

-(void)addViewItems:(NSArray*)clist foodType:(int)foodType
{
    switch (foodType) {
        case 1:
            [self addViewItemsHeader:@"早餐"];
            break;
        case 2:
            [self addViewItemsHeader:@"午餐"];
            break;
        case 3:
            [self addViewItemsHeader:@"晚餐"];
            break;
    }
    for(id obj in clist){
        int height=0;
        for(UIView* view in self.text_view_container.subviews)
        {
            height+=view.frame.size.height;
            height+20;
        }
        UILabel* label = [[UILabel alloc] initWithFrame:CGRectZero];
        CGFloat width = self.text_view_container.frame.size.width-10;
        UIFont*  font = [UIFont systemFontOfSize:12.0];
        label.font = font;
        label.textColor = [UIColor whiteColor];
        label.numberOfLines = 0;
        label.lineBreakMode = UILineBreakModeWordWrap;
        label.text = [NSString stringWithFormat:@"%@",obj];
        // 方法一,用文字来确定
        CGSize size = [label.text sizeWithFont:font constrainedToSize:CGSizeMake(width, 2000.0) lineBreakMode:UILineBreakModeWordWrap];
        label.frame = CGRectMake(10, height, 285, size.height);
        [self.text_view_container addSubview:label];
    }
}

-(void)addViewItemsHeader:(NSString*)headerText
{
    int height=0;
    for(UIView* view in self.text_view_container.subviews)
    {
        height+=view.frame.size.height;
        height+26;
    }
    
    UIView * whiteView = [[UIView alloc]initWithFrame:CGRectMake(15, height+10, 6, 6)];
    whiteView.layer.cornerRadius = 3;
    whiteView.layer.backgroundColor = [UIColor whiteColor].CGColor;
    whiteView.alpha=0.4;
    whiteView.tag=1001;
    [self.text_view_container addSubview:whiteView];
    
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectZero];
    UIFont*  font = [UIFont systemFontOfSize:12.0];
    label.font = font;
    label.textColor = [UIColor whiteColor];
    label.numberOfLines = 0;
    label.text = [NSString stringWithFormat:@"%@",headerText];
    label.frame = CGRectMake(24, height, 25, 26);
    [self.text_view_container addSubview:label];
    
    UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(50, height+13, 235, 1)];
    lineView.layer.cornerRadius = 3;
    lineView.layer.backgroundColor = [UIColor whiteColor].CGColor;
    lineView.alpha=0.4;
    lineView.tag=1001;
    [self.text_view_container addSubview:lineView];
    
}

-(void)addViewItem:(NSString*)content isTotal:(bool)isTotal
{
    if (isTotal) {
        content = [NSString stringWithFormat:@"合计：%@千卡",content];
    }
    else
    {
        content = [NSString stringWithFormat:@"小计：%@千卡",content];
    }
    int height=0;
    for(UIView* view in self.text_view_container.subviews)
    {
        height+=view.frame.size.height;
        height+20;
    }
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectZero];
    CGFloat width = self.text_view_container.frame.size.width-10;
    UIFont*  font = [UIFont systemFontOfSize:12.0];
    label.font = font;
    label.textAlignment=NSTextAlignmentRight;
    label.textColor = [UIColor whiteColor];
    label.numberOfLines = 0;
    label.lineBreakMode = UILineBreakModeWordWrap;
    label.text = content;
    // 方法一,用文字来确定
    CGSize size = [content sizeWithFont:font constrainedToSize:CGSizeMake(width, 2000.0) lineBreakMode:UILineBreakModeWordWrap];
    label.frame = CGRectMake(10, height, 275, size.height);
    [self.text_view_container addSubview:label];
}

-(void)initUI
{
    UIColor *borderColor = [UIColor colorWithRed:255.0 green:255.0 blue:255.0 alpha:0.05];
    _text_view_container.layer.masksToBounds = YES;
    _text_view_container.layer.cornerRadius = 6.0;
    _text_view_container.layer.borderWidth = 0.0;
    _text_view_container.layer.borderColor = [borderColor CGColor];
    _text_view_container.layer.backgroundColor=[borderColor CGColor];
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