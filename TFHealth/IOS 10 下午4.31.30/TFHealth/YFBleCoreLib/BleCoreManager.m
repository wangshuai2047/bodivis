//
//  WTYToast.m
//  YFBLESmartApp
//
//  Created by y61235 on 14-1-23.
//  Copyright (c) 2014年 yuanfeng. All rights reserved.
//

#import "BleCoreManager.h"
#import <AudioToolbox/AudioToolbox.h>
#import "HeaderBleUser.h"
#import "HeaderBleConstants.h"
#import "WTYToast.h"

@interface BleCoreManager()<BleDiscoveryDelegate,BleServiceProtocol,WTYCmdStatus,DFUControllerDelegate>{
    
    CBPeripheral *conPeripheral;
    NSTimer *timer;
    WTYBleService *curBleService;
    WTYSendUpdateTimeCmd *sendUpdateTime;
    WTYGetBattery *getBattery;
    WTYGetSoftVersion *getSoftVersion;
    WTYGetHardVersion *getHardVersion;
    WTYGetDeviceModel *getDeviceModel;
    
    WTYSetOtaModeCmd *setOtaMode;
    
    YFBleSendCmd *bledata;
    
    WTYRestartDeviceCmd *restartDevice;
    
    DFUController *dfuOtaHandle;
    
    WTYGetHealthData *getHealthData;
    
    WTYStartSleepCmd *startSleep;
    
    WTYStopSleepCmd *stopSleep;
    
    WTYGetDeviceStatus *getDeviceStatus;
    
    WTYGetSleepInfo *getSleepInfo;
    
    BOOL isOtaMode;
    BOOL isOtaEnable;
}
@end


@implementation BleCoreManager

static BleCoreManager *instance = nil;

+(BleCoreManager *)sharedInstance
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
        self.scaleResult = [[WTYRestartDeviceCmd alloc]init];
        self.batteryResult = [[WTYGetBattery alloc]init];
        self.healthDataResult = [[WTYHealthDataModel alloc]init];
        self.curStatus = CORE_STATUS_DISCONNECTED;
        
        [[WTYBleDiscovery sharedInstance] setDiscoveryDelegate:self];
        [[WTYBleDiscovery sharedInstance] startScanning];
        NSLog(@"[BleCoreManager]start scanning");
    }
    
    return self;
}

-(void)disconnectPeripheral:(CBPeripheral *)peripheral
{
    [[WTYBleDiscovery sharedInstance] disconnectPeripheral:peripheral];
    //[[WTYBleDiscovery sharedInstance] disCurConnectPeripheral];
}

-(void)connectPeripheral:(CBPeripheral *)peripheral
{
    [[WTYBleDiscovery sharedInstance] disCurConnectPeripheral];
    [[WTYBleDiscovery sharedInstance] connectPeripheral:peripheral];
}

-(void)scanList
{
    [[WTYBleDiscovery sharedInstance] startScanning];
}

-(int)getPeripheralCount
{
    NSInteger count = [[WTYBleDiscovery sharedInstance] foundPeripheralsUnit].count;
    return count;
}

-(WTYFoundDeviceModel*) findDeviceModel:(int)row
{
    NSArray *devicesFound = [[WTYBleDiscovery sharedInstance] foundPeripheralsUnit];
    WTYFoundDeviceModel *dn = [devicesFound objectAtIndex:row];
    return dn;
}

-(CoreStatus)getStatus
{
    return self.curStatus;
}

-(void)scan
{
    if (self.curStatus== CORE_STATUS_DISCONNECTED) {
        [[WTYBleDiscovery sharedInstance] startScanning];
        NSLog(@"[BleCoreManager]start connection...");
    }
    
    //[[WTYBleDiscovery sharedInstance] reConnect];
    
    //第一次使用需要利用以下代码连接设备
    
    NSArray *devicesFoundUnite = [[WTYBleDiscovery sharedInstance] foundPeripheralsUnit];
    if (conPeripheral!=nil) {
        for (int i=0; i<devicesFoundUnite.count; i++) {
            WTYFoundDeviceModel *dn = [devicesFoundUnite objectAtIndex:i];
            if ([dn.peripheral.name isEqualToString:conPeripheral.name]) {
                CBPeripheral *peripheral = dn.peripheral;
                if (peripheral.state == 2 || peripheral.state == 1) {
                    //[[WTYBleDiscovery sharedInstance] disconnectPeripheral:peripheral];
                }else {
                    [[WTYBleDiscovery sharedInstance] connectPeripheral:peripheral];
                }
            }
        }
    }
    else if (devicesFoundUnite.count>0) {
        WTYFoundDeviceModel *dn = [devicesFoundUnite objectAtIndex:0];
        CBPeripheral *peripheral = dn.peripheral;
        if (peripheral.state == 2 || peripheral.state == 1) {
            //[[WTYBleDiscovery sharedInstance] disconnectPeripheral:peripheral];
        }else {
            [[WTYBleDiscovery sharedInstance] connectPeripheral:peripheral];
        }
    }
}

