//
//  SportsEventsViewController.m
//  TFHealth
//
//  Created by hzth hzth－mac2 on 5/29/14.
//  Copyright (c) 2014 studio37. All rights reserved.
//

#import "SportsEventsViewController.h"
#import "PPiFlatSegmentedControl.h"
#import "NSString+FontAwesome.h"
#import "SportItem.h"
#import "SportsRecordsViewController.h"
#import "AddSportViewController.h"
#import "SportPaternersViewController.h"
#import "AppCloundService.h"
#import "Sport_Item_Value.h"
#import "Sport_Items.h"
#import "AppDelegate.h"
@interface SportsEventsViewController ()<PPiFlatSegmentedDelegate,ServiceObjectDelegate,UITextFieldDelegate> {
    NSDictionary *customItemDict;
}
@property (weak, nonatomic) IBOutlet UIScrollView *TFscrollView;
@property (weak, nonatomic) IBOutlet UIButton *checkButton;
@property (weak, nonatomic) IBOutlet UIScrollView *usedScrollView;
@property (weak, nonatomic) IBOutlet UIScrollView *storedScrollView;


@property (weak, nonatomic) IBOutlet UITextField *nameTextView;
@property (weak, nonatomic) IBOutlet UITextField *carlisetextField;
@property (weak, nonatomic) IBOutlet UITextField *unitTimeTextField;
@property (weak, nonatomic) IBOutlet UITextField *unitNameTextField;


@property (nonatomic,retain) NSMutableArray *usualySportArray;
@property (nonatomic,retain) NSMutableArray *systemSportArray;
@property (weak, nonatomic) IBOutlet UIView *myitems_container;

@property (weak, nonatomic) IBOutlet UIView *items_container;

#define Font 12
@end

@implementation SportsEventsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [_nameTextView resignFirstResponder];
    [_unitNameTextField resignFirstResponder];
    [_unitTimeTextField resignFirstResponder];
    [_carlisetextField resignFirstResponder];
}

-(void)viewWillAppear:(BOOL)animated {
    [self getMySportArrayFromLocal];
    [self getSystemSportArrayFromLocal];
}

- (IBAction)checkButton:(id)sender {
    UIButton * button = (UIButton *)sender;
    self.checkButton.selected = !self.checkButton.selected;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    PPiFlatSegmentedControl *segmented=[[PPiFlatSegmentedControl alloc] initWithFrame:CGRectMake(10, 80, 300, 30) items:@[               @{@"text":@"运动项目",@"icon":@""},@{@"text":@"自定义",@"icon":@""}]iconPosition:IconPositionRight andSelectionBlock:^(NSUInteger segmentIndex) {}];
    segmented.color=[UIColor clearColor];
    segmented.borderWidth=0.5;
    segmented.borderColor= COLOR(54, 148, 254, 1);
    segmented.selectedColor=COLOR(54, 148, 254, 1);;
    segmented.textAttributes=@{NSFontAttributeName:[UIFont systemFontOfSize:13],
                               NSForegroundColorAttributeName:[UIColor whiteColor]};
    segmented.selectedTextAttributes=@{NSFontAttributeName:[UIFont systemFontOfSize:13],
                                       NSForegroundColorAttributeName:[UIColor whiteColor]};
    
    //segmented.enabled = YES;
    segmented.userInteractionEnabled  = YES;
    //[segmented addTarget:self action:@selector(segmentClick:) forControlEvents:UIControlEventValueChanged];
    segmented.delegate =self;
    [self.view addSubview:segmented];
    
    [self getSystemSportArrayFromLocal];
    [self getMySportArrayFromLocal];
    [self initUI];
    
    AppCloundService *service = [[AppCloundService alloc]initWidthDelegate:self];
    [service getSportItems];
}

-(void)initUI
{
    UIColor *borderColor = [UIColor colorWithRed:255.0 green:255.0 blue:255.0 alpha:0.2];
    _items_container.layer.masksToBounds = YES;
    _items_container.layer.cornerRadius = 6.0;
    _items_container.layer.borderWidth = 1.0;
    _items_container.layer.borderColor = [borderColor CGColor];
    _items_container.layer.backgroundColor=[borderColor CGColor];
    
    _myitems_container.layer.masksToBounds = YES;
    _myitems_container.layer.cornerRadius = 6.0;
    _myitems_container.layer.borderWidth = 1.0;
    _myitems_container.layer.borderColor = [borderColor CGColor];
    _myitems_container.layer.backgroundColor=[borderColor CGColor];
}

