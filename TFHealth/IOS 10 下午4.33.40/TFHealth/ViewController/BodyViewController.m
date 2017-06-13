//
//  BodyViewController.m
//  TFHealth
//
//  Created by chenzq on 14-8-7.
//  Copyright (c) 2014年 studio37. All rights reserved.
//

#import "BodyViewController.h"
#import "UIViewController+MMDrawerController.h"

@interface BodyViewController ()
@property (nonatomic, strong) NSMutableArray* viewControllerArray;
@end

@implementation BodyViewController

- (void)viewDidLoad
{
    self.dataSource = self;
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)awakeFromNib
{
    NSUInteger numberOfPages = 2;
    self.viewControllerArray = [[NSMutableArray alloc] initWithCapacity:numberOfPages];
    for (NSUInteger k = 0; k < numberOfPages; ++k)
    {
        [self.viewControllerArray addObject:[NSNull null]];
    }
    
    [self.viewControllerArray replaceObjectAtIndex: 0 withObject: [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"BodyAnalysisNavViewController"]];
    [self.viewControllerArray replaceObjectAtIndex: 1 withObject: [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ComponentAnalysisNavViewController"]];
}

#pragma mark - DDScrollViewDataSource

- (NSUInteger)numberOfViewControllerInDDScrollView:(DDScrollViewController *)DDScrollView
{
    return [self.viewControllerArray count];
}

- (UIViewController*)ddScrollView:(DDScrollViewController *)ddScrollView contentViewControllerAtIndex:(NSUInteger)index
{
    return [self.viewControllerArray objectAtIndex:index];
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
