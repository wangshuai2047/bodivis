//
//  WriteFamilyInfViewController.m
//  TFHealth
//
//  Created by hzth hzth－mac2 on 6/3/14.
//  Copyright (c) 2014 studio37. All rights reserved.
//

#import "WriteFamilyInfViewController.h"
#import "HealthStatusViewController.h"
#import "UIViewController+MMDrawerController.h"
#import "Members.h"
#import "User.h"
#import "CXAlertView.h"
#import "VPImageCropperViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <QuartzCore/QuartzCore.h>
#import "AppDelegate.h"
#import "AppCloundService.h"
#import "UserDevices.h"

#define ORIGINAL_MAX_WIDTH 640.0f

@interface WriteFamilyInfViewController ()<UIImagePickerControllerDelegate, UIActionSheetDelegate, VPImageCropperDelegate>
@property (weak, nonatomic) IBOutlet UIView *boyView;
@property (weak, nonatomic) IBOutlet UIView *girlView;
- (IBAction)boyViewClicked:(id)sender;
- (IBAction)girlViewClicked:(id)sender;
- (IBAction)saveFamily:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *txtName;
@property (weak, nonatomic) IBOutlet UITextField *txtAge;
@property (weak, nonatomic) IBOutlet UITextField *txtHeight;
@property (weak, nonatomic) IBOutlet UIImageView *portraitImageView;
@property (weak, nonatomic) IBOutlet UINavigationItem *titleBar;

@end

@implementation WriteFamilyInfViewController

@synthesize isModifyMode;
@synthesize isOnclicks;

