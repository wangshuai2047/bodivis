//
//  FoodRecordViewController.m
//  TFHealth
//
//  Created by hzth hzth－mac2 on 6/12/14.
//  Copyright (c) 2014 studio37. All rights reserved.
//

#import "FoodRecordViewController.h"
#import "PPiFlatSegmentedControl.h"
#import "SportItem.h"
#import "AppCloundService.h"
#import "AddFoodViewController.h"
#import "DalidFood.h"
#import "FoodDictionary.h"
#import "AppDelegate.h"
#import "UIViewController+CWPopup.h"
#import "TodayMealViewController.h"
#import "NTSlidingViewController.h"
#import "UIViewController+MMDrawerController.h"
#import "FoodClass.h"

@interface FoodRecordViewController ()<PPiFlatSegmentedDelegate,ServiceObjectDelegate,ServiceCallbackDelegate,UITextFieldDelegate,UISearchBarDelegate>{
    int selectItemTag;
    int showItemTag;
    NSMutableArray *usualyFoodArray;
    NSDictionary *addCustomFoodDict;
}
@property (weak, nonatomic) IBOutlet UIScrollView *recordScrollView;
@property (weak, nonatomic) IBOutlet UIScrollView *myScrollView;//选择食品的滚动视图
@property (weak, nonatomic) IBOutlet UIScrollView *usualyScrollView;

@property (weak, nonatomic) IBOutlet UITextField *customNameTextF;
@property (weak, nonatomic) IBOutlet UITextField *customCaloriesTextF;
@property (weak, nonatomic) IBOutlet UITextField *customGramTextF;
@property (weak, nonatomic) IBOutlet UIView *drop_container;

//选择早中晚餐view

@property (weak, nonatomic) IBOutlet UIView *selectItemView;
@property (weak, nonatomic) IBOutlet UILabel *selectResultLabel;
@property (weak, nonatomic) IBOutlet UILabel *allClassTextView;

@property (weak, nonatomic) IBOutlet UIButton *selectResultButton;
@property (weak, nonatomic) IBOutlet UIView *seletItemView_S;
@property (weak, nonatomic) IBOutlet UIView *foodClassDropList;//选择食品类别
@property (weak, nonatomic) IBOutlet UIView *classDropView;
@property (weak, nonatomic) IBOutlet UIScrollView *classScrollView;//食物类别所在滚动视图

//请求食物字典列表数组-刘飞-7.12
@property (strong,nonatomic) NSMutableArray* foodArray;
@property (nonatomic,retain) NSMutableArray *usualyFoodArray;//常用食物

@property (weak, nonatomic) IBOutlet UIView *commonlyUsedView;
@property (weak, nonatomic) IBOutlet UIView *labraryView;
- (IBAction)dropClicked:(id)sender;

@property(nonatomic,strong)UISearchBar *searchBar;

#define Font 13
@end

@implementation FoodRecordViewController
@synthesize superview;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [_customGramTextF resignFirstResponder];
    [_customCaloriesTextF resignFirstResponder];
    [_customNameTextF resignFirstResponder];
    [_searchBar resignFirstResponder];
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
//    dispatch_async(dispatch_get_global_queue(0, 0), ^{
    //  取本地数据库中 FoodDictionary
        [self getUsualyFoodDictionary];
        [self getSystemFoodDictionary];
//    });
    
    
}