#pragma mark -- service delegate 
-(void)serviceFailed:(NSString *)message pMethod:(NSString *)method {
    
}
-(void)serviceSuccessed:(NSDictionary *)keyValues pMethod:(NSString *)method {
    if (_systemSportArray.count > 0) {
        [_systemSportArray removeAllObjects];
    }
    if ([method isEqualToString:@"GetSportItemsJson"]) {
        
//        @property (nonatomic, retain) NSNumber * caloriesValue;
//        @property (nonatomic, retain) NSNumber * sportId;
//        @property (nonatomic, retain) NSString * sportName;
//        @property (nonatomic, retain) NSNumber * timeSpan;
//        @property (nonatomic, retain) NSString * unit;
        for (NSDictionary *dict in keyValues) {
            NSArray *array = [Sport_Items MR_findByAttribute:@"sportId" withValue:[NSNumber numberWithInt:[dict[@"SportID"] intValue]] inContext:[NSManagedObjectContext MR_defaultContext]];
            if (array.count > 0) {
                NSLog(@"项目 ：%@ 已存在",dict[@"SportID"]);
            } else {
                Sport_Items *items = [Sport_Items MR_createEntity];
                
                items.caloriesValue = [NSNumber numberWithFloat:[dict[@"CaloriesValue"] floatValue]];
                items.sportId = [NSNumber numberWithInt:[dict[@"SportID"] intValue]];
                items.sportName = [NSString stringWithFormat:@"%@",dict[@"SportName"]];
                items.timeSpan = [NSNumber numberWithInt:[dict[@"TimeSpan"]intValue]];
                items.unit = [NSString stringWithFormat:@"%@",dict[@"Uint"]];
                [[NSManagedObjectContext MR_defaultContext] MR_save];
            }
            
        }
        
        
    } else if ([method isEqualToString:@"AddCustomsSportItemJson"]) {
        if ([keyValues[@"res"] intValue] > 0 ) {
            Sport_Items *items = [Sport_Items MR_createEntity];
            items.sportId =[NSNumber numberWithInt:[keyValues[@"res"] intValue]];
            items.sportName = customItemDict[@"sportName"];
            items.unit = customItemDict[@"unit"];
            items.timeSpan = customItemDict[@"timeSpan"];
            items.caloriesValue = customItemDict[@"caloriesValue"];
            [[NSManagedObjectContext MR_defaultContext] MR_save];
        } else {
            [self showAlertWithMessage:@"提交自定义运动项目失败" cancelButtonTitle:@"确定"];
        }
    }
    [self getSystemSportArrayFromLocal];
    
}
//本地获取项目库
-(void)getSystemSportArrayFromLocal {
    _systemSportArray = [NSMutableArray arrayWithArray:[Sport_Items MR_findAllInContext:[NSManagedObjectContext MR_defaultContext]]];
    [self updateScrollViewData:_systemSportArray AndScrollView:_storedScrollView];
}

-(void)getMySportArrayFromLocal {
    
    NSArray *array = [NSMutableArray arrayWithArray:[Sport_Item_Value MR_findAllInContext:[NSManagedObjectContext MR_defaultContext]]];
    NSMutableArray *idArray = [[NSMutableArray alloc] initWithCapacity:0];
    _usualySportArray = [[NSMutableArray alloc] initWithCapacity:0];
    for (int i = 0; i < MIN(array.count, 6); i ++) {
        BOOL hasIt = NO;
        Sport_Item_Value *itemValue = [array objectAtIndex:i];
        Sport_Items *item = [[Sport_Items MR_findByAttribute:@"sportId" withValue:itemValue.sportId inContext:[NSManagedObjectContext MR_defaultContext]] firstObject];
        for (Sport_Items *testItem in _usualySportArray) {
            if ([testItem.sportId isEqualToNumber:item.sportId]) {
                hasIt = YES;
            }
        }
        if (!hasIt) {
            [_usualySportArray addObject:item];
        }
        
    }
    
    [self updateScrollViewData:_usualySportArray AndScrollView:_usedScrollView];
    
}

-(void)PPiFlatSegmentedSelectedSegAtIndex:(int)index{
    switch (index) {
        case 0:
        {
            self.TFscrollView.contentOffset = CGPointMake(0, 0);
            
        }
            break;
        case 1:
        {
            self.TFscrollView.contentOffset = CGPointMake(320, 0);
        }
            break;
            
        default:
            break;
    }

}

