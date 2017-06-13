//
//  InstructionsViewController.m
//  TFHealth
//
//  Created by 王帅 on 2017/5/9.
//  Copyright © 2017年 studio37. All rights reserved.
//

#import "InstructionsViewController.h"
#import "UIViewController+MMDrawerController.h"


#define Screen_Width  [UIScreen mainScreen].bounds.size.width
#define Screen_Height [UIScreen mainScreen].bounds.size.height
#define view_Width [UIScreen mainScreen].bounds.size.width - 20
#define TitleHeight 32


@interface InstructionsViewController ()<UIScrollViewDelegate>{
    UIScrollView *bgScrollView;
    UIView *info_View,*login_View,*test_View;
    float infoHeight,loginHeight,testHeight;
}

@end

@implementation InstructionsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    infoHeight = 0.0;
    loginHeight = 0.0;
    testHeight = 0.0;
    
    //设置背景
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg"]];
    //设置导航栏
    [self initWithNavigationItem];
    //设置滚动视图
    [self initWithScrollView];
    
    [self addTitleLabel:CustomLocalizedString(@"titleLabel1", nil) y:0];
    [self addInfoViewItem:CustomLocalizedString(@"helpInfoItem1", nil)];
    [self addInfoViewItem:CustomLocalizedString(@"helpInfoItem2", nil)];
    [self addInfoViewItem:CustomLocalizedString(@"helpInfoItem3", nil)];
    
    [self addInfoViewItem:CustomLocalizedString(@"helpInfoItem4", nil)];
    [self addInfoViewItem:CustomLocalizedString(@"helpInfoItemA", nil)];
    [self addInfoViewItem:CustomLocalizedString(@"helpInfoItemB", nil)];
    [self addInfoViewItem:CustomLocalizedString(@"helpInfoItemC", nil)];
    [self addInfoViewItem:CustomLocalizedString(@"helpInfoItemD", nil)];
    [self addInfoViewItem:CustomLocalizedString(@"helpInfoItemE", nil)];
    
    [self addTitleLabel:CustomLocalizedString(@"titleLabel2", nil) y:info_View.frame.origin.y + info_View.frame.size.height];
    [self addLoginViewItem:CustomLocalizedString(@"helpLoginItemA", nil)];
    [self addLoginViewItem:CustomLocalizedString(@"helpLoginItemB", nil)];
    [self addLoginViewItem:CustomLocalizedString(@"helpLoginItemC", nil)];
    [self addLoginViewItem:CustomLocalizedString(@"helpLoginItemD", nil)];
    
    [self addTitleLabel:CustomLocalizedString(@"titleLabel3", nil) y:login_View.frame.origin.y + login_View.frame.size.height];
    [self addTestViewItem:CustomLocalizedString(@"helpTestItem1", nil)];
    [self addTestViewItem:CustomLocalizedString(@"helpTestItem1A", nil)];
    [self addTestViewItem:CustomLocalizedString(@"helpTestItem1B", nil)];
    [self addTestViewItem:CustomLocalizedString(@"helpTestItem2", nil)];
    
    [self addTestViewItem:@""];
    [self addTestViewItem:CustomLocalizedString(@"helpWarnItem1", nil)];
    [self addTestViewItem:CustomLocalizedString(@"helpWarnItem2", nil)];
    [self addTestViewItem:CustomLocalizedString(@"helpWarnItem3", nil)];
    [self addTestViewItem:CustomLocalizedString(@"helpWarnItem4", nil)];
    
    //设置滚动视图内容大小
    bgScrollView.contentSize = CGSizeMake(view_Width, infoHeight + loginHeight + testHeight + TitleHeight * 3 + 50);

}

#pragma mark - 设置导航栏
-(void)initWithNavigationItem{
    UINavigationBar *bar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 64)];
    UINavigationItem *item = [[UINavigationItem alloc] initWithTitle:CustomLocalizedString(@"instructions", nil)];
    UIButton *left = [UIButton buttonWithType:UIButtonTypeCustom];
    [left setFrame:CGRectMake(0, 2, 28, 28)];
    [left setImage:[UIImage imageNamed:@"back_btn"] forState:UIControlStateNormal];
    [left addTarget:self action:@selector(backBtn:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithCustomView:left];
    [item setLeftBarButtonItem:leftButton];
    [bar pushNavigationItem:item animated:NO];
    [self.view addSubview:bar];
}

//导航栏返回按钮
-(void)backBtn:(UIButton*)sender{
    
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}

