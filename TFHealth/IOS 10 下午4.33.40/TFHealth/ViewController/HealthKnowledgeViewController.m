//
//  HealthKnowledgeViewController.m
//  TFHealth
//
//  Created by chenzq on 14-8-13.
//  Copyright (c) 2014年 studio37. All rights reserved.
//

#import "HealthKnowledgeViewController.h"

@interface HealthKnowledgeViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *text_view_container;
@end

@implementation HealthKnowledgeViewController

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
