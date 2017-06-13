//
//  SportSuggestionsViewController.m
//  TFHealth
//
//  Created by hzth hzth－mac2 on 5/27/14.
//  Copyright (c) 2014 studio37. All rights reserved.
//

#import "SportSuggestionsViewController.h"
#import "AddSportViewController.h"
#import "AppCloundService.h"
#import "PersonalSet.h"
#import "User_Item_Info.h"
#import "TestItemID.h"
#import "TestItemCalc.h"
#import "AppDelegate.h"
#import "UIViewController+CWPopup.h"
#import "SportTipsViewController.h"

@interface SportSuggestionsViewController ()
{
    NSString* tips;
}

@property (weak, nonatomic) IBOutlet UIScrollView *text_view_container;

-(double)getOffsetHeight;
-(void)tipsClicked:(UIButton*)sender;
@end

@implementation SportSuggestionsViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (IBAction)backButtonClick:(id)sender {
    //[self.navigationController popViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:true completion:nil];
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
    tips=@"";
    AppDelegate *appdelegate =(AppDelegate*) [[UIApplication sharedApplication] delegate];
    User* user = appdelegate.user;
    
    PersonalSet *pinfo = [PersonalSet MR_findFirstWithPredicate:[NSPredicate predicateWithFormat:@"userId==%d",user.userId.intValue] sortedBy:@"startDate" ascending:false inContext:[NSManagedObjectContext MR_defaultContext]];
    
    User_Item_Info *muscleInfo = [User_Item_Info MR_findFirstWithPredicate:[NSPredicate predicateWithFormat:@"userId==%d AND itemId==%d",user.userId.intValue,[TestItemID getMuscle]] sortedBy:@"testDate" ascending:false inContext:[NSManagedObjectContext MR_defaultContext]];
    
    User_Item_Info *weightInfo = [User_Item_Info MR_findFirstWithPredicate:[NSPredicate predicateWithFormat:@"userId==%d AND itemId==%d",user.userId.intValue,[TestItemID getWeight]] sortedBy:@"testDate" ascending:false inContext:[NSManagedObjectContext MR_defaultContext]];
    
    User_Item_Info *fatInfo = [User_Item_Info MR_findFirstWithPredicate:[NSPredicate predicateWithFormat:@"userId==%d AND itemId==%d",user.userId.intValue,[TestItemID getFat]] sortedBy:@"testDate" ascending:false inContext:[NSManagedObjectContext MR_defaultContext]];
    
    if (muscleInfo==nil|| weightInfo==nil|| fatInfo==nil) {
        [self addViewItem:@"无检测数据，请先进行检测" isTitle:false];
        //没有测试，这里直接退出
        return;
    }
    float muscleValue = muscleInfo.testValue.floatValue;
    NSNumber *weight = weightInfo.testValue;
    NSNumber *fat = fatInfo.testValue;
    
    int sex = user.sex.intValue;
    int age = user.birthday.intValue;
    float weektarget = 0.3;
    if (pinfo!=nil) {
        weektarget = pinfo.weekTarget.floatValue;
    }
    bool sex1 = sex==1?true:false;
    float minMuscle =[TestItemCalc calcMinMuscle:user.height pSexy:sex1].floatValue;
    float maxMuscle =[TestItemCalc calcMaxMuscle:user.height pSexy:sex1].floatValue;
    float pbf = [TestItemCalc calcPBF:weight pFat:fat].floatValue;
    
    AppCloundService* s= [[AppCloundService alloc] initWidthDelegate:self];
    [s getSportPrescription:user.userId.intValue sex:sex pbf:pbf muscle:muscleValue m1:(minMuscle+maxMuscle)/2 m2:minMuscle age:age weeksubtact:weektarget];
    
}

