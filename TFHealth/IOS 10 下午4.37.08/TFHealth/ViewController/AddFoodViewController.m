//
//  AddFoodViewController.m
//  TFHealth
//
//  Created by hzth hzth－mac2 on 6/3/14.
//  Copyright (c) 2014 studio37. All rights reserved.
//

#import "AddFoodViewController.h"
#import "AppCloundService.h"
#import "AppDelegate.h"
@interface AddFoodViewController  ()<ServiceObjectDelegate,UITextFieldDelegate>
{
    int selectItemTag;
}
@property (weak, nonatomic) IBOutlet UITextField *nameTextView;
@property (weak, nonatomic) IBOutlet UITextField *calTextView;
@property (weak, nonatomic) IBOutlet UITextField *unitTextView;
@property (weak, nonatomic) IBOutlet UILabel *selectResultLabel;
@property (weak, nonatomic) IBOutlet UIView *selectItemView;
@property (weak, nonatomic) IBOutlet UIView *addfood_type_container;

@end

@implementation AddFoodViewController

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
    [_nameTextView resignFirstResponder];
    [_calTextView resignFirstResponder];
    [_unitTextView resignFirstResponder];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setViewData];
    [self initUI];
    // Do any additional setup after loading the view.
}

-(void)initUI
{
    UIColor *borderColor = [UIColor colorWithRed:255.0 green:255.0 blue:255.0 alpha:0.2];
    _addfood_type_container.layer.masksToBounds = YES;
    _addfood_type_container.layer.cornerRadius = 6.0;
    _addfood_type_container.layer.borderWidth = 1.0;
    _addfood_type_container.layer.borderColor = [borderColor CGColor];
    _addfood_type_container.layer.backgroundColor=[borderColor CGColor];
}

-(void)setViewData
{
    if (self.foodDictionary) {
        self.nameTextView.text = self.foodDictionary.foodName;
        self.calTextView.text = [NSString stringWithFormat:@"%@",self.foodDictionary.caloriesValue];
        self.unitTextView.text = @" ";
    }
}



- (IBAction)backClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)checkButtonClick:(id)sender {
    UIButton * button = (UIButton*)sender;
    button.selected = !button.selected;
}

- (IBAction)selectItemButtonClicked:(id)sender {
    _selectItemView.hidden = NO;
}


- (IBAction)selectetItem:(id)sender {
    UIButton *button = (UIButton * )sender;
    selectItemTag = button.tag - 600;
    switch (selectItemTag) {
        case 0:
            _selectResultLabel.text = @"早餐";
            break;
        case 1:
            _selectResultLabel.text = @"午餐";
            break;
        case 2:
            _selectResultLabel.text = @"晚餐";
            break;
        case 3:
            _selectResultLabel.text = @"加餐";
            break;
        default:
            break;
    }
    _selectItemView.hidden = YES;
}

//保存上传添加的食品  刘飞--7.13
/*
 question : calorieValue 是食物的卡路里，or食物卡路里*intakeValue ?
 type :页面尚未实现
 
 */
