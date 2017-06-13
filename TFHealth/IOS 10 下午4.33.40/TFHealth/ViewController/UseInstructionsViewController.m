//
//  UseInstructionsViewController.m
//  TFHealth
//
//  Created by chenzq on 14-8-13.
//  Copyright (c) 2014年 studio37. All rights reserved.
//

#import "UseInstructionsViewController.h"
#import "UIViewController+MMDrawerController.h"

@interface UseInstructionsViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *text_view_container;
@property (weak, nonatomic) IBOutlet UIView *info_View;
@property (weak, nonatomic) IBOutlet UIView *login_View;
@property (weak, nonatomic) IBOutlet UIView *test_View;
@end

@implementation UseInstructionsViewController

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
    
    //[self addViewItem:@"" Title:@"一．使用说明："];
    [self addInfoViewItem:@"全面监测人体21项健康数据；"];
    [self addInfoViewItem:@"提供运动监测和睡眠监测；"];
    [self addInfoViewItem:@"智能健康云为您提供专业的运动建议和营养膳食建议。"];
    
    [self addInfoViewItem:@"使用流程："];
    [self addInfoViewItem:@"A．下载并安装App；"];
    [self addInfoViewItem:@"B．注册并登陆App；"];
    [self addInfoViewItem:@"C．摇一摇，上称测试，测试完毕后下称；"];
    [self addInfoViewItem:@"D．查看21项健康数据，查看运动和膳食建议；"];
    [self addInfoViewItem:@"E．使用手环进行运动和睡眠监测。"];
    
    [self addLoginViewItem:@"A．输入手机号或者邮箱地址，填写密码；"];
    [self addLoginViewItem:@"B．填写个人信息（身高、年龄、性别）；"];
    [self addLoginViewItem:@"C．选择您的用户类型，分为手环、成分称和两者皆有；"];
    [self addLoginViewItem:@"D．注册完毕，输入用户名和密码，登陆。"];
    
    [self addTestViewItem:@"1．打开蓝牙。"];
    [self addTestViewItem:@"蓝牙默认为系统自动打开，打开后，手机右上方会出现蓝牙图标。"];
    [self addTestViewItem:@"如蓝牙为关闭状态，请手动打开蓝牙，蓝牙的打开方式为：进入手机里的“设定”-“连接”-“蓝牙”，打开蓝牙即可。"];
    [self addTestViewItem:@"2．打开并登录App，进入测试界面，摇一摇，然后上称，测试完成后下称，通过手机App查看测试数据和智能数据分析。"];
    
    [self addTestViewItem:@""];
    [self addTestViewItem:@"警告："];
    [self addTestViewItem:@"体内装有心脏起搏器及金属装置者禁用！"];
    [self addTestViewItem:@"孕妇请勿使用。"];
    [self addTestViewItem:@"适用年龄：7-99岁"];
}

-(void)addInfoViewItem:(NSString*)content
{
    int height=10;
    for(UIView* view in self.info_View.subviews)
    {
        if(view.tag==1001 || [view isKindOfClass:[UILabel class]])
        {
            height+= view.frame.size.height;
        }
    }
    
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.tag=1001;
    CGFloat width = self.info_View.frame.size.width-10;
    
    UIFont*  font = [UIFont systemFontOfSize:11.0];
    label.font = font;
    label.textColor = [UIColor whiteColor];
    label.numberOfLines = 0;
    label.lineBreakMode = NSLineBreakByWordWrapping;
    label.text = content;
    NSDictionary *attribute = @{NSFontAttributeName: font};
    CGRect size = [content boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:NSLineBreakByWordWrapping|NSStringDrawingUsesLineFragmentOrigin attributes:attribute context:nil];
    
    label.frame = CGRectMake(10, height, 285, size.size.height);
    
    [self.info_View addSubview:label];
}

-(void)addLoginViewItem:(NSString*)content
{
    int height=10;
    for(UIView* view in self.login_View.subviews)
    {
        if(view.tag==1001 || [view isKindOfClass:[UILabel class]])
        {
            height+= view.frame.size.height;
        }
    }
    
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.tag=1001;
    CGFloat width = self.login_View.frame.size.width-10;
    
    UIFont*  font = [UIFont systemFontOfSize:11.0];
    label.font = font;
    label.textColor = [UIColor whiteColor];
    label.numberOfLines = 0;
    label.lineBreakMode = NSLineBreakByWordWrapping;
    label.text = content;
    NSDictionary *attribute = @{NSFontAttributeName: font};
    CGRect size = [content boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:NSLineBreakByWordWrapping|NSStringDrawingUsesLineFragmentOrigin attributes:attribute context:nil];
    
    label.frame = CGRectMake(10, height, 285, size.size.height);
    
    [self.login_View addSubview:label];
}

-(void)addTestViewItem:(NSString*)content
{
    int height=10;
    for(UIView* view in self.test_View.subviews)
    {
        if(view.tag==1001 || [view isKindOfClass:[UILabel class]])
        {
            height+= view.frame.size.height;
        }
    }
    
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.tag=1001;
    CGFloat width = self.test_View.frame.size.width-10;
    
    UIFont*  font = [UIFont systemFontOfSize:11.0];
    label.font = font;
    label.textColor = [UIColor whiteColor];
    label.numberOfLines = 0;
    label.lineBreakMode = NSLineBreakByWordWrapping;
    label.text = content;
    NSDictionary *attribute = @{NSFontAttributeName: font};
    CGRect size = [content boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:NSLineBreakByWordWrapping|NSStringDrawingUsesLineFragmentOrigin attributes:attribute context:nil];
    
    label.frame = CGRectMake(10, height, 285, size.size.height);
    
    [self.test_View addSubview:label];
}

- (IBAction)backButtonClick:(id)sender {
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
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
