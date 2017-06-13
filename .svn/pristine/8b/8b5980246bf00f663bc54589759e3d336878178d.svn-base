//
//  NTSlidingViewController.m
//  NTSlidingViewController
//
//  Created by nonstriater on 14-2-24.
//  Copyright (c) 2014年 xiaoran. All rights reserved.
//

#import "NTSlidingViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "UIViewController+MMDrawerController.h"
#import "TodayMealViewController.h"
#import "UIViewController+CWPopup.h"
#import "AddFoodViewController.h"
#import "AppDelegate.h"

static const CGFloat kMaximumNumberChildControllers = 6;
static const CGFloat kNavbarButtonScaleFactor = 1.4f;


@interface UIColor (components)

- (CGFloat)red;
- (CGFloat)green;
- (CGFloat)blue;

@end

@implementation UIColor (components)

- (CGFloat)red{
    return CGColorGetComponents(self.CGColor)[0];
}
- (CGFloat)green{
    return CGColorGetComponents(self.CGColor)[1];
}
- (CGFloat)blue{
    return CGColorGetComponents(self.CGColor)[1];
}


@end


@interface NTSlidingViewController ()<UIScrollViewDelegate>{
    
    UIScrollView *_scrollView;
}

@end

@implementation NTSlidingViewController

@synthesize superview;

#pragma mark- contrller lifecircle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (instancetype)init{
    if (self=[super init]) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initSlidingViewControllerWithTitle:(NSString *)title viewController:(UIViewController *)controller{
    
    self = [self init];
    if (self) {
        
        [self.titles addObject:title];
        [self.childControllers addObject:controller];
    }
    return  self;
}
- (instancetype)initSlidingViewControllerWithTitlesAndControllers:(NSDictionary *)titlesAndControllers{
    
    if (self = [self init]) {
        
        [titlesAndControllers enumerateKeysAndObjectsUsingBlock:^(id key,id obj,BOOL *stop){
            if ([key isKindOfClass:[NSString class]] && [obj isKindOfClass:[UIViewController class]]) {
                
                [self.titles addObject:key];
                [self.childControllers addObject:obj];
            }
        }];
        
    }
    return self;
}


- (void)addControllerWithTitle:(NSString *)title viewController:(UIViewController *)controller{
    
    [self.titles addObject:title];
    [self.childControllers addObject:controller];
    
}

+ (instancetype)slidingViewControllerWithTitlesAndControllers:(NSDictionary *)titlesAndControllers{
    
    return [[self alloc] initSlidingViewControllerWithTitlesAndControllers:titlesAndControllers];
    
}

- (void)commonInit{
    
    _titles = [[NSMutableArray alloc] init];
    _childControllers = [[NSMutableArray alloc] init];
    
    _unselectedLabelColor = [UIColor grayColor];
    _selectedLabelColor = [UIColor whiteColor];
    _selectedIndex = 1;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - config

-(UIInterfaceOrientation)interfaceOrientation{
    return UIInterfaceOrientationPortrait;
}

#pragma mark - view lifecircle
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor clearColor]];
    
    [self.navigationBar addSubview:self.navigationBarView];
    
    [self.view addSubview:[self contentScrollView]];
    
    [self.view bringSubviewToFront: self.navigationBar ];
}

-(void)btnBackAction:(id)sender{
    UIButton *origin = (UIButton *)[_navigationBarView viewWithTag:self.selectedIndex];
    if ([origin.titleLabel.text isEqualToString:CustomLocalizedString(@"ChooseMeal", nil)]
        ||[origin.titleLabel.text isEqualToString:CustomLocalizedString(@"AddDietary", nil)]||[origin.titleLabel.text isEqualToString:CustomLocalizedString(@"ModifyDietary", nil)]) {
        [self setIndexText:1 txt:CustomLocalizedString(@"TodayMeal", nil)];
        //ssvc.superview=self;
        TodayMealViewController *uv = (TodayMealViewController *)superview;
        [uv dismissPopup];
    }
    else
    {
        [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
    }
}

-(void)btnAccountAction:(id)sender{
    
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideRight animated:YES completion:nil];
}

