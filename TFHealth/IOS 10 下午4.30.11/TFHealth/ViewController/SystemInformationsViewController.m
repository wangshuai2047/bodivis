//
//  SystemInformationsViewController.m
//  TFHealth
//
//  Created by hzth hzth－mac2 on 5/27/14.
//  Copyright (c) 2014 studio37. All rights reserved.
//

#import "SystemInformationsViewController.h"
#import "SystemInformationsTableViewCell.h"
#import "HealthStatusViewController.h"
#import "UIViewController+MMDrawerController.h"

@interface SystemInformationsViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *systemInformationsTableView;

@end

@implementation SystemInformationsViewController

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
    self.systemInformationsTableView.delegate = self;
    self.systemInformationsTableView.dataSource = self;
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SystemInformationsTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"SystemInformationsTableViewCell"];
    cell.selectedBackgroundView = [[[UIView alloc] initWithFrame:cell.frame] init];
    cell.selectedBackgroundView.backgroundColor = [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:0.1];
    //cell.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Navigationbar"]];
    cell.textLabel.textColor=[UIColor colorWithWhite:255 alpha:1];
    if([indexPath row]==0 && indexPath.section == 0)
    {
        cell.textLabel.text=@"健康知识";
    }
    else if([indexPath row]==0 && indexPath.section == 1)
    {
        cell.textLabel.text=@"使用说明";
    }
    else if([indexPath row]==0 && indexPath.section == 2)
    {
        cell.textLabel.text=@"关于";
    }
    return cell;
}
- (IBAction)backButtonClikc:(id)sender {
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
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