- (void)viewDidLoad
{/*
  "foodNutritionalReservoir" = "食品营养库";
  "myDiet" = "我的项目";
  "userDefined" = "自定义";
  */
    [super viewDidLoad];
    self.foodArray = [NSMutableArray arrayWithCapacity:0];
//    PPiFlatSegmentedControl *segmented=[[PPiFlatSegmentedControl alloc] initWithFrame:CGRectMake(10,80, 300, 30) items:@[@{@"text":@"食品营养库",@"icon":@"icon-food"},@{@"text":@"我的项目",@"icon":@"icon-star"},@{@"text":@"自定义",@"icon":@"icon-coffee"}                                                                                                                                         ]iconPosition:IconPositionRight andSelectionBlock:^(NSUInteger segmentIndex) {
//        [self resignAllTextFieldFirstResponder];
//    }];
    
    PPiFlatSegmentedControl *segmented=[[PPiFlatSegmentedControl alloc] initWithFrame:CGRectMake(10,80, 300, 30) items:@[@{@"text":CustomLocalizedString(@"foodNutritionalReservoir", nil),@"icon":@"icon-food"},@{@"text":CustomLocalizedString(@"myDiet", nil),@"icon":@"icon-star"},@{@"text":CustomLocalizedString(@"userDefined", nil),@"icon":@"icon-coffee"}                                                                                                                                         ]iconPosition:IconPositionRight andSelectionBlock:^(NSUInteger segmentIndex) {
        [self resignAllTextFieldFirstResponder];
    }];

    
    segmented.color=[UIColor clearColor];
    segmented.borderWidth=1;
    segmented.borderColor= COLOR(54, 148, 254, 1);
    segmented.selectedColor=COLOR(54, 148, 254, 1);
    segmented.textAttributes=@{NSFontAttributeName:[UIFont systemFontOfSize:13],
                               NSForegroundColorAttributeName:[UIColor whiteColor]};
    segmented.selectedTextAttributes=@{NSFontAttributeName:[UIFont systemFontOfSize:13],
                                       NSForegroundColorAttributeName:[UIColor whiteColor]};
    
    segmented.enabled = YES;
    segmented.userInteractionEnabled  = YES;
    segmented.delegate = self;
    [self.view addSubview:segmented];
    
    showItemTag = 0;
    selectItemTag = 0;
    
    //取本地数据库中 FoodDictionary
    //[self getSystemFoodDictionary];
//    [self getUsualyFoodDictionary];
    
    
    //取系统食品库
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [self downloadFoodClass];
    });
    
    
    [self initUI];
    
    //添加取消键盘的手势
    [self addTapGesture];
    
    //定义搜索框
    self.searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(self.labraryView.frame.size.width - 200, 0, 200, 35)];
    [self.labraryView addSubview:self.searchBar];
    self.searchBar.placeholder = CustomLocalizedString(@"keywordSearch", nil);
    self.searchBar.delegate = self;
    self.searchBar.backgroundColor = [UIColor clearColor];
    
    self.searchBar.searchBarStyle = UISearchBarStyleMinimal;
    
    // ** 自定义searchBar的样式 **
    UITextField* searchField = nil;
    // 注意searchBar的textField处于孙图层中
    for (UIView* subview  in [self.searchBar.subviews firstObject].subviews) {
        NSLog(@"%@", subview.class);
        // 打印出两个结果:
     
//         UISearchBarBackground
//         UISearchBarTextField
     
        
        if ([subview isKindOfClass:[UITextField class]]) {
            
            searchField = (UITextField*)subview;
            // leftView就是放大镜
            // searchField.leftView=nil;
            // 删除searchBar输入框的背景
            [searchField setBackground:nil];
            [searchField setBorderStyle:UITextBorderStyleNone];
//            [searchField setTextColor:[UIColor whiteColor]];
            searchField.backgroundColor = [UIColor whiteColor];
            
            // 设置圆角
            searchField.layer.cornerRadius = 15;
            searchField.layer.masksToBounds = YES;
            
            //设置字体大小
            searchField.font = [UIFont systemFontOfSize:12];
            
            break;
        }
    }
    
    [self setSearchBarCancleButton:self.searchBar];
    [self.searchBar setShowsCancelButton:NO animated:YES];
    
}


- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    
    [self setSearchBarCancleButton:searchBar];
}