- (IBAction)textFieldDoneEditing:(id)sender {
    [sender resignFirstResponder];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (IBAction)backButtonClikc:(id)sender {
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideRight animated:YES completion:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    isOnclicks=0;
    UIImage *bgImage=[UIImage imageNamed:@"sex.png"];
    UIColor *bgColor=[UIColor colorWithPatternImage:bgImage];
    [_boyView setBackgroundColor:bgColor];
    _sexId=1;
    [self portraitImageView];
}

-(void)loadUserInfo
{
    AppDelegate *appdelegate =(AppDelegate*) [[UIApplication sharedApplication] delegate];
    User* user = appdelegate.user;
    [UIView animateWithDuration:0.1 animations:^{
        _txtName.text = [NSString stringWithFormat:@"%@",user.nickName];
        _txtAge.text = [NSString stringWithFormat:@"%d",user.birthday.intValue];
        _txtHeight.text = [NSString stringWithFormat:@"%d",user.height.intValue];
        
        if (user.sex.intValue==1) {
            [self boyViewClicked:nil];
        }
        else
        {
            [self girlViewClicked:nil];
        }
        if (user.userIco!=nil&& user.userIco!=NULL) {
            UIImage *image = [UIImage imageWithData:user.userIco];
            self.portraitImageView.image=image;
        }
    }];
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

- (IBAction)boyViewClicked:(id)sender {
    UIImage *bgImage=[UIImage imageNamed:@"sex.png"];
    UIColor *bgColor=[UIColor colorWithPatternImage:bgImage];
    [_boyView setBackgroundColor:bgColor];
    
    [_girlView setBackgroundColor:[UIColor clearColor]];
    _sexId=1;
    
}

- (IBAction)girlViewClicked:(id)sender {
    UIImage *bgImage=[UIImage imageNamed:@"sex.png"];
    UIColor *bgColor=[UIColor colorWithPatternImage:bgImage];
    [_girlView setBackgroundColor:bgColor];
    [_boyView setBackgroundColor:[UIColor clearColor]];
    _sexId=2;
}

- (IBAction)saveFamily:(id)sender {
    if (isOnclicks==1) {
        return;
    }
    isOnclicks=1;
    NSString *name = _txtName.text;
    int age =_txtAge.text.intValue;
    int height=_txtHeight.text.intValue;
    if (name==nil||name==NULL||[name length]==0) {
        [self showSystemAlert:@"请填写正确的昵称或姓名。"];
        return;
    }
    if (age==0) {
        [self showSystemAlert:@"请填写正确的年龄信息。"];
        return;
    }
    if (height==0) {
        [self showSystemAlert:@"请填写正确的身高信息。"];
        return;
    }
    AppDelegate *appdelegate =(AppDelegate*) [[UIApplication sharedApplication] delegate];
    
    NSData *currentDate = [NSDate date];
    NSDateFormatter *formate = [[NSDateFormatter alloc] init];
    [formate setDateFormat:@"yyyy-MM-dd"];
    
    AppCloundService* s= [[AppCloundService alloc] initWidthDelegate:self];
    if (isModifyMode!=1) {
        [s AddMembers:appdelegate.userId userIco:UIImagePNGRepresentation(self.portraitImageView.image) nick:name userHeight:height userWeight:60 userSex:_sexId userAge:age userType:@"0" relationshipName:@"家人" addTime:[formate stringFromDate:currentDate]];
    }
    else
    {
        [s ImproveUserData:appdelegate.userId userIco:UIImagePNGRepresentation(self.portraitImageView.image) nick:name userAge:age userSex:_sexId userHeight:height remark:@""];
    }
}

-(void)serviceSuccessed:(NSDictionary*)keyValues pMethod:(NSString*)method
{
    isOnclicks=0;
    if ([method isEqualToString:@"AddMembersJson"]) {
        [self AddUser:keyValues];
    }
    else if([method isEqualToString:@"PerfectUserInfoJson"])
    {
        [self UpdateUser:keyValues];
    }
}

-(void)serviceFailed:(NSString*) message pMethod:(NSString*)method
{
    [self showSystemAlert:@"保存数据失败，请检查您填写的信息是否正确并检查网络"];
    isOnclicks=0;
}

-(void)AddUser:(NSDictionary*)keyValues
{
    if(keyValues.count>0 && [[keyValues allKeys] containsObject:@"res" ])
    {
        NSInteger res = [[keyValues objectForKey:@"res"] integerValue];
        if (res>0) {
            NSString *name = _txtName.text;
            int age =_txtAge.text.intValue;
            int height=_txtHeight.text.intValue;
            
            User *user =[User MR_createEntity];
            user.nickName=name;
            user.sex=[NSNumber numberWithInt:_sexId];
            user.height=[NSNumber numberWithInteger:height];
            user.birthday=[NSNumber numberWithInteger:age];
            user.userId=[NSNumber numberWithInteger:res];
            user.userIco= UIImagePNGRepresentation(self.portraitImageView.image);
            [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
            
            AppDelegate *appdelegate =(AppDelegate*) [[UIApplication sharedApplication] delegate];
            
            Members *member=[Members MR_createEntity];
            member.appUserId=[NSNumber numberWithInteger:appdelegate.userId];
            member.userId=[NSNumber numberWithInteger:res];
            member.memberType=0;
            [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
            
            //[self showSystemAlert:[NSString stringWithFormat:@"您的家人%@添加成功。",name]];
            
            UserDevices *device = [UserDevices MR_findFirstByAttribute:@"userName" withValue:_txtName.text];
            if (device!=nil) {
                if (device.deviceType.intValue==0) {
                    device.state=[NSNumber numberWithInt:1];
                    [[NSManagedObjectContext MR_defaultContext] MR_save];
                }
            }
            appdelegate.user=user;
            UIViewController *vc2 = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"HealthStatusNavViewController"];
            
            //UIViewController *vc3 = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"AboutViewController"];
            
            [self.mm_drawerController setCenterViewController:vc2 withCloseAnimation:YES completion:nil];
        }
        else
        {
            [self showSystemAlert:@"添加家人失败，请检查您填写的信息是否正确并重试。"];
        }
    }
    else
    {
        [self showSystemAlert:@"添加家人失败，请检查您填写的信息是否正确并重试。"];
    }
}

-(void)UpdateUser:(NSDictionary*)keyValues
{
    if(keyValues.count>0 && [[keyValues allKeys] containsObject:@"res" ])
    {
        NSInteger res = [[keyValues objectForKey:@"res"] integerValue];
        if (res==8) {
            AppDelegate *appdelegate = [[UIApplication sharedApplication] delegate];
            User *user=appdelegate.user;
            user.nickName=[_txtName text];
            user.sex=[NSNumber numberWithInt:_sexId];
            user.height=[NSNumber numberWithInteger:[_txtHeight.text integerValue]];
            user.birthday=[NSNumber numberWithInteger:_txtAge.text.intValue];
            user.userId=appdelegate.user.userId;
            user.userIco= UIImagePNGRepresentation(self.portraitImageView.image);
            
            [[NSManagedObjectContext MR_defaultContext] MR_save];

            [self.mm_drawerController toggleDrawerSide:MMDrawerSideRight animated:YES completion:nil];
        }
        else
        {
            [self showSystemAlert:@"用户资料修改失败，请检测您的网络连接是否正常。"];
        }
    }
    else
    {
        [self showSystemAlert:@"用户资料修改失败，请检查您填写的信息是否正确并重试。"];
    }
}

- (IBAction)showSystemAlert:(id)sender
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:sender delegate:nil cancelButtonTitle:@"好" otherButtonTitles: nil];
    
    [alertView show];
}

- (void)editPortrait {
    UIActionSheet *choiceSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:@"取消"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"拍照", @"从相册中选取", nil];
    [choiceSheet showInView:self.view];
}

