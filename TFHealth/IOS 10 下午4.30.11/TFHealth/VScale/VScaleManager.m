//
//  VScaleManager.m
//  VScale_Sdk_Demo
//
//  Created by Ben on 13-10-10.
//  Copyright (c) 2013年 Vtrump. All rights reserved.
//
#import <AudioToolbox/AudioToolbox.h>
#import "VScaleManager.h"
#import "AppDelegate.h"

#define KEY_MODEL_NUMBER    @"modelNumber"

@interface VScaleManager(){
    VTDeviceManager *deviceManager;
    VTDeviceModel *deviceModel;
    NSMutableArray *serviceUUID;
}

@end

@implementation VScaleManager

static VScaleManager *instance = nil;

+(VScaleManager *)sharedInstance
{
    @synchronized(self)
    {
        if (instance == nil)
        {
            instance = [[self alloc] init];
        }
    }
    return instance;
}

-(id)init
{
    self = [super init];
    
    if(self){
        /* init test result */
        self.scaleResult = [[VTFatScaleTestResult alloc]init];
        self.curStatus = VC_STATUS_DISCONNECTED;
        
        deviceManager = [VTDeviceManager sharedInstance];
        deviceManager.delegate = self;
        
        serviceUUID = cGetServiceUUID;
        
        NSLog(@"[VScaleManager]init scanning");
    }
    
    return self;
}

-(void)scan
{
    [deviceManager scan:serviceUUID];
}

- (void)disconnect
{
    NSLog(@"disconnect status = %d", self.curStatus);
    if (self.curStatus != VC_STATUS_DISCONNECTED && self.curStatus!=VC_STATUS_DISCOVERED){
        NSNumber * modelNumber = (NSNumber *)[deviceModel getMetaData:KEY_MODEL_NUMBER defaultValue:nil];
        
        if (modelNumber == nil){
            [deviceModel disconnect];
        }else{
            NSInteger modelNumberInt = [modelNumber integerValue];
            if (Format_ModelNumber_Version_Type(modelNumberInt) == SCALE_VERSION_TYPE_VALID_VALUE){
                [deviceModel.profile suspendDevice:deviceModel];
            }else{
                [deviceModel disconnect];
            }
        }
    }
}

#pragma mark -
#pragma mark private method
- (void) gotoStatus:(VCStatus) status{
    
    self.curStatus = status;
    
    [self.delegate updateDeviceStatus:status];
}

- (UILocalNotification*) scheduleNotificationOn:(NSDate*) fireDate
                                           text:(NSString*) alertText
                                         action:(NSString*) alertAction
                                          sound:(NSString*) soundfileName
                                    launchImage:(NSString*) launchImage
                                        andInfo:(NSDictionary*) userInfo
                                        counted:(BOOL)counted
                                 repeatInterval:(NSCalendarUnit)repeat
                                 enableAtActive:(BOOL)enable


{
    if(enable == NO)
    {
        if ([[UIApplication sharedApplication] applicationState] == UIApplicationStateActive)
            return nil;
    }
    
    
	UILocalNotification *localNotification = [[UILocalNotification alloc] init];
    localNotification.fireDate = fireDate;
    localNotification.timeZone = [NSTimeZone defaultTimeZone];
    
    localNotification.alertBody = alertText;
    localNotification.alertAction = alertAction;
    
    if(repeat != 0){
        localNotification.repeatInterval = repeat;
    }
    
	if(soundfileName == nil)
	{
		localNotification.soundName = nil;
	}
	else
	{
		localNotification.soundName = soundfileName;
	}
    
	localNotification.alertLaunchImage = launchImage;
    
    localNotification.applicationIconBadgeNumber = 1;
    localNotification.userInfo = userInfo;
    
	// Schedule it with the app
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
    
    return localNotification;
}