-(void)setSearchBarCancleButton:(UISearchBar*)searchBar{
    [self.searchBar setShowsCancelButton:YES animated:YES];
    for (UIView *searchButtons in [self.searchBar subviews]) {
        for (UIView *view in searchButtons.subviews) {
            if ([view isKindOfClass:[NSClassFromString(@"UINavigationButton") class]]) {
                UIButton *btnCancle = (UIButton*)view;
//                btnCancle.frame = CGRectMake(self.searchBar.frame.size.width - 80, 0, 100, 35);
                //修改文本
                [btnCancle setTitle:CustomLocalizedString(@"cancel", nil) forState:UIControlStateNormal];
                [btnCancle.titleLabel setFont:[UIFont systemFontOfSize:16.f]];
                [btnCancle setTitleColor:[UIColor colorWithRed:123.0/255.0 green:223.0/255.0 blue:240.0/255.0 alpha:1] forState:UIControlStateNormal];
                //修改背景
                [btnCancle setBackgroundColor:[UIColor clearColor]];
                
            }
        }
    }
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    [searchBar setShowsCancelButton:NO animated:YES];
    [self updateScrollViewData:self.foodArray AndScrollView:self.myScrollView];
    searchBar.text = nil;
    [searchBar resignFirstResponder];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"foodName CONTAINS %@",self.searchBar.text];
    NSMutableArray *MarrResultFoods=[[self.foodArray filteredArrayUsingPredicate:predicate] mutableCopy];
    [self updateScrollViewData:MarrResultFoods AndScrollView:self.myScrollView];
    
}

-(void)addTapGesture
{
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancelKeyboard:)];
    [self.recordScrollView addGestureRecognizer:singleTap];

}

-(void)cancelKeyboard:(UITapGestureRecognizer*)sender
{
    [self resignAllTextFieldFirstResponder];
}

-(void)resignAllTextFieldFirstResponder
{
    [self.customNameTextF resignFirstResponder];
    [self.customCaloriesTextF resignFirstResponder];
    [self.customGramTextF resignFirstResponder];
    [self.searchBar resignFirstResponder];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
//    CGPoint location = [touch locationInView:self.view];
//    if(CGRectContainsPoint(button.frame, location))
//    {
//        return NO;
//    }
    return YES;
}

-(void)downloadFoodClass
{
    /*
    NSMutableArray* foodClassArray = [NSMutableArray arrayWithArray:[FoodClass MR_findAllInContext:[NSManagedObjectContext MR_defaultContext]]];
    if (foodClassArray.count==0) {
        //本地没有数据，从网络下载，适用于安装软件首次使用些功能
        AppCloundService * foodClassArrayRequest = [[AppCloundService alloc]initWidthDelegate:self];
        AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
        if (appDelegate.languageIndex == 1) {//英语
            [foodClassArrayRequest LanguageGetFoodClass:2];
        } else {
            [foodClassArrayRequest LanguageGetFoodClass:1];
        }
//        [foodClassArrayRequest getFoodClass];
    }
    else
    {
        //通知主线程刷新
        dispatch_async(dispatch_get_main_queue(), ^{
            //回调或者说是通知主线程刷新，
            [self loadFoodClass:foodClassArray];
            [self getSystemFoodDictionary];
        });
        
    }
     */
    AppCloundService * foodClassArrayRequest = [[AppCloundService alloc]initWidthDelegate:self];
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    if (appDelegate.languageIndex == 1) {//英语
        [foodClassArrayRequest LanguageGetFoodClass:2];
    } else {
        [foodClassArrayRequest LanguageGetFoodClass:1];
    }
}

-(void)downloadFoodDict
{
    AppCloundService * foodArrayRequest = [[AppCloundService alloc]initWidthDelegate:self];
//    [foodArrayRequest getFoodDictionary];
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    if (appDelegate.languageIndex == 1) {//英语
        [foodArrayRequest LanguageGetFoodDictionary:2];
    } else {
        [foodArrayRequest LanguageGetFoodDictionary:1];
    }
}

