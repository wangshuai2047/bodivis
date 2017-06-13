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
    [self addInfoViewItem:CustomLocalizedString(@"helpInfoItem1", nil)];
    [self addInfoViewItem:CustomLocalizedString(@"helpInfoItem2", nil)];
    [self addInfoViewItem:CustomLocalizedString(@"helpInfoItem3", nil)];
    
    [self addInfoViewItem:CustomLocalizedString(@"helpInfoItem4", nil)];
    [self addInfoViewItem:CustomLocalizedString(@"helpInfoItemA", nil)];
    [self addInfoViewItem:CustomLocalizedString(@"helpInfoItemB", nil)];
    [self addInfoViewItem:CustomLocalizedString(@"helpInfoItemC", nil)];
    [self addInfoViewItem:CustomLocalizedString(@"helpInfoItemD", nil)];
    [self addInfoViewItem:CustomLocalizedString(@"helpInfoItemE", nil)];
    
    [self addLoginViewItem:CustomLocalizedString(@"helpLoginItemA", nil)];
    [self addLoginViewItem:CustomLocalizedString(@"helpLoginItemB", nil)];
    [self addLoginViewItem:CustomLocalizedString(@"helpLoginItemC", nil)];
    [self addLoginViewItem:CustomLocalizedString(@"helpLoginItemD", nil)];
    
    [self addTestViewItem:CustomLocalizedString(@"helpTestItem1", nil)];
    [self addTestViewItem:CustomLocalizedString(@"helpTestItem1A", nil)];
    [self addTestViewItem:CustomLocalizedString(@"helpTestItem1B", nil)];
    [self addTestViewItem:CustomLocalizedString(@"helpTestItem2", nil)];
    
    [self addTestViewItem:@""];
    [self addTestViewItem:CustomLocalizedString(@"helpWarnItem1", nil)];
    [self addTestViewItem:CustomLocalizedString(@"helpWarnItem2", nil)];
    [self addTestViewItem:CustomLocalizedString(@"helpWarnItem3", nil)];
    [self addTestViewItem:CustomLocalizedString(@"helpWarnItem4", nil)];
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
