//
//  MainViewController.m
//  TFHealth
//
//  Created by nico on 14-5-15.
//  Copyright (c) 2014年 studio37. All rights reserved.
//

#import "MainViewController.h"
#import "UIViewController+MMDrawerController.h"
#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}
#pragma mark - 添加-彭显鹤-5.27-添加导航栏按钮响应
- (IBAction)myAccountButtonClick:(id)sender {
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideRight animated:YES completion:nil];
}
- (IBAction)menuButtonClick:(id)sender {
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}
#pragma mark - 添加-彭显鹤-5.27-添加导航栏按钮响应


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //UIViewController * hsvc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateInitialViewController];
    
//    UIBarButtonItem* leftDrawerButton = [[UIBarButtonItem  alloc] init];
//    [leftDrawerButton setTitle: @"功能"] ;
//    UIBarButtonItem* rightDrawerButton = [[UIBarButtonItem  alloc] init];
//    [rightDrawerButton setTitle: @"用户"] ;
//    [self.navigationItem setLeftBarButtonItem:leftDrawerButton animated:YES];
//    [self.navigationItem setRightBarButtonItem:rightDrawerButton animated:YES];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
