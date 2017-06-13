//
//  BodyStyleViewController.m
//  TFHealth
//
//  Created by chenzhiqiang on 14-8-1.
//  Copyright (c) 2014年 studio37. All rights reserved.
//

#import "BodyStyleViewController.h"
#import "AppDelegate.h"

@interface BodyStyleViewController ()
@property (weak, nonatomic) IBOutlet UIView *view1;
@property (weak, nonatomic) IBOutlet UIView *view2;
@property (weak, nonatomic) IBOutlet UIView *view3;
@property (weak, nonatomic) IBOutlet UIView *view4;
@property (weak, nonatomic) IBOutlet UIView *view5;
@property (weak, nonatomic) IBOutlet UIView *view6;
@property (weak, nonatomic) IBOutlet UIView *view7;
@property (weak, nonatomic) IBOutlet UIView *view8;
@property (weak, nonatomic) IBOutlet UIView *view9;

@property (weak, nonatomic) IBOutlet UIImageView *view_body1;
@property (weak, nonatomic) IBOutlet UIImageView *view_body2;
@property (weak, nonatomic) IBOutlet UIImageView *view_body3;
@property (weak, nonatomic) IBOutlet UIImageView *view_body4;
@property (weak, nonatomic) IBOutlet UIImageView *view_body5;
@property (weak, nonatomic) IBOutlet UIImageView *view_body6;
@property (weak, nonatomic) IBOutlet UIImageView *view_body7;
@property (weak, nonatomic) IBOutlet UIImageView *view_body8;
@property (weak, nonatomic) IBOutlet UIImageView *view_body9;

@property (weak, nonatomic) IBOutlet UILabel *view_text1;
@property (weak, nonatomic) IBOutlet UILabel *view_text2;
@property (weak, nonatomic) IBOutlet UILabel *view_text3;
@property (weak, nonatomic) IBOutlet UILabel *view_text4;
@property (weak, nonatomic) IBOutlet UILabel *view_text5;
@property (weak, nonatomic) IBOutlet UILabel *view_text6;
@property (weak, nonatomic) IBOutlet UILabel *view_text7;
@property (weak, nonatomic) IBOutlet UILabel *view_text8;
@property (weak, nonatomic) IBOutlet UILabel *view_text9;

@end

@implementation BodyStyleViewController

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
    // Do any additional setup after loading the view.
    UIToolbar *toolbarBackground = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 300, 420)];
    //[self.view addSubview:toolbarBackground];
    //[self.view sendSubviewToBack:toolbarBackground];
    [self initUI];
}

-(void)initUI
{
    UIColor *borderColor = [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:0.05];
    self.view.layer.masksToBounds = YES;
    self.view.layer.cornerRadius = 6.0;
    self.view.layer.borderWidth = 0.0;
    self.view.layer.borderColor = [borderColor CGColor];
    self.view.layer.backgroundColor=[borderColor CGColor];
}

-(void)initBodyStyle:(NSString*)styleName
{
    AppDelegate *appdelegate =(AppDelegate*) [[UIApplication sharedApplication] delegate];
    
    User* user = appdelegate.user;
    int styleIndex=[self getStyleIndex:styleName];
    UIColor *fontColor = [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1];
    UIColor *curFontColor = [UIColor colorWithRed:104.0/255.0 green:196.0/255.0 blue:255.0/255.0 alpha:1];
    
    NSArray *views = [[NSArray alloc] initWithObjects:_view_body1,_view_body2,_view_body3,_view_body4,_view_body5,_view_body6,_view_body7,_view_body8,_view_body9,nil];
    NSArray *texts = [[NSArray alloc] initWithObjects:_view_text1,_view_text2,_view_text3,_view_text4,_view_text5,_view_text6,_view_text7,_view_text8,_view_text9,nil];
    for (int i=0; i<9; i++) {
        UILabel *txt = [texts objectAtIndex:i];
        UIImageView *v=[views objectAtIndex:i];
        if(i!=styleIndex)
        {
            if (user.sex.intValue==2) {
                [v setImage:[UIImage imageNamed:[NSString stringWithFormat:@"11_girlbody%d",i+1]]];
            }
            else
            {
                [v setImage:[UIImage imageNamed:[NSString stringWithFormat:@"11_body%d",i+1]]];
            }
            txt.textColor=fontColor;
        }
        else
        {
            if (user.sex.intValue==2) {
                [v setImage:[UIImage imageNamed:[NSString stringWithFormat:@"11_girlbody%d_c",i+1]]];
            }
            else
            {
                [v setImage:[UIImage imageNamed:[NSString stringWithFormat:@"11_body%d_c",i+1]]];
            }
            txt.textColor=curFontColor;
            //txt.text=@"我变色了";
        }
    }
}

-(int)getStyleIndex:(NSString*)name
{
    NSArray *texts = [[NSArray alloc] initWithObjects:@"消瘦型",@"低脂肪型",@"运动员型",@"肌肉不足型",@"健康匀称型",@"超重肌肉型",@"隐性肥胖型",@"脂肪过多型",@"肥胖型",nil];
    int index =0;
    for (int i=0; i<9; i++) {
        if ([name isEqualToString:[texts objectAtIndex:i]]) {
            index = i;
        }
    }
    return index;
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