#pragma mark VPImageCropperDelegate
- (void)imageCropper:(VPImageCropperViewController *)cropperViewController didFinished:(UIImage *)editedImage {
    self.portraitImageView.image = editedImage;
    [cropperViewController dismissViewControllerAnimated:YES completion:^{
        // TO DO
    }];
}

- (void)imageCropperDidCancel:(VPImageCropperViewController *)cropperViewController {
    [cropperViewController dismissViewControllerAnimated:YES completion:^{
    }];
}

#pragma mark UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        // 拍照
        if ([self isCameraAvailable] && [self doesCameraSupportTakingPhotos]) {
            UIImagePickerController *controller = [[UIImagePickerController alloc] init];
            controller.sourceType = UIImagePickerControllerSourceTypeCamera;
            if ([self isFrontCameraAvailable]) {
                controller.cameraDevice = UIImagePickerControllerCameraDeviceFront;
            }
            NSMutableArray *mediaTypes = [[NSMutableArray alloc] init];
            [mediaTypes addObject:(__bridge NSString *)kUTTypeImage];
            controller.mediaTypes = mediaTypes;
            controller.delegate = self;
            [self presentViewController:controller
                               animated:YES
                             completion:^(void){
                                 NSLog(@"Picker View Controller is presented");
                             }];
        }
        
    } else if (buttonIndex == 1) {
        // 从相册中选取
        if ([self isPhotoLibraryAvailable]) {
            UIImagePickerController *controller = [[UIImagePickerController alloc] init];
            controller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            NSMutableArray *mediaTypes = [[NSMutableArray alloc] init];
            [mediaTypes addObject:(__bridge NSString *)kUTTypeImage];
            controller.mediaTypes = mediaTypes;
            controller.delegate = self;
            [self presentViewController:controller
                               animated:YES
                             completion:^(void){
                                 NSLog(@"Picker View Controller is presented");
                             }];
        }
    }
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:^() {
        UIImage *portraitImg = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        portraitImg = [self imageByScalingToMaxSize:portraitImg];
        // present the cropper view controller
        VPImageCropperViewController *imgCropperVC = [[VPImageCropperViewController alloc] initWithImage:portraitImg cropFrame:CGRectMake(0, 100.0f, self.view.frame.size.width, self.view.frame.size.width) limitScaleRatio:3.0];
        imgCropperVC.delegate = self;
        [self presentViewController:imgCropperVC animated:YES completion:^{
            // TO DO
        }];
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:^(){
    }];
}