-(void)disConnection
{
    if (conPeripheral.state == 2 || conPeripheral.state == 1) {
        [[WTYBleDiscovery sharedInstance] disconnectPeripheral:conPeripheral];
    }
}

- (void) discoveryDidRefresh
{
    NSLog(@"discoveryDidRefresh");
    
    if (curBleService != nil && curBleService!=nil) {
        if (conPeripheral.state == 2 || conPeripheral.state == 1)
        {
            self.curStatus = CORE_STATUS_CONNECTED;
            [self.delegate updateDeviceStatus:CORE_STATUS_CONNECTED];
        }
        else
        {
            self.curStatus = CORE_STATUS_DISCONNECTED;
            [self.delegate updateDeviceStatus:CORE_STATUS_DISCONNECTED];
        }
    }
    
    /*
    NSArray *devicesFoundUnite = [[WTYBleDiscovery sharedInstance] foundPeripheralsUnit];
    if (devicesFoundUnite.count>0) {
        WTYFoundDeviceModel *dn = [devicesFoundUnite objectAtIndex:0];
        CBPeripheral *peripheral = dn.peripheral;
        if (peripheral.state == 2 || peripheral.state == 1) {
            //[[WTYBleDiscovery sharedInstance] disconnectPeripheral:peripheral];
        }else {
            [[WTYBleDiscovery sharedInstance] connectPeripheral:peripheral];
        }
    }
    */
    //[deviceTable reloadData];
}

- (void) discoveryStatePoweredOff
{
    NSString *title     = @"蓝牙关闭";
    NSString *message   = @"您需要打开蓝牙才能使用这项应用。";
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil];
    [alertView show];
}

- (void) discoveryStatePoweredOn{
    [[WTYBleDiscovery sharedInstance] startScanningForUUIDString:nil];
    timer = [NSTimer scheduledTimerWithTimeInterval:5.0f target:self selector:@selector(reConnect) userInfo:nil repeats:NO];
}

- (void) didConnectPeripheral:(CBPeripheral *)peripheral{
    NSLog(@"connect ok");
    conPeripheral = peripheral;
    [self.delegate updateConnState];
    if (timer != nil) {
        [timer invalidate];
    }
    if (isOtaMode) {                // 设备进入ota模式 启动ota设备服务
        dfuOtaHandle = [[DFUController alloc] initWithDelegate:self];
        
        NSError *e;
        NSArray *binaries;
        NSData *jsonData = [NSData dataWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"binary_list" withExtension:@"json"]];
        NSDictionary *d = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:&e];
        binaries = [d objectForKey:@"binaries"];
        NSDictionary *binary = [binaries objectAtIndex:0];
        NSURL *firmwareURL = [[NSBundle mainBundle] URLForResource:[binary objectForKey:@"filename"] withExtension:[binary objectForKey:@"extension"]];
        
        [dfuOtaHandle setFirmwareURL:firmwareURL];
        [dfuOtaHandle setPeripheral:conPeripheral];
        [dfuOtaHandle didConnect];
        
    }else{                          // 正常模式 启动设备服务
        curBleService = [[WTYBleService alloc]init];
        [curBleService initService:conPeripheral protocol:self];
    }
}
- (void) didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error{
    NSLog(@"discon error: %@", error);
    //[WTYToast showWithText:@"didDisconnect"];
    [self.delegate updateConnState];
    if (error != nil) {
        timer = [NSTimer scheduledTimerWithTimeInterval:5.0f target:self selector:@selector(reConnect) userInfo:nil repeats:YES];
    }
    [self.delegate disError];
    
    
}

- (void) didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error{
    //[WTYToast showWithText:@"didFailToConnect"];
    [self.delegate updateConnState];
    timer = [NSTimer scheduledTimerWithTimeInterval:5.0f target:self selector:@selector(reConnect) userInfo:nil repeats:YES];
}

