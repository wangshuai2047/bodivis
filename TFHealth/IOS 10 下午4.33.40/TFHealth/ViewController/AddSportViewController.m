//
//  AddSportViewController.m
//  TFHealth
//
//  Created by hzth hzth－mac2 on 6/3/14.
//  Copyright (c) 2014 studio37. All rights reserved.
//

#import "AddSportViewController.h"
#import "SportPaternersViewController.h"
#import "Sport_Item_Value.h"
#import "AppCloundService.h"
#import "AppDelegate.h"
@interface AddSportViewController () <ServiceObjectDelegate,UITextFieldDelegate>


@property (weak, nonatomic) IBOutlet UITextField *timeTextField;
@property (weak, nonatomic) IBOutlet UITextField *unitTextField;
@property (weak, nonatomic) IBOutlet UITextField *calTextField;
@property (weak, nonatomic) IBOutlet UITextField *nameTextLabel;


@end

@implementation AddSportViewController

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
    
    
    _nameTextLabel.text = _addSprotItem.sportName;
    _calTextField.text = [NSString stringWithFormat:@"%@",_addSprotItem.caloriesValue];
    _unitTextField.text = _addSprotItem.unit;
    
    
}

- (IBAction)backButtonClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)saveButtonClick:(id)sender {
//    SportPaternersViewController * ssvc = [self.storyboard instantiateViewControllerWithIdentifier:@"SportPaternersViewController"];
//    [self.navigationController pushViewController:ssvc animated:YES];
    
    
    if ([_nameTextLabel.text length] < 1 || [_nameTextLabel.text isEqual:[NSNull null]]) {
        [self showAlertWithMessage:@"请填写食物名称" cancelButtonTitle:@"确认"];
        return ;
    }
    if ([_unitTextField.text length] < 1 || [_unitTextField.text isEqual:[NSNull null]]) {[self showAlertWithMessage:@"请填写正确的单位" cancelButtonTitle:@"确认"];
        return ;
        
    }
    if ([_timeTextField.text length] < 1 || [_timeTextField.text isEqual:[NSNull null]]) {[self showAlertWithMessage:@"运动时间不能为空" cancelButtonTitle:@"确认"];
        return ;
        
    }
    if (![self isValueFloadValue:_calTextField.text]) {
        [self showAlertWithMessage:@"单位摄入量卡路里数为整形数，值格式错误,请检查后提交" cancelButtonTitle:@"确认"];
        return ;
    }
    if (![self isValueFloadValue:_timeTextField.text]) {
        [self showAlertWithMessage:@"" cancelButtonTitle:@"确认"];
        return;
    }
    
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    User *user = appDelegate.user;
    NSDateFormatter *formater = [[NSDateFormatter alloc] init];
    [formater setDateFormat:@"yyyy-MM-dd"];
    NSString *string = [formater stringFromDate:[NSDate date]];
    
    AppCloundService *service = [[AppCloundService alloc] initWidthDelegate:self];
    [service uploadSportWithUserId:[user.userId intValue] sportId:[_addSprotItem.sportId intValue ] movementTime:[_timeTextField.text intValue] calorie:[NSString stringWithFormat:@"%@",[NSNumber numberWithFloat:[_calTextField.text floatValue]*([_timeTextField.text floatValue]/[_addSprotItem.timeSpan floatValue])]] sportDate:string];
    
   
    
}

#pragma  mark -- service delegate
-(void)serviceFailed:(NSString *)message pMethod:(NSString *)method {
    
}
-(void)serviceSuccessed:(NSDictionary *)keyValues pMethod:(NSString *)method {
//    @property (nonatomic, retain) NSNumber * consumptionCalories;
//    @property (nonatomic, retain) NSNumber * movementTime;
//    @property (nonatomic, retain) NSNumber * sportId;
//    @property (nonatomic, retain) NSDate * testDate;
//    @property (nonatomic, retain) NSNumber * userId;
//    @property (nonatomic, retain) Sport_Items *sportItemValue_sportItems_ship;
//    @property (nonatomic, retain) NSManagedObject *sportItemValue_user_ship;
    if ([method isEqualToString:@"UploadSportInfoJson"]) {
        if ([keyValues[@"res"] intValue] == 8) {
            AppDelegate *dele = (AppDelegate *)[UIApplication sharedApplication].delegate;
            NSDate *date = [NSDate date];
            NSDateFormatter *formate = [[NSDateFormatter alloc] init];
            [formate setDateFormat:@"yyyy-MM-dd"];
            NSString *string = [formate stringFromDate:date];
            date = [formate dateFromString:string];
            Sport_Item_Value *customItem = [Sport_Item_Value MR_createEntity];
            customItem.sportId = _addSprotItem.sportId;
            customItem.consumptionCalories = [NSNumber numberWithFloat:[_calTextField.text floatValue]*([_timeTextField.text floatValue]/[_addSprotItem.timeSpan floatValue])];
            customItem.movementTime = [NSNumber numberWithFloat:[_timeTextField.text floatValue]];
            customItem.testDate = date;
            customItem.userId = dele.user.userId;
            
            [[NSManagedObjectContext MR_defaultContext] MR_save];
            [self showAlertWithMessage:@"添加运动项目成功，您可以返回进行其他操作" cancelButtonTitle:@"确定"];
            
        } else {
            
        }
    }
    
   
    NSLog(@"ssss :%@",[Sport_Item_Value MR_findAll]);
}

-(void)showAlertWithMessage:(NSString *)message cancelButtonTitle:(NSString *)cancel {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:nil cancelButtonTitle:cancel otherButtonTitles:nil, nil];
    [alert show];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField  resignFirstResponder];
    return YES;
}
-(BOOL)isValueFloadValue:(NSString *)str {
    NSString *floatRegex = @"^(([0-9]+\.[0-9]*[1-9][0-9]*)|([0-9]*[1-9][0-9]*\.[0-9]+)|([0-9]*[1-9][0-9]*))$";
    NSPredicate *floatPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",floatRegex];
    return [floatPredicate evaluateWithObject:str];
}

@end