-(void)serviceSuccessed:(NSDictionary*)keyValues pMethod:(NSString*)method
{
    if(keyValues.count>0)
    {
        //运动处方主题-1
        NSString *Title_DESC = [keyValues objectForKey:@"Title_DESC"];
        if (![Title_DESC isEqual:[NSNull null]]&&[Title_DESC length] >= 1 ) {
            [self addViewItem:Title_DESC isTitle:false];
        }
        
        //目标-2
        NSString *Target_DESC = [keyValues objectForKey:@"Target_DESC"];
        if (![Target_DESC isEqual:[NSNull null]]&&[Target_DESC length] >= 1 ) {
            [self addViewItem:Target_DESC isTitle:true];
        }
        
        //保持心率-3
        NSString *HeartRate_DESC = [keyValues objectForKey:@"HeartRate_DESC"];
        if (![HeartRate_DESC isEqual:[NSNull null]]&&[HeartRate_DESC length] >= 1 ) {
            [self addViewItem:HeartRate_DESC isTitle:false];
        }
        
        //建议运动描述-4
        NSString *Sport_DESC = [keyValues objectForKey:@"Sport_DESC"];
        if (![Sport_DESC isEqual:[NSNull null]]&&[Sport_DESC length] >= 1 ) {
            [self addViewItem:Sport_DESC isTitle:true];
        }
        
        //建议运动内容-5
        NSArray *Sport_Content = [keyValues objectForKey:@"Sport_Content"];
        if (![Sport_Content isEqual:[NSNull null]]&&Sport_Content.count >= 1 ) {
            [self addViewItems:Sport_Content isTitle:false];
        }
        
        //辅助运动描述-6
        NSString *Auxiliary_DESC = [keyValues objectForKey:@"Auxiliary_DESC"];
        if (![Auxiliary_DESC isEqual:[NSNull null]]&&[Auxiliary_DESC length] >= 1 ) {
            [self addViewItem:Auxiliary_DESC isTitle:true];
        }
        
        //运动频率-7
        NSString *Frequency_DESC = [keyValues objectForKey:@"Frequency_DESC"];
        if (![Frequency_DESC isEqual:[NSNull null]]&&[Frequency_DESC length] >= 1 ) {
            [self addViewItem:Frequency_DESC isTitle:true];
        }
        
        //小贴士描述-8
        NSString *Tips_DESC = [keyValues objectForKey:@"Tips_DESC"];
        if (![Tips_DESC isEqual:[NSNull null]]&&[Tips_DESC length] >= 1 ) {
            //[self addViewItem:Tips_DESC isTitle:true];
            //            double h = [self getOffsetHeight];
            //            UIImageView* img=[[UIImageView alloc] initWithFrame:CGRectMake(10,h+10, 24, 24)];
            //            img.image=[UIImage imageNamed:@"tips.png"];
            //            //img.tag=1001;
            //            [self.text_view_container addSubview:img];
        }
        //小贴士内容-9
        NSString *Tips_Content = [keyValues objectForKey:@"Tips_Content"];
        if (![Tips_Content isEqual:[NSNull null]]&&[Tips_Content length] >= 1 ) {
            //[self addViewItem:Tips_Content isTitle:false];
            double h = [self getOffsetHeight];
            UIButton* btn = [[UIButton alloc] init];
            [btn setFont:[UIFont systemFontOfSize:12.0]];
            [btn setTitle:@" 运动小贴示 " forState:UIControlStateNormal];
            [btn setFrame:CGRectMake(10, h+10, 96, 24)];
            [btn setBackgroundImage:[UIImage imageNamed:@"round_btn_normal"] forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(tipsClicked:) forControlEvents:UIControlEventTouchUpInside];
            UIImage* icon  = [UIImage imageNamed:@"tips_small"];
            [btn setImage:icon forState:UIControlStateNormal];
            [self.text_view_container addSubview:btn];
            tips = Tips_Content;
        }
    }
    else
    {
        [self addViewItem:@"分析运动处方失败，请检查您的网络连接是否正常。" isTitle:false];
    }
}

-(void)serviceFailed:(NSString*) message pMethod:(NSString*)method
{
    [self addViewItem:@"分析运动处方失败，请检查您的网络连接是否正常。" isTitle:false];
}

-(double)getOffsetHeight
{
    double height=0;
    for(UIView* view in self.text_view_container.subviews)
    {
        if(view.tag==1001 || [view isKindOfClass:[UILabel class]])
        {
            height= view.frame.origin.y+view.frame.size.height;
        }
    }
    return height;
}

-(void)tipsClicked:(UIButton*)sender
{
   SportTipsViewController* v = [self.storyboard instantiateViewControllerWithIdentifier:@"SportTipsViewController"];
    
    [self presentPopupViewController:v animated:true completion:^(void){
        [v setTips:tips];
        [v setOwener:self];
    }];
}

-(void)addViewItem:(NSString*)content isTitle:(bool)isTitle
{
    double height=[self getOffsetHeight];
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.tag=1001;
    CGFloat width = self.text_view_container.frame.size.width-10;
    
    if(isTitle)
    {
        UIView * whiteView = [[UIView alloc]initWithFrame:CGRectMake(15, height+10, 6, 6)];
        whiteView.layer.cornerRadius = 3;
        whiteView.layer.backgroundColor = [UIColor whiteColor].CGColor;
        whiteView.alpha=0.4;
        whiteView.tag=1001;
        [self.text_view_container addSubview:whiteView];
        
        UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(25, height+13, 260, 1)];
        lineView.layer.cornerRadius = 3;
        lineView.layer.backgroundColor = [UIColor whiteColor].CGColor;
        lineView.alpha=0.4;
        lineView.tag=1001;
        [self.text_view_container addSubview:lineView];
        height+=26;
    }

    
    UIFont*  font = [UIFont systemFontOfSize:12.0];
    label.font = font;
    label.textColor = [UIColor whiteColor];
    label.numberOfLines = 0;
    label.lineBreakMode = NSLineBreakByWordWrapping;
    label.text = content;
    NSDictionary *attribute = @{NSFontAttributeName: font};
     CGRect size = [content boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:NSLineBreakByWordWrapping|NSStringDrawingUsesLineFragmentOrigin attributes:attribute context:nil];

    label.frame = CGRectMake(10, height, 285, size.size.height);
    [self.text_view_container addSubview:label];
}

-(void)addViewItems:(NSArray*)clist isTitle:(bool)isTitle
{
    for(id obj in clist){
        [self addViewItem:[NSString stringWithFormat:@"%@",obj] isTitle:false];        
    }
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