- (void) didFinishService:(WTYBleService *)bleService{
    NSLog(@"finishService");
    curBleService = bleService;
    
    self.curStatus = CORE_STATUS_CONNECTED;
    [self.delegate updateDeviceStatus:CORE_STATUS_CONNECTED];
    [self sendTime];
    //[self getHealthData];
}

-(void) reConnect
{
    [[WTYBleDiscovery sharedInstance] reConnect];
}

-(NSString *)getHealthArray:(NSArray *)array{
    NSMutableString *health = [[NSMutableString alloc]init];
    NSLog(@"共%d组健康数据",array.count);
    for (int i = 0; i < array.count; i ++) {
        
        WTYHealthDataModel *model = (WTYHealthDataModel *)[array objectAtIndex:i];
        
        NSString *healthI = [NSString stringWithFormat:@" %u step, %u cal, %u cm, %u min", model.steps, model.calories, model.distance, model.time];
        
        [health appendString:healthI];
    }
    return health;
}

-(NSString *)getSleepInfoArray:(NSArray *)array{
    NSMutableString *sleepInfo = [[NSMutableString alloc]init];
    NSLog(@"共%d组健康数据",array.count);
    for (int i = 0; i < array.count; i ++) {
        
        WTYGetSleepInfoModel *model = (WTYGetSleepInfoModel *)[array objectAtIndex:i];
        NSMutableString *info = [[NSMutableString alloc]init];
        for (int j = 0; j < model.sleepInfo.count; j ++) {
            WTYPerSleepInfoModel *perModel = [model.sleepInfo objectAtIndex:j];
            NSString *s = [NSString stringWithFormat:@" sleep status:%d, sleep time:%d", perModel.sleepStatus, perModel.totalMins]; //sleepStatus:1为清醒，2为混乱，3为浅睡，4为深睡
            [info appendString:s];
        }
        NSString *string = [NSString stringWithFormat:@" %@, %@", model.date, info];//date 会不准，最好startSleep 时自己记下开始睡眠的时间；
        
        [sleepInfo appendString:string];
    }
    return sleepInfo;
}

-(void)sendCmdFinish:(ListCmd) listCmd cmdObject:(id)object{
    
    if (listCmd == GetBattery){
        self.batteryResult = object;
        [self.delegate updateUIBattery:self.batteryResult];
    }
    else if(listCmd == GetHealthData){
        NSLog(@"共%d组健康数据",getHealthData.healthDataArray.count);
        if (getHealthData.healthDataArray.count==0) {
            [self.delegate updateFail];
        }
        for (int i = 0; i < getHealthData.healthDataArray.count; i ++) {
            self.healthDataResult= [getHealthData.healthDataArray objectAtIndex:i];
            [self.delegate updateUIStepInfo:self.healthDataResult];
        }
    }
    else if (listCmd == StartSleep){
        [self.delegate updateUIStartSleep];
        //[WTYToast showWithText:@"StartSleep finish"];
    }else if (listCmd == StopSleep){
        [self.delegate updateUIStopSleep];

        //[WTYToast showWithText:@"StopSleep finish"];
    }else if (listCmd == GetSleepInfo){
        //[WTYToast showWithText:@"GetSleepInfo finish"];
        for (int i=0; i<getSleepInfo.sleepInfoArray.count; i++) {
            WTYGetSleepInfoModel *model = (WTYGetSleepInfoModel *)[getSleepInfo.sleepInfoArray objectAtIndex:i];
            
            [self.delegate updateSleepTime:model];
        }
        //[WTYToast showWithText:info];
        //NSLog(@"%@", info);
    }
    else if(listCmd == RestartDevice)
    {
        self.scaleResult = object;
        [self.delegate updateUIData:self.scaleResult];
    }
    else if (listCmd == UpdateTime) {
        YFBleSendOneDataCmd * cyfb = (YFBleSendOneDataCmd*)object;
        [self.delegate updateUITime];
        //NSString *aStr = [[NSString alloc] initWithData:cyfb.receiveData encoding:NSASCIIStringEncoding];
        //[WTYToast showWithText:@"updateTime finish"];
    }
    else if (listCmd == GetSoftVersion){
        //WTYGetSoftVersion * softVersion = (WTYGetSoftVersion *)object;
        //[WTYToast showWithText:@"GetSoftVersion finish"];
        //[WTYToast showWithText:softVersion.softVersion];
    }else if (listCmd == GetHardVersion){
        //WTYGetHardVersion *hardVersion = (WTYGetHardVersion *)object;
        //[WTYToast showWithText:@"GetHardVersion finish"];
        //[WTYToast showWithText:hardVersion.hardVersion];
    }else if (listCmd == GetDeviceModel){
        //WTYGetDeviceModel *deviceModel = (WTYGetDeviceModel *)object;
        //[WTYToast showWithText:@"GetDeviceModel finish"];
        //[WTYToast showWithText:deviceModel.model];
    }else if (listCmd == SetOtaMode){
        isOtaMode = YES;
        //[WTYToast showWithText:@"OTA模式开启成功。"];
        [self.delegate updateYesOTA];
        //[WTYToast showWithText:@"SetOtaMode finish"];
    }
    else if (listCmd == GetDeviceStatus){
        //[WTYToast showWithText:@"GetDeviceStatus finish"];
        //NSString *string = [NSString stringWithFormat:@"%d", getDeviceStatus.status];
        //[WTYToast showWithText:string];
        NSLog(@"status:%d", getDeviceStatus.status);
        [self.delegate updateCoreStatue:getDeviceStatus];
    }
   /*else if (listCmd == GetDeviceInfo)
   {
       YFBleSendCmd * cyfb = (YFBleSendCmd*)object;
       NSString* aStr;
       aStr = [[NSString alloc] initWithData:cyfb.receiveData encoding:NSASCIIStringEncoding];
   }*/
}

