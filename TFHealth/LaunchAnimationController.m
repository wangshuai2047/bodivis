//
//  LaunchAnimationController.m
//  ReplaceLaunchImage
//
//  Created by 王帅 on 2017/4/25.
//  Copyright © 2017年 王帅. All rights reserved.
//

#import "LaunchAnimationController.h"
#import "FLAnimatedImage.h"
#import "FLAnimatedImageView.h"
#import "AppDelegate.h"
#import "AppDelegate+XHLaunchAd.h"
#import "AppCloundService.h"

//#import "ViewController.h"

#define Screen_Width  [UIScreen mainScreen].bounds.size.width
#define Screen_Height [UIScreen mainScreen].bounds.size.height

@interface LaunchAnimationController ()<ServiceObjectDelegate>{
    FLAnimatedImageView *animatedImageView;
    AppDelegate *appDelegate;
}

@end

@implementation LaunchAnimationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    appDelegate = [[UIApplication sharedApplication] delegate];
    [self showLaunchAnimationController:^{
        [appDelegate loadSimilarAdsToLocalImage];
        [appDelegate setupXHLaunchAd];
//        appDelegate.window.rootViewController = [[UIStoryboard storyboardWithName:@"Account" bundle:nil]instantiateInitialViewController];

        appDelegate.window.rootViewController = [[UIStoryboard storyboardWithName:@"Account" bundle:nil] instantiateViewControllerWithIdentifier:@"LoginViewController"];
        
    }];
    
}

//block赋值
-(void)showLaunchAnimationController:(CompleteHandleBlock)completeBlock{
    [self initWithAnimatedImageView];
    self.completeBlock = completeBlock;
}

//加载动图
-(void)initWithAnimatedImageView{
    
    animatedImageView = [[FLAnimatedImageView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, Screen_Height)];

    NSURL *url = [[NSBundle mainBundle]URLForResource:@"kaiping2" withExtension:@"gif"];
    NSData *data = [NSData dataWithContentsOfURL:url];
    animatedImageView.animatedImage = [FLAnimatedImage animatedImageWithGIFData:data];
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:2.4 target:self selector:@selector(animationFinished) userInfo:nil repeats:NO];
    [self.view addSubview:animatedImageView];
}

-(void)animationFinished{
    
    self.completeBlock();
    
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