#pragma mark -
#pragma mark VTProfileDelegate implemenation
- (void) didTestResultValueUpdate:(VTDeviceModel *)device scaleType:(UInt8)scaleType result:(id)result
{
    
    NSLog(@"didTestResultValueUpdate");
    
    if(result != nil){
        switch (scaleType) {
            case VT_VSCALE_FAT:{
                self.scaleResult = result;
                if (self.scaleResult.weight == 0.0) return;
                
                switch (self.curStatus) {
                    case VC_STATUS_SERVICE_READY:{
                        [self gotoStatus:VC_STATUS_HOLDING];
                        NSLog(@"VC_STATUS_SERVICE_READY done");
                        [self.delegate updateUIData:self.scaleResult];
                        
                        VTScaleUser *_currentUser = [[VTScaleUser alloc] init];
                        AppDelegate *appdelegate =(AppDelegate*) [[UIApplication sharedApplication] delegate];
                        NSString *uId = [NSString stringWithFormat:@"%d",appdelegate.user.userId];
                        
                        User *user = [User MR_findFirstByAttribute:@"userId" withValue:appdelegate.user.userId inContext:[NSManagedObjectContext MR_defaultContext]];
                        if (user!=nil) {
                            _currentUser.userID = user.userId.intValue; // Use slot 9 for caculate
                            _currentUser.gender = user.sex.intValue==1?0:1; //0代表男性、1代表女性
                            _currentUser.age = user.birthday.intValue;  //年龄
                            _currentUser.height = user.height.intValue;  //身高
                        }
                        else
                        {
                            _currentUser.userID = 0x9; // Use slot 9 for caculate
                            _currentUser.gender = 0; //0代表男性、1代表女性
                            _currentUser.age = 27;  //年龄
                            _currentUser.height = 178;  //身高
                        }
                        [deviceModel.profile caculateResult:deviceModel user:_currentUser];
                        [self gotoStatus:VC_STATUS_CACULATE];
                    }
                        break;
                    case VC_STATUS_CACULATE:{
                        NSLog(@"VC_STATUS_CACULATING done");
                        [self gotoStatus:VC_STATUS_CACULATE];
                        [self.delegate updateUIData:self.scaleResult];
                        [self gotoStatus:VC_STATUS_SERVICE_READY];
                    }
                        break;
                    case VC_STATUS_HOLDING:
                        NSLog(@"VC_STATUS_HOLDING done");
                        [self gotoStatus:VC_STATUS_HOLDING];
                        // ignored
                        ;
                        break;
                    default:
                        break;
                }
            }
                
                break;
            default:
                break;
        }
        
    }
}

#pragma mark -
#pragma mark VTDeviceManagerDelegate implementation

- (Boolean) didDiscovered:(VTDeviceManager *)dm device:(VTDeviceModel *)device{
    NSLog(@"didDiscovered");
    
    return NO;
}

- (void)didConnected:(VTDeviceManager *)dm device:(VTDeviceModel *)device{
    NSLog(@"didConnected");
    deviceModel = device;
}

- (void) didStatusUpdate:(CBCentralManagerState) status{
    NSLog(@"didStatusUpdate %d",status);
}

- (void)didDisconnected:(VTDeviceManager *)dm device:(VTDeviceModel *)device{
    
    NSLog(@"didDisconnected");
    [self gotoStatus:VC_STATUS_DISCONNECTED];
    deviceModel = nil;
    
    
    AudioServicesPlaySystemSound(1004);
    
    //[[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_DISCONNECTED object:nil];
    
    [deviceManager stopScan];
}

- (void)didServiceReady:(VTDeviceManager *)dm device:(VTDeviceModel *)device{
    NSLog(@"didServiceReady");
    
    NSLog(@"remembered device UUID = %@, current device UUID = %@", deviceModel.UUID, device.UUID);
    if ([deviceModel.UUID isEqualToString:device.UUID]){
        
        
        deviceModel = device;
        device.delegate = self;
        device.profile.delegate = self;
        
        VTEventModel * event = [device createEvent:VT_EVENT_CONNECTED];
        [device insertEvent:event];
        
        if ([device.profile supportProfile:BLE_SERVICE_DEVICE_INFO]){
            [device.profile readModelNumber:device];
            [device.profile readFirmwareVersion:device];
        }
        
        
        [device.profile setTestResultNotification:device on:YES];
        [device.profile readTestResult:deviceModel];
        
       ///////
        
        [self gotoStatus:VC_STATUS_SERVICE_READY];
        //[[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_SERVICE_READY object:nil];
        
    }
    
}