-(void)loadFoodClass:(NSMutableArray *)foodClassArray
{
    if (foodClassArray!=nil) {
        int i=0;
        
        CGRect rect = self.classDropView.frame;
        rect.origin.y=i*36;
        rect.size.height=36;
        
        UIButton *item = [[UIButton alloc]init];
        [item setTitle:CustomLocalizedString(@"AllCategories", nil) forState:UIControlStateNormal];
        item.tag=-1;
        item.frame=rect;
        item.showsTouchWhenHighlighted=YES;
        item.font=[UIFont fontWithName:@"Helvetica" size:16];
        [item addTarget:self action:@selector(ItemSelected:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.classScrollView addSubview:item];
        i++;
        
        self.classScrollView.contentSize = CGSizeMake(self.classDropView.frame.size.width,(foodClassArray.count+2)*36);
        for (FoodClass * dic in foodClassArray) {
            CGRect rect = self.classDropView.frame;
            rect.origin.y=i*36;
            rect.size.height=36;
            UIButton *item = [[UIButton alloc]init];
            [item setTitle:dic.cName forState:UIControlStateNormal];
            item.tag=dic.classId.intValue;
            item.frame=rect;
            item.showsTouchWhenHighlighted=YES;
            item.font=[UIFont fontWithName:@"Helvetica" size:16];
            [item addTarget:self action:@selector(ItemSelected:) forControlEvents:UIControlEventTouchUpInside];

            [self.classScrollView addSubview:item];
            i++;
        }
        rect = self.classDropView.frame;
        rect.origin.y=i*36;
        rect.size.height=36;

        item = [[UIButton alloc]init];
        [item setTitle:CustomLocalizedString(@"custom", nil) forState:UIControlStateNormal];
        item.tag=0;
        item.frame=rect;
        item.showsTouchWhenHighlighted=YES;
        item.font=[UIFont fontWithName:@"Helvetica" size:16];
        [item addTarget:self action:@selector(ItemSelected:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.classScrollView addSubview:item];
    }
}
-(void)ItemSelected:(id)sender{
    UIButton *button = (UIButton * )sender;
    NSArray* dict = nil;
    if(button.tag!=-1)
    {
        dict = [FoodDictionary MR_findAllSortedBy:@"foodName" ascending:YES withPredicate:[NSPredicate predicateWithFormat:@"classId==%d",button.tag] inContext:[NSManagedObjectContext MR_defaultContext]];
    }
    else
    {
        dict = [FoodDictionary MR_findAll];
    }
    NSMutableArray *myMutableArray = [dict mutableCopy];
    [self updateScrollViewData:myMutableArray AndScrollView:self.myScrollView];
    self.classDropView.hidden=YES;
    self.allClassTextView.text=button.titleLabel.text;
}

- (IBAction)dropClicked:(id)sender {
    self.classDropView.hidden=!self.classDropView.hidden;
}

-(void)initUI
{
    UIColor *borderColor = [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:0.2];
    
    _commonlyUsedView.layer.masksToBounds = YES;
    _commonlyUsedView.layer.cornerRadius = 6.0;
    _commonlyUsedView.layer.borderWidth = 1.0;
    _commonlyUsedView.layer.borderColor = [borderColor CGColor];
    _commonlyUsedView.layer.backgroundColor=[borderColor CGColor];
    
    _labraryView.layer.masksToBounds = YES;
    _labraryView.layer.cornerRadius = 6.0;
    _labraryView.layer.borderWidth = 1.0;
    _labraryView.layer.borderColor = [borderColor CGColor];
    _labraryView.layer.backgroundColor=[borderColor CGColor];
    
    _foodClassDropList.layer.masksToBounds = YES;
    _foodClassDropList.layer.cornerRadius = 6.0;
    _foodClassDropList.layer.borderWidth = 1.0;
    _foodClassDropList.layer.borderColor = [borderColor CGColor];
    _foodClassDropList.layer.backgroundColor=[borderColor CGColor];
    
    _classDropView.layer.masksToBounds = YES;
    _classDropView.layer.cornerRadius = 6.0;
    _classDropView.layer.borderWidth = 1.0;
    _classDropView.layer.borderColor = [borderColor CGColor];
    //_classDropView.layer.backgroundColor=[borderColor CGColor];
    
    _drop_container.layer.masksToBounds = YES;
    _drop_container.layer.cornerRadius = 6.0;
    _drop_container.layer.borderWidth = 1.0;
    _drop_container.layer.borderColor = [borderColor CGColor];
    _drop_container.layer.backgroundColor=[borderColor CGColor];
    _drop_container.hidden=true;
    
}

#pragma  mark -- Service Delegate -- 刘飞
-(void)requestSuccessed:(NSString *)request
{
    
}
-(void)requestFailed:(NSString *)request
{
    NSLog(@"food record failure");
}
-(void)serviceSuccessed:(NSDictionary *)keyValues pMethod:(NSString*)method
{
    
    if ([method isEqualToString:@"AddCustomsFoodJson"]){ //添加自定义膳食
        if ([keyValues[@"res"] intValue] != 0 ) {
            
            NSArray *array1 = [FoodDictionary MR_findByAttribute:@"foodName" withValue:_customNameTextF.text inContext:[NSManagedObjectContext MR_defaultContext]];
            if (array1.count > 0) {
                [self showAlertWithMessage:CustomLocalizedString(@"ExistsMealName", nil) cancelButtonTitle:CustomLocalizedString(@"OK", nil)];
            }
            else {
                FoodDictionary *food = [FoodDictionary MR_createEntity];
                [food setFoodName:addCustomFoodDict[@"foodName"]];
                [food setFoodId:[NSNumber numberWithInt:[keyValues[@"res"] intValue]]];
                [food setClassId:[NSNumber numberWithInt:[keyValues[@"classId"] intValue]]];
                [food setCaloriesValue:addCustomFoodDict[@"caloriesValue"]];
                [food setGramValue:addCustomFoodDict[@"gramValue"]];
                [[NSManagedObjectContext MR_defaultContext] MR_save];
                [self showAlertWithMessage:CustomLocalizedString(@"AddMealToNut", nil) cancelButtonTitle:CustomLocalizedString(@"OK",nil)];
                [self changeToAddFoodVC:food];
            }
            NSArray *array = [FoodDictionary MR_findAll];
            NSLog(@"array :%@",array);
        } else {
            [self showAlertWithMessage:CustomLocalizedString(@"AddCustomMealFail", nil) cancelButtonTitle:CustomLocalizedString(@"OK",nil)];
        }
    }
//    else if([method isEqualToString:@"GetFoodClassJson"])
    else if([method isEqualToString:@"LanguageGetFoodClassJson"])
    {
        NSMutableArray* foodClassArray = [NSMutableArray arrayWithArray:[FoodClass MR_findAllInContext:[NSManagedObjectContext MR_defaultContext]]];
        if (foodClassArray.count > 0) {
            for (NSDictionary *dic in keyValues) {
                for (FoodClass *food in foodClassArray) {
                    if (food.classId.intValue == [dic[@"ClassId"]intValue]) {
                        if (dic[@"ClassName"]!=nil&& (NSNull *)dic[@"ClassName"] != [NSNull null]) {
                            [food setCName:dic[@"ClassName"]];
                        }
                        if (dic[@"ClassDesc"]!=nil&& (NSNull *)dic[@"ClassDesc"] != [NSNull null]) {
                            [food setClassDesc:dic[@"ClassDesc"]];
                        }
                        [[NSManagedObjectContext MR_defaultContext] MR_save];
                    }
                }
            }
        } else {
            for (NSDictionary * dic in keyValues) {
                FoodClass *fClass = [FoodClass MR_createEntity];
                [fClass setClassId:[NSNumber numberWithInt:[dic[@"ClassId"]intValue]]];
                if (dic[@"ClassName"]!=nil&& (NSNull *)dic[@"ClassName"] != [NSNull null]) {
                    [fClass setCName:dic[@"ClassName"]];
                }
                if (dic[@"ClassDesc"]!=nil&& (NSNull *)dic[@"ClassDesc"] != [NSNull null]) {
                    [fClass setClassDesc:dic[@"ClassDesc"]];
                }
                [[NSManagedObjectContext MR_defaultContext] MR_save];
            }
            foodClassArray = [NSMutableArray arrayWithArray:[FoodClass MR_findAllInContext:[NSManagedObjectContext MR_defaultContext]]];
        }
        
        [self loadFoodClass:foodClassArray];
        [self downloadFoodDict];
    }
//    else if ([method isEqualToString:@"GetFoodDictionaryJson"])
    else if ([method isEqualToString:@"LanguageGetFoodDictionaryJson"])
    { //返回系统膳食
        /*
         if (_foodArray.count > 0) {
         [_foodArray removeAllObjects];
         }
         */
        
        for (NSDictionary * dic in keyValues) {
            
             NSArray *array = [FoodDictionary MR_findByAttribute:@"foodId" withValue:dic[@"FoodID"]  inContext:[NSManagedObjectContext MR_defaultContext]];
             if (array.count > 0) {
                 FoodDictionary *fDictionary = array[0];
                 [fDictionary setClassId:[NSNumber numberWithInt:[dic[@"ClassId"]intValue]]];
                 if (dic[@"FoodName"]!=nil&& (NSNull *)dic[@"FoodName"] != [NSNull null]) {
                     [fDictionary setFoodName:dic[@"FoodName"]];
                 }
//                 [fDictionary setFoodId:[NSNumber numberWithInt:[dic[@"FoodID"]intValue]]];
                 [fDictionary setGramValue:[NSNumber numberWithInt:[dic[@"GramValue"] intValue]]];
                 [fDictionary setCaloriesValue:[NSNumber numberWithInt:[dic[@"CaloriesValue"]intValue]]];
                 [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
             } else {
                FoodDictionary *fDictionary = [FoodDictionary MR_createEntity];
                [fDictionary setClassId:[NSNumber numberWithInt:[dic[@"ClassId"]intValue]]];
                 if (dic[@"FoodName"]!=nil&& (NSNull *)dic[@"FoodName"] != [NSNull null]) {
                     [fDictionary setFoodName:dic[@"FoodName"]];
                 }
                [fDictionary setFoodId:[NSNumber numberWithInt:[dic[@"FoodID"]intValue]]];
                [fDictionary setGramValue:[NSNumber numberWithInt:[dic[@"GramValue"] intValue]]];
                [fDictionary setCaloriesValue:[NSNumber numberWithInt:[dic[@"CaloriesValue"]intValue]]];
                [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
            }
        }
        [self getSystemFoodDictionary];
    }
    //
}

-(void)getSystemFoodClass
{
}

-(void)getSystemFoodDictionary {
    
//    _foodArray = [NSMutableArray arrayWithArray:[FoodDictionary MR_findAllInContext:[NSManagedObjectContext MR_defaultContext]]];
    
    NSArray *arrAllFoodDict = [NSMutableArray arrayWithArray:[FoodDictionary MR_findAllInContext:[NSManagedObjectContext MR_defaultContext]]];
    _foodArray = (NSMutableArray*)[arrAllFoodDict sortedArrayUsingComparator:^NSComparisonResult(FoodDictionary *obj1, FoodDictionary *obj2){
        return [obj1.foodId compare:obj2.foodId];
    }];
    
    [self updateScrollViewData:_foodArray AndScrollView:self.myScrollView];
}
#pragma mark - 获取常用食物
-(void)getUsualyFoodDictionary {
    /*
    _usualyFoodArray = [[NSMutableArray alloc] initWithCapacity:0];
    NSArray *array = [DalidFood MR_findAllInContext:[NSManagedObjectContext MR_defaultContext]];
    for (int i = 0; i < MIN(12,array.count);  i ++) {
        BOOL hasIt = NO;
        DalidFood *daliF = [array objectAtIndex:i];
        if (daliF!=nil&&daliF.foodName!=nil) {
            FoodDictionary *dict = [[FoodDictionary MR_findByAttribute:@"foodName" withValue:daliF.foodName  inContext:[NSManagedObjectContext MR_defaultContext]] firstObject];
            if (dict!=nil) {
                for (FoodDictionary *d in _usualyFoodArray) {
                    if ([d.foodName isEqualToString:dict.foodName]) {
                        hasIt = YES;
                    }
                }
                if (!hasIt) {
                    [_usualyFoodArray addObject:dict];
                }
            }
        }
    }
    */
    _usualyFoodArray = [[NSMutableArray alloc] initWithCapacity:0];
    NSArray *array = [DalidFood MR_findAllInContext:[NSManagedObjectContext MR_defaultContext]];
    for (int i = 0; i < MIN(12,array.count);  i ++) {
        BOOL hasIt = NO;
        DalidFood *daliF = [array objectAtIndex:i];
        if (daliF!=nil&&daliF.foodId!=nil) {
            FoodDictionary *dict = [[FoodDictionary MR_findByAttribute:@"foodId" withValue:daliF.foodId  inContext:[NSManagedObjectContext MR_defaultContext]] firstObject];
            if (dict!=nil) {
                for (FoodDictionary *d in _usualyFoodArray) {
                    if (d.foodId.integerValue == dict.foodId.integerValue) {
                        hasIt = YES;
                    }
                }
                if (!hasIt) {
                    [_usualyFoodArray addObject:dict];
                }
            }
        }
    }
    [self updateScrollViewData:_usualyFoodArray AndScrollView:self.usualyScrollView];
}
-(void)serviceFailed:(NSString *)message pMethod:(NSString*)method
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:CustomLocalizedString(@"tip", nil) message:CustomLocalizedString(@"AdFoodFaiInt", nil) delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alertView show];
    NSLog(@"food record request failure");
}

#pragma mark -- self methods
/*
 添加自定义膳食
 */
- (IBAction)saveButtonClick:(id)sender {
    if ([_customNameTextF.text length] < 1 || [_customNameTextF.text isEqual:[NSNull null]]) {
        [self showAlertWithMessage:CustomLocalizedString(@"FillFoodName", nil) cancelButtonTitle:CustomLocalizedString(@"OK", nil)];
        return ;
    }
    if (![self isValueFloadValue:_customCaloriesTextF.text]) {
        [self showAlertWithMessage:CustomLocalizedString(@"CalFormatWrong", nil) cancelButtonTitle:CustomLocalizedString(@"OK", nil)];
        return ;
    }
    if (![self isValueFloadValue:_customGramTextF.text]) {
        [self showAlertWithMessage:CustomLocalizedString(@"CalFormatWrong", nil) cancelButtonTitle:CustomLocalizedString(@"OK", nil)];
        return;
    }
    
    AppDelegate *appdelegate =(AppDelegate*) [[UIApplication sharedApplication] delegate];
    
    User* user = appdelegate.user;
    NSLog(@"userid :%d , foodName :%@ ,cal:%@ , gram :%@",[user.userId intValue],_customNameTextF.text,_customCaloriesTextF.text,_customGramTextF.text);
    addCustomFoodDict = @{@"foodName": _customNameTextF.text,
                          @"caloriesValue":[NSNumber numberWithFloat:[_customCaloriesTextF.text floatValue]],
                          @"gramValue":[NSNumber numberWithFloat:[_customGramTextF.text floatValue]],
                          };
    AppCloundService * addCustomsFood = [[AppCloundService alloc]initWidthDelegate:self];
    [addCustomsFood addCustomsFoodWithUserId:[user.userId intValue] classId:3 foodName:_customNameTextF.text caloriesValue:[_customCaloriesTextF.text floatValue] gramValue:[_customGramTextF.text floatValue] isCustoms:1];
    
}


/*
 选择早中晚餐 刘飞 --
 */
- (IBAction)selectetItem:(id)sender {
    UIButton *button = (UIButton * )sender;
    
    //    CGPoint p = self.recordScrollView.contentOffset;
    //    if (p.x < 100) {
    //        switch (button.tag - 600) {
    //            case 0:
    //                [_selectResultButton setTitle:@"早餐" forState:UIControlStateNormal];
    //                break;
    //            case 1:
    //                [_selectResultButton setTitle:@"中餐" forState:UIControlStateNormal];
    //                break;
    //            case 2:
    //                [_selectResultButton setTitle:@"晚餐" forState:UIControlStateNormal];
    //                break;
    //            default:
    //                break;
    //        }
    //        showItemTag = button.tag - 600;
    //        _seletItemView_S.hidden = YES;
    //    } else {
    switch (button.tag - 600) {
        case 0:
            _selectResultLabel.text = @"早餐";
            break;
        case 1:
            _selectResultLabel.text = @"午餐";
            break;
        case 2:
            _selectResultLabel.text = @"晚餐";
            break;
        default:
            break;
    }
    selectItemTag = button.tag - 600;
    _selectItemView.hidden = YES;
    //    }
    
    
    
}
- (IBAction)showSelectItem:(id)sender {
    _selectItemView.hidden = NO;
}
- (IBAction)showSelectItem_S:(id)sender {
    _seletItemView_S.hidden = NO;
}

- (IBAction)backButtonClick:(id)sender {
    TodayMealViewController *uv = (TodayMealViewController *)superview;
    [uv dismissPopup];
    /*
     TodayMealViewController *modal = [self.storyboard instantiateViewControllerWithIdentifier:@"TodayMealViewController"];
     NTSlidingViewController *uv = (NTSlidingViewController *)superview;
     UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:uv];
     [self presentViewController:nav animated:YES completion:^{
     
     }];
     */
    //[self.navigationController popToRootViewControllerAnimated:YES];
}

-(void)updateScrollViewData:(NSMutableArray*)dataArray AndScrollView:(UIScrollView*)scrollView
{
    for (UIView * subview in scrollView.subviews) {
        [subview removeFromSuperview];
    }
    float width = scrollView.frame.size.width/3;
    float height = 25;
    scrollView.contentSize = CGSizeMake(width*3,height*((dataArray.count+3)/2));
    for (int i = 0; i<(dataArray.count+1)/2; i++) {
        for (int j = 0 ; j<2;j++ )
        {
            if ((j+1)+i*2>dataArray.count) {
                break;
            }
            FoodDictionary *fDictionary = [dataArray objectAtIndex:i*2+j];
            //            NSString * item = [dataArray objectAtIndex:i*2+j];
            UILabel * sportNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(140*j+10, 25*i+10, 140, 20)];
            sportNameLabel.textColor = UIColorFromRGB(0x9be2ff);
            sportNameLabel.text = fDictionary.foodName;
            sportNameLabel.font = [UIFont systemFontOfSize:Font];
            sportNameLabel.textAlignment = NSTextAlignmentLeft;
            sportNameLabel.tag = fDictionary.foodId.intValue;
            //点击事件
            sportNameLabel.userInteractionEnabled = YES;
            UITapGestureRecognizer *singleTap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(AddFoodLabelClick:)];
            [sportNameLabel addGestureRecognizer:singleTap1];
            [scrollView addSubview:sportNameLabel];
        }
    }
}
#pragma mark - 添加食品
-(void)AddFoodLabelClick:(UITapGestureRecognizer*)tap
{
    [self resignAllTextFieldFirstResponder];
    UILabel * label = (UILabel*)[tap view];
    FoodDictionary * fDictionary = [FoodDictionary MR_findFirstWithPredicate:[NSPredicate predicateWithFormat:@"foodId==%d",label.tag]];
    
    //    if ([label.superview isEqual:_myScrollView]) {
    //        if (self.foodArray.count > label.tag) {
    //            fDictionary = [self.foodArray objectAtIndex:label.tag];
    //        }
    //    }else if ([label.superview isEqual:_usualyScrollView]) {
    //        if (usualyFoodArray.count > label.tag) {
    //            fDictionary = [usualyFoodArray objectAtIndex:label.tag];
    //        }
    //    }
    if(fDictionary!=nil)
    {
        [self changeToAddFoodVC:fDictionary];
    }
}
-(void)changeToAddFoodVC:(FoodDictionary *)foodDict {
    
    AddFoodViewController * afvc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"AddFoodViewController"];
    NTSlidingViewController *uv = (NTSlidingViewController *)superview;
    [uv setIndexText:1 txt:CustomLocalizedString(@"AddDietary", nil)];
    [afvc setFoodDictionary:foodDict];
    afvc.isUpdate = 0;
    [self presentPopupViewController:afvc animated:true completion:nil];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.recordScrollView.contentSize = CGSizeMake(320*2, 439);
    
}

//
-(void)PPiFlatSegmentedSelectedSegAtIndex:(int)index
{
    selectItemTag = 0;
    _selectResultLabel.text = @"早餐";
    //    [_selectResultButton setTitle:@"早餐" forState:UIControlStateNormal];
    [self.recordScrollView setContentOffset:CGPointMake(index*320, 0)];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)showAlertWithMessage:(NSString *)message cancelButtonTitle:(NSString *)cancel {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:CustomLocalizedString(@"tip", nil) message:message delegate:nil cancelButtonTitle:cancel otherButtonTitles:nil, nil];
    [alert show];
}

-(BOOL)isValueFloadValue:(NSString *)str {
    NSString *floatRegex = @"^(([0-9]+\.[0-9]*[1-9][0-9]*)|([0-9]*[1-9][0-9]*\.[0-9]+)|([0-9]*[1-9][0-9]*))$";
    NSPredicate *floatPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",floatRegex];
    return [floatPredicate evaluateWithObject:str];
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
