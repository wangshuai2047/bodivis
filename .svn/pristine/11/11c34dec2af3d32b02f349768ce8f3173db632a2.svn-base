//
//  FindPassowrdViewController.m
//  TFHealth
//
//  Created by chenzq on 14-7-1.
//  Copyright (c) 2014年 studio37. All rights reserved.
//

#import "FindPassowrdViewController.h"
#import "AppDelegate.h"

@interface FindPassowrdViewController ()<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UITextField *txtUserEamil;
- (IBAction)backUpView:(id)sender;
@property (weak, nonatomic) IBOutlet UIWebView *webview;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@end

@implementation FindPassowrdViewController

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
    
//    NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://i.bodivis.com.cn/share/forgot.aspx"]];
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    int language = 1;
    if (appDelegate.languageIndex == 1) {//英文
        language = 2;
    } else {
        language = 1;
    }
    NSString *strUrl = [NSString stringWithFormat:@"%@%d",@"http://i.bodivis.com.cn/share/forgot.aspx?language=",language];
    NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:strUrl]];
    [_webview loadRequest:request];
    [_webview setScalesPageToFit:YES];
    [_webview setDelegate:self];
    
}

-(void) webViewDidStartLoad:(UIWebView *)webView
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, _webview.frame.origin.y, 320, _webview.frame.size.height)];
    [view setTag:108];
    [view setBackgroundColor:[UIColor blackColor]];
    [view setAlpha:0.5];
    [self.view addSubview:view];
    
     _activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 32.0f, 32.0f)];
    [_activityIndicator setCenter:view.center];
    [_activityIndicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhite];
    [view addSubview:_activityIndicator];
    
    [_activityIndicator startAnimating];
}
- (void) webViewDidFinishLoad:(UIWebView *)webView
{
    [_activityIndicator stopAnimating];
    UIView *view = (UIView*)[self.view viewWithTag:108];
    [view removeFromSuperview];
}
- (void) webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [_activityIndicator stopAnimating];
    UIView *view = (UIView*)[self.view viewWithTag:108];
    [view removeFromSuperview];
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

- (IBAction)backUpView:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
