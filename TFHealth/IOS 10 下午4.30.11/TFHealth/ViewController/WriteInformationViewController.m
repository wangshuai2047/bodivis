//
//  WriteInformationViewController.m
//  TFHealth
//
//  Created by hzth hzth－mac2 on 5/28/14.
//  Copyright (c) 2014 studio37. All rights reserved.
//

#import "WriteInformationViewController.h"
#import "DefaultInitViewController.h"
#import "CXAlertView.h"
#import "VPImageCropperViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <QuartzCore/QuartzCore.h>
#import "AppCloundService.h"
#import "User.h"
#import "AppDelegate.h"
#import "UIViewController+MMDrawerController.h"
#import "HealthStatusViewController.h"

#define ORIGINAL_MAX_WIDTH 640.0f

@interface WriteInformationViewController ()<UIImagePickerControllerDelegate, UIActionSheetDelegate, VPImageCropperDelegate>
- (IBAction)backUpView:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *portraitImageView;

@end

@implementation WriteInformationViewController

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
    
    NSLog(@"uid=%d",_userId);
    // Do any additional setup after loading the view.
    UIImage *bgImage=[UIImage imageNamed:@"sex.png"];
    UIColor *bgColor=[UIColor colorWithPatternImage:bgImage];
    [_boyView setBackgroundColor:bgColor];
    _sexId= 1;
    [self portraitImageView];
    
    
    
    
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
    _sexId= 1;
}

- (IBAction)girlViewClicked:(id)sender {
    UIImage *bgImage=[UIImage imageNamed:@"sex.png"];
    UIColor *bgColor=[UIColor colorWithPatternImage:bgImage];
    [_girlView setBackgroundColor:bgColor];
    [_boyView setBackgroundColor:[UIColor clearColor]];
    _sexId= 2;
}

- (IBAction)saveUesrInfo:(id)sender {
    NSString *name = _txtName.text;
    NSString *age =_txtAge.text;
    NSString *height=_txtHeight.text;
    if ([name isEqualToString:@""]||name==NULL) {
        [self showSystemAlert:@"请填写正确的昵称或姓名。"];
        return;
    }
    if ([age isEqualToString:@""]||age==NULL) {
        [self showSystemAlert:@"请填写正确的年龄信息。"];
        return;
    }
    else if(![self validateNumber:age])
    {
        [self showSystemAlert:@"年龄信息格式不正确，请填写正确的年龄信息。"];
        return;
    }
    if ([height isEqualToString:@""]||height==NULL) {
        [self showSystemAlert:@"请填写正确的身高信息。"];
        return;
    }
    else if(![self validateNumber:height])
    {
        [self showSystemAlert:@"身高信息格式不正确，请填写正确的身高信息。"];
        return;
    }
    int uAge = [age intValue];
    int uHeight=[height intValue];
    NSData *imageData = UIImagePNGRepresentation(_userImageView.image);
    //Byte *testByte = (Byte *)[imageData bytes];
    AppCloundService* s= [[AppCloundService alloc] initWidthDelegate:self];
    [s ImproveUserData:_userId userIco:imageData nick:name userAge:uAge userSex:_sexId userHeight:uHeight remark:@""];
}

-(void)serviceSuccessed:(NSDictionary*)keyValues pMethod:(NSString*)method
{
    if(keyValues.count>0 && [[keyValues allKeys] containsObject:@"res" ])
    {
        NSInteger res = [[keyValues objectForKey:@"res"] integerValue];
        if (res==8) {
            User *user=[User MR_createEntity];
            user.userName=[_username copy];
            user.password=[_password copy];
            user.userId=[NSNumber numberWithInteger:_userId];
            user.nickName = _txtName.text;
            user.sex = [NSNumber numberWithInteger:_sexId];
            user.height=[NSNumber numberWithInteger:[_txtHeight.text integerValue]];
            user.birthday=[NSNumber numberWithInteger:[_txtAge.text integerValue]];
            user.userIco= UIImagePNGRepresentation(self.portraitImageView.image);
            [[NSManagedObjectContext MR_defaultContext] MR_save];
            
            AppDelegate *appdelegate = [[UIApplication sharedApplication] delegate];
            appdelegate.user = user;
            appdelegate.userId=user.userId.intValue;
            //UIViewController * hsvc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"HealthStatusNavViewController"];
            //[appdelegate goMainView:hsvc];
            
            //晓晨看一下这里吧，哥搞不明白了，为什么这句不能直接跳转到首页？
            //[self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
            //目前用户句替代，但是跳转到首页后，没有出来左右菜单
            //[self presentViewController:hsvc animated:YES completion:nil];
            
            DefaultInitViewController *vc=[[self storyboard]instantiateViewControllerWithIdentifier:@"DefaultInitViewController"];
            UINavigationController *nav=[[UINavigationController alloc] initWithRootViewController:vc];
            NSLog(@"obj=%@",[keyValues objectForKey:@"res"]);

            [vc setUserId:_userId];
            [vc setUsername:_username];
            [self presentViewController:nav animated:YES completion:nil];
            
            
        }
        else
        {
            [self showSystemAlert:@"完善资料没有成功，请检测您的网络连接是否正常。"];
        }
    }
    else
    {
        [self showSystemAlert:@"资料失败，请检查您填写的信息是否正确并重试。"];
    }
}

-(void)serviceFailed:(NSString*) message pMethod:(NSString*)method
{
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    return [self validateNumber:string];
}

- (BOOL)validateNumber:(NSString*)number {
    BOOL res = YES;
    NSCharacterSet* tmpSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    int i = 0;
    while (i < number.length) {
        NSString * string = [number substringWithRange:NSMakeRange(i, 1)];
        NSRange range = [string rangeOfCharacterFromSet:tmpSet];
        if (range.length == 0) {
            res = NO;
            break;
        }
        i++;
    }
    return res;
}

- (IBAction)showSystemAlert:(id)sender
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:sender delegate:nil cancelButtonTitle:@"好" otherButtonTitles: nil];
    
    [alertView show];
}

- (IBAction)returnKeystoryboard:(id)sender {
    [sender resignFirstResponder];
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
    self.userImageView.image = editedImage;
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


- (IBAction)backUpView:(id)sender {
     [self dismissViewControllerAnimated:YES completion:nil];
}
@end
