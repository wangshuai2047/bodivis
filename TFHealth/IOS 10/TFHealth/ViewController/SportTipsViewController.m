//
//  SportTipsViewController.m
//  TFHealth
//
//  Created by nico on 14-9-8.
//  Copyright (c) 2014年 studio37. All rights reserved.
//

#import "SportTipsViewController.h"
#import "UIViewController+CWPopup.h"
#import "SportSuggestionsViewController.h"

@interface SportTipsViewController ()<UITextViewDelegate>
{
    SportSuggestionsViewController* parent;
}

@property (nonatomic,retain) IBOutlet UITextView* txtTips;

@end

@implementation SportTipsViewController

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
    self.txtTips.delegate=self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setTips:(NSString*)tip
{
    [self.txtTips setText:tip];
}

-(void)setOwener:(SportSuggestionsViewController*)view
{
    parent=view;
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView;
{
    if(parent!=nil)
    {
        [parent dismissPopupViewControllerAnimated:true completion:nil];
    }
    return false;
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