-(void)sendCmdFailed:(ListCmd) listCmd cmdObject:(id)object{
    if (listCmd == UpdateTime) {
        [self.delegate updateUITime];
        //[WTYToast showWithText:@"updateTime failed"];
    }else if (listCmd == GetBattery){
        [WTYToast showWithText:@"设备未就绪，获取电量失败。"];
        [self.delegate updateFail];
    }
    else if(listCmd == GetHealthData){
        [self.delegate updateFail];
    }
    else if (listCmd == SetOtaMode){
        isOtaMode=NO;
        [WTYToast showWithText:@"固件升级模式开启失败。"];
        [self.delegate updateFail];
    }
    else if(listCmd==GetDeviceStatus)
    {
        [WTYToast showWithText:@"获取睡眠状态失败。"];
        [self.delegate updateFail];
    }
    else if (listCmd == GetSleepInfo){
        [WTYToast showWithText:@"获取睡眠信息失败。"];
        [self.delegate updateFail];
    }
    else if (listCmd == StartSleep){
        [WTYToast showWithText:@"开始睡眠失败。"];
        [self.delegate updateFail];
    }else if (listCmd == StopSleep){
        [WTYToast showWithText:@"停止睡眠失败。"];
        [self.delegate updateFail];
    }
    /// ........
}

- (void)sendTime {
    NSLog(@"bleManager sendTime");
    if (curBleService != nil) {
        sendUpdateTime = (WTYSendUpdateTimeCmd *)[WTYSendCmdFactory createUpdateTimeCmd];
        if (sendUpdateTime != nil) {
            [sendUpdateTime start:curBleService protocol:self];
        }
    }
}
- (void)getBattery {
    NSLog(@"bleManager getBattery");
    if (curBleService != nil) {
        getBattery = (WTYGetBattery *)[WTYSendCmdFactory createGetBattery];
        if (getBattery  != nil) {
            [getBattery start:curBleService protocol:self];
        }
    }
}

- (void)getHealthData {
    NSLog(@"bleManager getHealthData");
    if (curBleService != nil) {
        getHealthData = (WTYGetHealthData *)[WTYSendCmdFactory createGetHealthInfo];
        if (getHealthData  != nil) {
            [getHealthData start:curBleService protocol:self dataNum:1 startIndex:0];//当天健康数据
            //            [getHealthData start:curBleService protocol:self dataNum:1 startIndex:1];//前第一天的健康数据
            
            //.....
            //            [getHealthData start:curBleService protocol:self dataNum:1 startIndex:6];//前第6天的健康数据
            
            
            //            [getHealthData start:curBleService protocol:self dataNum:2 startIndex:0];//当天和前第1天的健康数据
            
            //            [getHealthData start:curBleService protocol:self dataNum:2 startIndex:1];//前第1天和前第2天的健康数据
        }
        else
        {
            [self.delegate updateFail];
        }
    }
    else
    {
        [self.delegate updateFail];
    }
}