- (IBAction)saveButtonClick:(id)sender {
    
    if ([_nameTextView.text length] < 1 || [_nameTextView.text isEqual:[NSNull null]]) {
        [self showAlertWithMessage:@"请填写食物名称" cancelButtonTitle:@"确认"];
        return ;
    }
    if ([_calTextView.text length] < 1 || [_calTextView.text isEqual:[NSNull null]]) {[self showAlertWithMessage:@"请填写正确的单位" cancelButtonTitle:@"确认"];
        return ;
    }
    if ([_unitTextView.text length] < 1 || [_unitTextView.text isEqual:[NSNull null]]) {[self showAlertWithMessage:@"单位不能为空，并且为整形数" cancelButtonTitle:@"确认"];
        return ;
    }
    if (![self isValueFloadValue:_calTextView.text]) {
        [self showAlertWithMessage:@"单位摄入量卡路里数为整形数，值格式错误,请检查后提交" cancelButtonTitle:@"确认"];
        return ;
    }
    NSLog(@"%@",_unitTextView.text);
//    if (![self isValueFloadValue:_unitTextView.text]) {
//        [self showAlertWithMessage:@"单位值为整形数" cancelButtonTitle:@"确认"];
//        return;
//    }
    
    AppDelegate *appdelegate =(AppDelegate*) [[UIApplication sharedApplication] delegate];
    
    User* user = appdelegate.user;
    NSDateFormatter *formater = [[NSDateFormatter alloc] init];
    [formater setDateFormat:@"yyyy-MM-dd"];
    NSString *string = [formater stringFromDate:[NSDate date]];
    AppCloundService *service = [[AppCloundService alloc] initWidthDelegate:self];
    [service uploadFoodInfoWithUserId:[user.userId intValue] foodId:[_foodDictionary.foodId intValue] intakeValue:[NSString stringWithFormat:@"%.1f",[_unitTextView.text floatValue]] calorieValuer:[NSString stringWithFormat:@"%.1f",[_foodDictionary.caloriesValue intValue]*[_unitTextView.text floatValue]] intakeDate:string andType:[NSString stringWithFormat:@"%d",selectItemTag]];
    
}
//记录
- (IBAction)recordButtonClicked:(id)sender {
    
    
    
}

#pragma mark -- Serviece delegate
-(void)requestSuccessed:(NSString *)request {
    NSLog(@"upload food info failure");
}
-(void)requestFailed:(NSString *)request {
    
}
-(void)serviceFailed:(NSString *)message pMethod:(NSString*)method{
    NSLog(@"upload food info failure:%@",message);
}
-(void)serviceSuccessed:(NSDictionary *)keyValues pMethod:(NSString*)method{
    NSLog(@"upload food info %@",keyValues[@"res"]);
    AppDelegate *appdelegate =(AppDelegate*) [[UIApplication sharedApplication] delegate];
    
    User* user = appdelegate.user;
    if ([method isEqualToString:@"UploadFoodInfoJson"]) {
        if ([keyValues[@"res"] intValue] == 8) {
            DalidFood *foodDalid = [DalidFood MR_createEntity];
            NSDate *date = [NSDate date];
            NSDateFormatter *formate = [[NSDateFormatter alloc] init];
            [formate setDateFormat:@"yyyy-MM-dd"];
            NSString *string = [formate stringFromDate:date];
            date = [formate dateFromString:string];
            foodDalid.calorieValue = [NSNumber numberWithFloat:[_foodDictionary.caloriesValue intValue]*([_unitTextView.text floatValue]/[_foodDictionary.gramValue floatValue])];
            foodDalid.foodId = self.foodDictionary.foodId;
            foodDalid.foodName = _nameTextView.text;
            foodDalid.intakeDate = date;
            foodDalid.intakeValue = [NSNumber numberWithFloat:[_unitTextView.text floatValue]];
            foodDalid.type = [NSNumber numberWithInt:selectItemTag];
            foodDalid.userId=user.userId;
            NSLog(@"foodName :%@",self.foodDictionary.foodName);
            
            [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
            [self showAlertWithMessage:@"添加膳食成功，您可以返回进行其他操作" cancelButtonTitle:@"确定"];
        } else {
            [self showAlertWithMessage:@"添加膳食失败，您可以稍后重试" cancelButtonTitle:@"确定"];
        }
    }
    
    
}

#pragma mark -- UITextField delegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(BOOL)isValueFloadValue:(NSString *)str {
    NSString *floatRegex = @"^(([0-9]+\.[0-9]*[1-9][0-9]*)|([0-9]*[1-9][0-9]*\.[0-9]+)|([0-9]*[1-9][0-9]*))$";
    NSPredicate *floatPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",floatRegex];
    return [floatPredicate evaluateWithObject:str];
}
-(void)showAlertWithMessage:(NSString *)message cancelButtonTitle:(NSString *)cancel {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:nil cancelButtonTitle:cancel otherButtonTitles:nil, nil];
    [alert show];
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