// 动态适配
// 最多 6 个
//
-(UIView *)navigationBarView{
    
    if (!_navigationBarView) {
        _navigationBarView = [[UIView alloc] initWithFrame:self.navigationBar.bounds];
        
        UIImage *images = [UIImage imageNamed:@"back_btn"];
        UIButton *btnback = [UIButton buttonWithType:UIButtonTypeCustom];
        [btnback setFrame:CGRectMake(16, 7, images.size.width, images.size.height)];
        [btnback setBackgroundImage:[UIImage imageNamed:@"back_btn"] forState:UIControlStateNormal];
        [btnback setTitleColor:self.unselectedLabelColor forState:UIControlStateNormal];
        [btnback setTitleColor:self.selectedLabelColor forState:UIControlStateSelected];
        [btnback addTarget:self action:@selector(btnBackAction:) forControlEvents:UIControlEventTouchUpInside];
        btnback.tag=10;
        [_navigationBarView addSubview: btnback];
        
        CGFloat barViewWidth = self.view.frame.size.width;
        CGFloat itemWidth = barViewWidth/kMaximumNumberChildControllers ;
        NSUInteger itemCount = [self.titles count];
        CGFloat itemMargin = (barViewWidth - itemCount*itemWidth)/(itemCount+1);
        for (int i=0; i<itemCount; i++) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setFrame:CGRectMake(i*itemWidth+(i+1)*itemMargin+10, 0, itemWidth+38, 44)];
            [button setTitleColor:self.unselectedLabelColor forState:UIControlStateNormal];
            [button setTitleColor:self.selectedLabelColor forState:UIControlStateSelected];
            [button.titleLabel setFont:[UIFont systemFontOfSize:13]];
            [button.titleLabel setTextAlignment:NSTextAlignmentCenter];
            [button setTitle:self.titles[i] forState:UIControlStateNormal];
            button.tag = i+1;
            [button addTarget:self action:@selector(navigationBarButtonItemClicked:) forControlEvents:UIControlEventTouchUpInside];
            [_navigationBarView addSubview:button];
            
            if (i==0) {
                [button setTitleColor:self.selectedLabelColor forState:UIControlStateNormal];
                button.transform = CGAffineTransformIdentity;
                button.transform = CGAffineTransformMakeScale(kNavbarButtonScaleFactor, kNavbarButtonScaleFactor);
            }
            
        }

        UIImage *account = [UIImage imageNamed:@"myAccount_icon"];
        UIButton *btnAccount = [UIButton buttonWithType:UIButtonTypeCustom];
        [btnAccount setFrame:CGRectMake(barViewWidth-42, 7, account.size.width, account.size.height)];
        [btnAccount setBackgroundImage:[UIImage imageNamed:@"myAccount_icon"] forState:UIControlStateNormal];
        [btnAccount setTitleColor:self.unselectedLabelColor forState:UIControlStateNormal];
        [btnAccount setTitleColor:self.selectedLabelColor forState:UIControlStateSelected];
        [btnAccount addTarget:self action:@selector(btnAccountAction:) forControlEvents:UIControlEventTouchUpInside];
        btnAccount.hidden=YES;
        btnAccount.tag=20;
        [_navigationBarView addSubview: btnAccount];
    }
    AppDelegate *appdelegate =(AppDelegate*) [[UIApplication sharedApplication] delegate];
    if (appdelegate.deviceType==0) {
        [self setHiddenItem];
    }
    //UIButton *origin = (UIButton *)[_navigationBarView viewWithTag:1];
    //if ([origin.titleLabel.text isEqualToString:@"运动"]) {
    
    //}
    
    return _navigationBarView;
}

-(void)setHiddenItem
{
    UIButton *back = (UIButton *)[_navigationBarView viewWithTag:10];
    [back setHidden:YES];
    UIButton *account = (UIButton *)[_navigationBarView viewWithTag:20];
    [account setHidden:NO];
}

- (UIScrollView *)contentScrollView{
    
    if (!_scrollView) {
        
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0,self.view.frame.size.width  , self.view.frame.size.height )];
        _scrollView.backgroundColor = [UIColor whiteColor];
        _scrollView.pagingEnabled = YES;
        _scrollView.alwaysBounceHorizontal = YES;
        _scrollView.contentSize = CGSizeMake(_scrollView.frame.size.width*[self.titles count], _scrollView.frame.size.height);
        _scrollView.delegate = self;
        
        for (int i=0; i<[self.childControllers count]; i++) {
            id obj = [self.childControllers objectAtIndex:i];
            if ([obj isKindOfClass:[UIViewController class]]) {
                UIViewController *controller = (UIViewController *)obj;
                //[self addChildViewController:controller];
                CGFloat scrollWidth = _scrollView.frame.size.width;
                CGFloat scrollHeight = _scrollView.frame.size.height;
                [controller.view setFrame:CGRectMake(i*scrollWidth, 0, scrollWidth, scrollHeight)];
                [_scrollView addSubview:controller.view];
            }
            
        }
        
    }
    return _scrollView;
}


- (void)navigationBarButtonItemClicked:(UIButton *)button{
    self.selectedIndex = button.tag;
}