- (void)startSleep {
    NSLog(@"bleManager startSleep");
    if (curBleService != nil) {
        startSleep = (WTYStartSleepCmd *)[WTYSendCmdFactory createStartSleepCmd];
        if (startSleep  != nil) {
            [startSleep start:curBleService protocol:self];
        }
    }
}
- (void)stopSleep {
    NSLog(@"bleManager stopSleep");
    if (curBleService != nil) {
        stopSleep = (WTYStopSleepCmd *)[WTYSendCmdFactory createStopSleepCmd];
        if (stopSleep  != nil) {
            [stopSleep start:curBleService protocol:self];
        }
    }
}

- (void)getSleepInfo {
    NSLog(@"bleManager getSleepInfo");
    if (curBleService != nil) {
        getSleepInfo = (WTYGetSleepInfo *)[WTYSendCmdFactory createGetSleepInfo];
        if (getSleepInfo  != nil) {
            [getSleepInfo start:curBleService protocol:self dataNum:1 startIndex:0];
        }
    }
}

- (void)getDeviceSoftVersion{
    NSLog(@"bleManager getDeviceSoftVersion");
    if (curBleService != nil) {
        getSoftVersion = (WTYGetSoftVersion *)[WTYSendCmdFactory createGetSoftVersion];
        if (getSoftVersion  != nil) {
            [getSoftVersion start:curBleService protocol:self];
        }
    }
}
- (void)getDeviceModel {
    NSLog(@"bleManager getDeviceModel");
    if (curBleService != nil) {
        getDeviceModel = (WTYGetDeviceModel *)[WTYSendCmdFactory createGetDeviceModel];
        if (getDeviceModel  != nil) {
            [getDeviceModel start:curBleService protocol:self];
        }
        
    }
}
- (void)getDeviceHardVersion {
    NSLog(@"bleManager getDeviceHardVersion");
    if (curBleService != nil) {
        getHardVersion = (WTYGetHardVersion *)[WTYSendCmdFactory createGetHardVersion];
        if (getHardVersion  != nil) {
            [getHardVersion start:curBleService protocol:self];
        }
    }
}

- (void)getDeviceStatus{
    NSLog(@"bleManager getDeviceStatus");
    if (curBleService != nil) {
        getDeviceStatus = (WTYGetDeviceStatus *)[WTYSendCmdFactory createGetDeviceStatus];
        if (getDeviceStatus  != nil) {
            [getDeviceStatus start:curBleService protocol:self];
        }
    }
}

- (void)setOtaMode {
    NSLog(@"bleManager setOtaMode");
    // 同方拿到的固件暂时不支持；
    
    // 2014-9-19 15：00后发的固件支持；
    if (curBleService != nil) {
        setOtaMode = (WTYSetOtaModeCmd *)[WTYSendCmdFactory createSetOtaMode];
        if (setOtaMode  != nil) {
            [setOtaMode start:curBleService protocol:self];
        }
    }
}

- (void)restartDevice:(id)sender {
    NSLog(@"bleManager restartDevice");
    if (curBleService != nil) {
        restartDevice = (WTYRestartDeviceCmd *)[WTYSendCmdFactory createRestartDevice];
        if (restartDevice  != nil) {
            [restartDevice start:curBleService protocol:self];
        }
    }
}
- (void)otaUpdate{
    // 同方拿到的固件暂时不支持；
    // 2014-9-19 15：00后发的固件支持；
    
    if (isOtaMode) {
        [dfuOtaHandle startTransfer];
    }
}

-(void)showProgress:(int)progress Cmd:(ListCmd)listCmd
{
    
}

- (void)discoveryBLEChangeStauts:(CBCentralManagerState)status
{
}

- (void) didChangeState:(DFUControllerState) state{
    if (state == IDLE)
    {
        isOtaEnable = YES;
        [WTYToast showWithText:@"OTA模式开启成功。"];
    }
}
- (void) didUpdateProgress:(float) progress{
    NSString *string = [NSString stringWithFormat:@"固件升级进度:%d%", (int)(progress*100)];
    [WTYToast showWithText:string];
    NSLog(@"固件升级进度:%f", progress);
}
- (void) didFinishTransfer{
    [WTYToast showWithText:@"固件升级完成。"];
    isOtaMode = NO;
    NSLog(@"didFinishTransfer otaupdate finish");
}
- (void) didCancelTransfer{
    NSLog(@"didCancelTransfer otaupdate finish");
}
- (void) didDisconnect:(NSError *) error{
    NSLog(@"otaupdate didDisconnect");
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIDeviceOrientationDidChangeNotification
                                                  object:[UIDevice currentDevice]];
}

@end