#pragma mark - 设置滚动视图
-(void)initWithScrollView{
    bgScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64 + 5, Screen_Width, Screen_Height - 64)];
    bgScrollView.backgroundColor = [UIColor clearColor];
    // 是否支持滑动最顶端
    //    scrollView.scrollsToTop = NO;
    bgScrollView.delegate = self;
    // 是否反弹
    //    scrollView.bounces = NO;
    // 是否分页
    //    scrollView.pagingEnabled = YES;
    // 是否滚动
    bgScrollView.scrollEnabled = YES;
    //    scrollView.showsHorizontalScrollIndicator = NO;
    // 设置indicator风格
    //    scrollView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
    // 设置内容的边缘和Indicators边缘
    //    scrollView.contentInset = UIEdgeInsetsMake(0, 50, 50, 0);
    //    scrollView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 50, 0, 0);
    // 提示用户,Indicators flash
    [bgScrollView flashScrollIndicators];
    // 是否同时运动,lock
    bgScrollView.directionalLockEnabled = YES;
    [self.view addSubview:bgScrollView];
    
    
    info_View = [[UIView alloc]initWithFrame:CGRectMake(10, 0, view_Width, 200)];
    info_View.backgroundColor = [UIColor clearColor];
    [bgScrollView addSubview:info_View];
    
    login_View = [[UIView alloc]initWithFrame:CGRectMake(10, info_View.frame.origin.y + info_View.frame.size.height, view_Width, 200)];
    login_View.backgroundColor = [UIColor clearColor];
    [bgScrollView addSubview:login_View];
    
    test_View = [[UIView alloc]initWithFrame:CGRectMake(10, login_View.frame.origin.y + login_View.frame.size.height, view_Width, 200)];
    test_View.backgroundColor = [UIColor clearColor];
    [bgScrollView addSubview:test_View];
}

-(void)addTitleLabel:(NSString*)title y:(float)y
{
    UILabel *titlelabel = [[UILabel alloc]initWithFrame:CGRectMake(10, y, view_Width, TitleHeight)];
    titlelabel.backgroundColor = [UIColor clearColor];
    titlelabel.text = title;
    titlelabel.textAlignment = NSTextAlignmentCenter;
    UIFont*  font = [UIFont systemFontOfSize:12.0];
    titlelabel.font = font;
    titlelabel.textColor = [UIColor whiteColor];
    titlelabel.lineBreakMode = NSLineBreakByWordWrapping;
    [bgScrollView addSubview:titlelabel];
}

-(void)addInfoViewItem:(NSString*)content
{
    int height=0;
    for(UIView* view in info_View.subviews)
    {
        if(view.tag==1001 || [view isKindOfClass:[UILabel class]])
        {
            height+= view.frame.size.height;
        }
    }
    
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.tag=1001;
    CGFloat width = info_View.frame.size.width-10;
    
    UIFont*  font = [UIFont systemFontOfSize:11.0];
    label.font = font;
    label.textColor = [UIColor whiteColor];
    label.numberOfLines = 0;
    label.lineBreakMode = NSLineBreakByWordWrapping;
    label.text = content;
    NSDictionary *attribute = @{NSFontAttributeName: font};
    CGRect size = [content boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:NSLineBreakByWordWrapping|NSStringDrawingUsesLineFragmentOrigin attributes:attribute context:nil];
    label.backgroundColor = [UIColor clearColor];
    label.frame = CGRectMake(10, height, 285, size.size.height);
    
    infoHeight += label.frame.size.height;
    info_View.frame = CGRectMake(10, TitleHeight, view_Width, infoHeight);
    
    [info_View addSubview:label];
}

-(void)addLoginViewItem:(NSString*)content
{
    int height=0;
    for(UIView* view in login_View.subviews)
    {
        if(view.tag==1001 || [view isKindOfClass:[UILabel class]])
        {
            height+= view.frame.size.height;
        }
    }
    
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.tag=1001;
    CGFloat width = login_View.frame.size.width-10;
    
    UIFont*  font = [UIFont systemFontOfSize:11.0];
    label.font = font;
    label.textColor = [UIColor whiteColor];
    label.numberOfLines = 0;
    label.lineBreakMode = NSLineBreakByWordWrapping;
    label.text = content;
    NSDictionary *attribute = @{NSFontAttributeName: font};
    CGRect size = [content boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:NSLineBreakByWordWrapping|NSStringDrawingUsesLineFragmentOrigin attributes:attribute context:nil];
    label.backgroundColor = [UIColor clearColor];
    label.frame = CGRectMake(10, height, 285, size.size.height);
    
    loginHeight += label.frame.size.height;
    login_View.frame = CGRectMake(10, info_View.frame.origin.y + info_View.frame.size.height + TitleHeight, view_Width, loginHeight);
    
    [login_View addSubview:label];
}

-(void)addTestViewItem:(NSString*)content
{
    int height=0;
    for(UIView* view in test_View.subviews)
    {
        if(view.tag==1001 || [view isKindOfClass:[UILabel class]])
        {
            height+= view.frame.size.height;
        }
    }
    
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.tag=1001;
    CGFloat width = test_View.frame.size.width-10;
    
    UIFont*  font = [UIFont systemFontOfSize:11.0];
    label.font = font;
    label.textColor = [UIColor whiteColor];
    label.numberOfLines = 0;
    label.lineBreakMode = NSLineBreakByWordWrapping;
    label.text = content;
    NSDictionary *attribute = @{NSFontAttributeName: font};
    CGRect size = [content boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:NSLineBreakByWordWrapping|NSStringDrawingUsesLineFragmentOrigin attributes:attribute context:nil];
    label.backgroundColor = [UIColor clearColor];
    label.frame = CGRectMake(10, height, 285, size.size.height);
    
    testHeight += label.frame.size.height;
    test_View.frame = CGRectMake(10, login_View.frame.origin.y + login_View.frame.size.height + TitleHeight, view_Width, testHeight);

    [test_View addSubview:label];
}

#pragma mark - UIScrollViewDelegate
// scrollView 已经滑动
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSLog(@"scrollViewDidScroll");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