- (IBAction)backButtonClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
//保存按钮点击事件
- (IBAction)saveButtonClick:(id)sender {
//        SportPaternersViewController * ssvc = [self.storyboard instantiateViewControllerWithIdentifier:@"SportPaternersViewController"];
//        [self.navigationController pushViewController:ssvc animated:YES];
    
    if ([_nameTextView.text length] < 1 || [_nameTextView.text isEqual:[NSNull null]]) {
        [self showAlertWithMessage:@"请填写食物名称" cancelButtonTitle:@"确认"];
        return ;
    }
    if ([_unitNameTextField.text length] < 1 || [_unitNameTextField.text isEqual:[NSNull null]]) {[self showAlertWithMessage:@"请填写正确的单位" cancelButtonTitle:@"确认"];
        return ;
        
    }
    if (![self isValueFloadValue:_carlisetextField.text]) {
        [self showAlertWithMessage:@"单位摄入量卡路里数为整形数，值格式错误,请检查后提交" cancelButtonTitle:@"确认"];
        return ;
    }
    if (![self isValueFloadValue:_unitTimeTextField.text]) {
        [self showAlertWithMessage:@"单位摄入量数值为整形数，格式错误,请检查后提交" cancelButtonTitle:@"确认"];
        return;
    }
    
    
    AppDelegate *appdelegate =(AppDelegate*) [[UIApplication sharedApplication] delegate];
    
    User* user = appdelegate.user;
    
    AppCloundService *service = [[AppCloundService alloc] initWidthDelegate:self];
//    @property (nonatomic, retain) NSNumber * caloriesValue;
//    @property (nonatomic, retain) NSNumber * sportId;
//    @property (nonatomic, retain) NSString * sportName;
//    @property (nonatomic, retain) NSNumber * timeSpan;
//    @property (nonatomic, retain) NSString * unit;
    customItemDict = @{
                       @"sportName": _nameTextView.text,
                       @"unit":_unitNameTextField.text,
                       @"timeSpan":[NSNumber numberWithFloat:[_unitTimeTextField.text floatValue]],
                       @"caloriesValue":[NSNumber numberWithFloat:[_carlisetextField.text floatValue]],
                       };
    [service addCustomsSportItemWithUserId:[user.userId intValue] sportName:_nameTextView.text uint:_unitNameTextField.text caloriesValue:[_carlisetextField.text floatValue] timeSpan:[_unitTimeTextField.text floatValue] isCustoms:1 remarks:nil];
    
}
//右上角记录按钮点击事件
- (IBAction)recordButtonClick:(id)sender {
    SportsRecordsViewController * ssvc = [self.storyboard instantiateViewControllerWithIdentifier:@"SportsRecordsViewController"];
    [self.navigationController pushViewController:ssvc animated:YES];
}


-(void)tapGesture:(UITapGestureRecognizer *)tap {
    
    UIView *tapView = (UIView *)[tap view];
    UIScrollView *scr = (UIScrollView *)[tapView superview];
    Sport_Items *item;
    if (scr.tag == 600) {
        if (_usualySportArray.count > tapView.tag) {
            item = [_usualySportArray objectAtIndex:tapView.tag];
        }
        
    } else if (scr.tag == 700) {
        if (_systemSportArray.count > tapView.tag) {
            item = [_systemSportArray objectAtIndex:tapView.tag];
        }
    }
    
    
    UIStoryboard *board = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    AddSportViewController * ssvc = [board instantiateViewControllerWithIdentifier:@"AddSportViewController"];
    ssvc.addSprotItem = item;
    [self.navigationController pushViewController:ssvc animated:YES];

    
}
-(void)updateScrollViewData:(NSMutableArray*)dataArray AndScrollView:(UIScrollView*)scrollView
{
    for (UIView * subview in scrollView.subviews) {
        [subview removeFromSuperview];
    }
    
    float width = scrollView.frame.size.width/3;
    float height = 50;
    scrollView.contentSize = CGSizeMake(width*3,height*((dataArray.count+2)/3));
    for (int i = 0; i<(dataArray.count+2)/3; i++) {
        for (int j = 0 ; j<3;j++ )
        {
            if ((j+1)+i*3>dataArray.count) {
                break;
            }
            UIView * sportView = [[UIView alloc]initWithFrame:CGRectMake(width*j, i*height, width, height)];
            sportView.backgroundColor = [UIColor clearColor];
            UIImageView * iconImageView = [[UIImageView alloc]initWithFrame:CGRectMake(24, 24, 15, 15)];
            Sport_Items * item = [dataArray objectAtIndex:i*3+j];
            iconImageView.image = [UIImage imageNamed:@"16_icon_yaling"];
            
            [sportView addSubview:iconImageView];
            
            
            
            UILabel * sportNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(47, 23, 50, 15)];
            sportNameLabel.textColor = UIColorFromRGB(0x9be2ff);
            sportNameLabel.text = item.sportName;
            sportNameLabel.font = [UIFont systemFontOfSize:Font];
            [sportView addSubview:sportNameLabel];
            sportView.tag = i*3+j;
//            UILabel * detailLabel = [[UILabel alloc]initWithFrame:CGRectMake(98, 23, 42, 15)];
//            detailLabel.textColor = [UIColor whiteColor];
//            detailLabel.text = item.detail;
//            detailLabel.font = [UIFont systemFontOfSize:Font];
            
            //点击事件
            sportView.userInteractionEnabled = YES;
            UITapGestureRecognizer *singleTap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];
            [sportView addGestureRecognizer:singleTap1];
            
            //[sportView addSubview:detailLabel];
            [scrollView addSubview:sportView];
        }
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

-(void)viewDidAppear:(BOOL)animated
{
    self.TFscrollView.contentSize = CGSizeMake(320*2, 439);
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)showAlertWithMessage:(NSString *)message cancelButtonTitle:(NSString *)cancel {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:nil cancelButtonTitle:cancel otherButtonTitles:nil, nil];
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