- (void) didPaired:(VTDeviceManager*)dm device:(VTDeviceModel *)device{
    NSLog(@"didPaired");
    // not paired
}


- (void) didAdvertised:(VTDeviceManager *)dm device:(VTDeviceModel *)device{
    NSLog(@"didAdvertised");
}

- (void) didDataPushed:(VTDeviceManager *)dm device:(VTDeviceModel *)device advertise:(VTAdvertise *)advertise{
    NSLog(@"didDataPushed ManufactureId = %ld type = %d data = %@", advertise.manufactureId, advertise.type, advertise.data);
    
    if (self.curStatus == VC_STATUS_DISCONNECTED){
        
#if !(TARGET_IPHONE_SIMULATOR)
        VTDeviceModelNumber * modelNumber = [[VTDeviceModelNumber alloc] initWithManufactureData:advertise.data];
        
        if (modelNumber.version == VT_DEVICE_MODEL_VERSION_1 && modelNumber.type == VT_DEVICE_VSCALE){
            
            
            /* If found a new device */
            NSString *vendorName = NSLocalizedString(@"vtrump", nil);
            NSString *subType =NSLocalizedString(@"fat scale",nil);
            
            NSString *msg = [NSString stringWithFormat:@"%@ %@ %@?", NSLocalizedString(@"Connect to",nil), vendorName,subType];
            //NSLocalizedString(@"Connent to ?",nil);
            
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"Scale Weight", nil) message:msg delegate:self cancelButtonTitle:NSLocalizedString(@"cancel",nil) otherButtonTitles:NSLocalizedString(@"ok",nil), nil];
            device.delegate = self;
            
            deviceModel = device;
            [self gotoStatus:VC_STATUS_DISCOVERED];
            
            AudioServicesPlaySystemSound(1002);
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
            
            [self
             scheduleNotificationOn:[NSDate new]
             text:NSLocalizedString(@"Weight scale detected",nil)
             action:@"View"
             sound:nil
             launchImage:device.imageUrl
             andInfo:nil
             counted:YES
             repeatInterval:0
             enableAtActive:NO];
            //[alertView show];
             [deviceModel  connect];
        }
#endif
    }
    
}

- (void) didSerialNumberUpdated:(VTDeviceModel *)device serialNumber:(id)serialNumber{
    if ([deviceModel.UUID isEqualToString:device.UUID]){
        NSData * data = serialNumber;
        
        NSLog(@"serial Number is: %@", data.description);
    }
}

- (void) didFirmwareVersionUpdated:(VTDeviceModel *)device version:(NSString *)version{
    if ([deviceModel.UUID isEqualToString:device.UUID]){
        
        NSLog(@"firmware version is: %@", version);
    }
}

- (void) didModelNumberUpdated:(VTDeviceModel *)device modelNumber:(NSData *)modelNumber{
    if ([deviceModel.UUID isEqualToString:device.UUID]){
        
        Byte * modelNumberArray = (Byte*) modelNumber.bytes;
        int modelNumberInt = modelNumberArray[0] * 0x1000000 + modelNumberArray[1] * 0x10000 + modelNumberArray[2]* 0x100 + modelNumberArray[3];
        NSNumber *modelNumberValue = [NSNumber numberWithInt:modelNumberInt];
        [device setMetaData:KEY_MODEL_NUMBER value:modelNumberValue];
        NSLog(@"modelNumber = 0x%x", modelNumberInt);
        
        //[PublicFunction setVSData:@"modelNumber" value:modelNumberValue];
        
        
        //[[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_MODEL_NUMBER object:nil];
    }
}

#pragma mark -
#pragma mark UIAlertViewDelegate implementation

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    switch (buttonIndex) {
        case 0:
            if (self.curStatus == VC_STATUS_DISCOVERED){
                [self gotoStatus:VC_STATUS_DISCONNECTED];
            }
            break;
        case 1:
            //connect device
            [deviceModel  connect];
            break;
            
        default:
            break;
    }
    
}

@end