#pragma mark image scale utility
- (UIImage *)imageByScalingToMaxSize:(UIImage *)sourceImage {
    if (sourceImage.size.width < ORIGINAL_MAX_WIDTH) return sourceImage;
    CGFloat btWidth = 0.0f;
    CGFloat btHeight = 0.0f;
    if (sourceImage.size.width > sourceImage.size.height) {
        btHeight = ORIGINAL_MAX_WIDTH;
        btWidth = sourceImage.size.width * (ORIGINAL_MAX_WIDTH / sourceImage.size.height);
    } else {
        btWidth = ORIGINAL_MAX_WIDTH;
        btHeight = sourceImage.size.height * (ORIGINAL_MAX_WIDTH / sourceImage.size.width);
    }
    CGSize targetSize = CGSizeMake(btWidth, btHeight);
    return [self imageByScalingAndCroppingForSourceImage:sourceImage targetSize:targetSize];
}

- (UIImage *)imageByScalingAndCroppingForSourceImage:(UIImage *)sourceImage targetSize:(CGSize)targetSize {
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    if (CGSizeEqualToSize(imageSize, targetSize) == NO)
    {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if (widthFactor > heightFactor)
            scaleFactor = widthFactor; // scale to fit height
        else
            scaleFactor = heightFactor; // scale to fit width
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        // center the image
        if (widthFactor > heightFactor)
        {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }
        else
            if (widthFactor < heightFactor)
            {
                thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
            }
    }
    UIGraphicsBeginImageContext(targetSize); // this will crop
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil) NSLog(@"could not scale image");
    
    //pop the context to get back to the default
    UIGraphicsEndImageContext();
    return newImage;
}

#pragma mark - UINavigationControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
}

#pragma mark camera utility
- (BOOL) isCameraAvailable{
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
}

- (BOOL) isRearCameraAvailable{
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
}

- (BOOL) isFrontCameraAvailable {
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront];
}

- (BOOL) doesCameraSupportTakingPhotos {
    return [self cameraSupportsMedia:(__bridge NSString *)kUTTypeImage sourceType:UIImagePickerControllerSourceTypeCamera];
}

- (BOOL) isPhotoLibraryAvailable{
    return [UIImagePickerController isSourceTypeAvailable:
            UIImagePickerControllerSourceTypePhotoLibrary];
}
- (BOOL) canUserPickVideosFromPhotoLibrary{
    return [self
            cameraSupportsMedia:(__bridge NSString *)kUTTypeMovie sourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}
- (BOOL) canUserPickPhotosFromPhotoLibrary{
    return [self
            cameraSupportsMedia:(__bridge NSString *)kUTTypeImage sourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}

- (BOOL) cameraSupportsMedia:(NSString *)paramMediaType sourceType:(UIImagePickerControllerSourceType)paramSourceType{
    __block BOOL result = NO;
    if ([paramMediaType length] == 0) {
        return NO;
    }
    NSArray *availableMediaTypes = [UIImagePickerController availableMediaTypesForSourceType:paramSourceType];
    [availableMediaTypes enumerateObjectsUsingBlock: ^(id obj, NSUInteger idx, BOOL *stop) {
        NSString *mediaType = (NSString *)obj;
        if ([mediaType isEqualToString:paramMediaType]){
            result = YES;
            *stop= YES;
        }
    }];
    return result;
}

#pragma mark portraitImageView getter

- (UIImageView*)portraitImageView {

    [_portraitImageView.layer setCornerRadius:(_portraitImageView.frame.size.height/2)];
    [_portraitImageView.layer setMasksToBounds:YES];
    [_portraitImageView setContentMode:UIViewContentModeScaleAspectFill];
    [_portraitImageView setClipsToBounds:YES];
    _portraitImageView.layer.shadowColor = UIColorFromRGB(0x6d91e2).CGColor;
    _portraitImageView.layer.shadowOffset = CGSizeMake(4, 4);
    _portraitImageView.layer.shadowOpacity = 0.5;
    _portraitImageView.layer.shadowRadius = 2.0;
    _portraitImageView.layer.borderColor = UIColorFromRGB(0x6d91e2).CGColor;
    _portraitImageView.layer.borderWidth = 5.0f;
    _portraitImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *portraitTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(editPortrait)];
    [_portraitImageView addGestureRecognizer:portraitTap];
    return _portraitImageView;
}

@end