- (void)setSelectedIndex:(NSUInteger)index{
    
    if (index != self.selectedIndex) {
        UIButton *origin = (UIButton *)[_navigationBarView viewWithTag:self.selectedIndex];
        if ([origin isKindOfClass:[UIButton class]]) {
            //origin.transform = CGAffineTransformIdentity;
            origin.transform = CGAffineTransformMakeScale(1.f, 1.f);
            [origin setTitleColor:self.unselectedLabelColor forState:UIControlStateNormal];
        }
        
        UIButton *button = (UIButton *)[_navigationBarView viewWithTag:index];
        [button setTitleColor:self.selectedLabelColor forState:UIControlStateNormal];
        button.transform = CGAffineTransformMakeScale(kNavbarButtonScaleFactor, kNavbarButtonScaleFactor);
        
        _selectedIndex = index;
        [self transitionToViewControllerAtIndex:index-1];
    }
}

- (void)setIndexText:(NSUInteger)index txt:(NSString*)title{
    
    UIButton *button = (UIButton *)[_navigationBarView viewWithTag:index];
    [button setTitle:title forState:UIControlStateNormal];
}

-(NSString*)getIndexText:(NSUInteger)index
{
    UIButton *button = (UIButton *)[_navigationBarView viewWithTag:index];
    return button.titleLabel.text;
}


#pragma mark - delegages

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    if (0==fmod(scrollView.contentOffset.x,scrollView.frame.size.width)){
        _selectedIndex =  scrollView.contentOffset.x/scrollView.frame.size.width+1;
    }
    
    
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if (decelerate) {
        _selectedIndex =  scrollView.contentOffset.x/scrollView.frame.size.width+1;
    }
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    // 左 or 右
    UIButton *relativeButton = nil;
    UIButton *currentButton = (UIButton *)[_navigationBarView viewWithTag:_selectedIndex];
    CGFloat offset = scrollView.contentOffset.x-(_selectedIndex-1)*scrollView.frame.size.width;
    
    if(offset>0 && _selectedIndex<[self.titles count]){//右
        relativeButton = (UIButton *)[_navigationBarView viewWithTag:_selectedIndex+1];
    }else if(offset<0 && _selectedIndex>1){
        relativeButton = (UIButton *)[_navigationBarView viewWithTag:_selectedIndex-1];
    }
    
    offset = fabsf(offset);
    if (relativeButton) {
        
        CGFloat scrollViewWidth = scrollView.frame.size.width;
        CGFloat currentScaleFactor = (kNavbarButtonScaleFactor)-(kNavbarButtonScaleFactor-1)*fabsf(offset)/scrollViewWidth;
        CGFloat relativeScaleFactor = (kNavbarButtonScaleFactor-1)*fabsf(offset)/scrollViewWidth+1.f;
        
        UIColor *currentColor = [UIColor colorWithRed:((self.unselectedLabelColor.red-self.selectedLabelColor.red)*offset/scrollViewWidth+self.selectedLabelColor.red)
                                                green:((self.unselectedLabelColor.green-self.selectedLabelColor.green)*offset/scrollViewWidth+self.selectedLabelColor.green)
                                                 blue:((self.unselectedLabelColor.blue-self.selectedLabelColor.blue)*offset/scrollViewWidth+self.selectedLabelColor.blue)
                                                alpha:1];
        
        UIColor *relativeColor = [UIColor colorWithRed:((self.selectedLabelColor.red-self.unselectedLabelColor.red)*offset/scrollViewWidth+self.unselectedLabelColor.red)
                                                 green:((self.selectedLabelColor.green-self.unselectedLabelColor.green)*offset/scrollViewWidth+self.unselectedLabelColor.green)
                                                  blue:((self.selectedLabelColor.blue-self.unselectedLabelColor.blue)*offset/scrollViewWidth+self.unselectedLabelColor.blue)
                                                 alpha:1];
        
        currentButton.transform = CGAffineTransformMakeScale(currentScaleFactor,currentScaleFactor );
        [currentButton setTitleColor:currentColor forState:UIControlStateNormal];
        
        relativeButton.transform = CGAffineTransformMakeScale(relativeScaleFactor,relativeScaleFactor );
        [relativeButton setTitleColor:relativeColor forState:UIControlStateNormal];
    }
    if (relativeButton) {
        //在这里更新？
        int i=0;
    }
}


#pragma mark - public


- (void)transitionToViewControllerAtIndex:(NSUInteger)index{
    
    [_scrollView setContentOffset:CGPointMake(index*_scrollView.frame.size.width, 0)];
    
}
- (void)transitionToViewController:(UIViewController *)controller{
    
    [self transitionToViewControllerAtIndex:[self.childControllers indexOfObject:controller]];
}

- (void)transitionToViewController:(UIViewController *)controller complteBlock:(NTTransitionCompleteBlock)block{
    
}



@end
