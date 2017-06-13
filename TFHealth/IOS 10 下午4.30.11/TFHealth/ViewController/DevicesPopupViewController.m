//
//  WriteVisitorInfViewController.m
//  TFHealth
//
//  Created by hzth hzth－mac2 on 6/3/14.
//  Copyright (c) 2014 studio37. All rights reserved.
//

#import "UIViewController+MMDrawerController.h"
#import "DevicesPopupViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <QuartzCore/QuartzCore.h>
#import "AppDelegate.h"
#import "AppCloundService.h"
#import "GBFlatButton.h"
#import "WTYBleDiscovery.h"
#import "WTYToast.h"
#import "UIViewController+CWPopup.h"

@interface DevicesPopupViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    BleCoreManager* bleCoreMgr;
    HandRingViewController * parent;
    NSTimer *timer;
}
@property (weak, nonatomic) IBOutlet GBFlatButton *closeButton;
@property (weak, nonatomic) IBOutlet UITableView *tableview;
- (IBAction)ClosePopup:(id)sender;

@end

@implementation DevicesPopupViewController

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
    
    bleCoreMgr = [BleCoreManager sharedInstance];
    bleCoreMgr.delegate = self;
    
    [_tableview setDelegate:self];
    [_tableview setDataSource:self];
    
    [bleCoreMgr scanList];
    //[[WTYBleDiscovery sharedInstance] setDiscoveryDelegate:bleCoreMgr];
    //[[WTYBleDiscovery sharedInstance] startScanning];
    
}

- (void) discoveryDidRefresh
{
    //    NSLog(@"discoveryDidRefresh");
    [_tableview reloadData];
}

#pragma mark -- UITableView Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //NSInteger count = [[WTYBleDiscovery sharedInstance] foundPeripheralsUnit].count;
    int count= [bleCoreMgr getPeripheralCount];
    return count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 44;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *TableCustomIdentifier = @"TableCustomIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
                             TableCustomIdentifier];
    UIColor *bColor = [UIColor colorWithRed:255.0 green:255.0 blue:255.0 alpha:0.2];
    
    cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
    
    cell.selectedBackgroundView.backgroundColor = bColor;
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleValue1
                reuseIdentifier:TableCustomIdentifier];
    }
    
    //NSArray *devicesFound;
    CBPeripheral	*peripheral;
    NSNumber *rssi;
    
    UIColor *txtColor = [UIColor colorWithRed:72.0/255.0 green:175.0/255.0 blue:253.0/255.0 alpha:1];
    //devicesFound = [[WTYBleDiscovery sharedInstance] foundPeripheralsUnit];
    
    NSUInteger row = [indexPath row];
    //WTYFoundDeviceModel *dn = [devicesFound objectAtIndex:row];
    WTYFoundDeviceModel *dn=[bleCoreMgr findDeviceModel:row];
    peripheral = dn.peripheral;
    rssi = dn.rssi;
    cell.textLabel.textColor=[UIColor whiteColor];
    if (peripheral.name == nil) {
        cell.textLabel.text = @"Null";
    }else{
        cell.textLabel.text = peripheral.name;
    }
    cell.backgroundColor=[UIColor clearColor];
    cell.detailTextLabel.textColor=[UIColor whiteColor];
    if (peripheral.state == 2) {
        //cell.detailTextLabel.text = [NSString stringWithFormat:@"conState:%d, Rssi:%@", peripheral.state ,peripheral.RSSI];
        cell.detailTextLabel.text=@"状态：已连接";
        cell.detailTextLabel.textColor=txtColor;
        cell.textLabel.textColor=txtColor;
    }else{
        //cell.detailTextLabel.text = [NSString stringWithFormat:@"conState:%d, Rssi:%@", peripheral.state ,rssi];
        cell.detailTextLabel.text=@"状态：未连接";
    }
    
    cell.detailTextLabel.font = [UIFont fontWithName:@"Arial"  size:12];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    //NSArray *devicesFoundUnite = [[WTYBleDiscovery sharedInstance] foundPeripheralsUnit];
    NSUInteger row = [indexPath row];
    //WTYFoundDeviceModel *dn = [devicesFoundUnite objectAtIndex:row];
    WTYFoundDeviceModel *dn=[bleCoreMgr findDeviceModel:row];
    CBPeripheral *peripheral = dn.peripheral;
    if (peripheral.state == 2 || peripheral.state == 1) {
        [bleCoreMgr disconnectPeripheral:peripheral];
        //[[WTYBleDiscovery sharedInstance] disconnectPeripheral:peripheral];
    }else {
        [bleCoreMgr connectPeripheral:peripheral];
        //[[WTYBleDiscovery sharedInstance] disCurConnectPeripheral];
        //[[WTYBleDiscovery sharedInstance] connectPeripheral:peripheral];
    }
}

-(void)updateConnState
{
    [_tableview reloadData];
}

-(void)updateDeviceStatus:(CoreStatus)status
{
    
}

-(void)disError
{
    
}

-(void)updateUIData:(WTYRestartDeviceCmd*)object
{
}

-(void)updateUIStepInfo:(WTYHealthDataModel*)object
{
}
-(void)updateUIStartSleep
{
}
-(void)updateUIStopSleep
{
}
-(void)updateSleepTime:(WTYGetSleepInfoModel*)object
{
}
-(void)updateFail
{
}

-(void)updateUITime
{
    [parent updateUITime];
}

/*
- (void) didConnectPeripheral:(CBPeripheral *)peripheral{
    [WTYToast showWithText:@" 已连接  "];
}
- (void) didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error{
    NSLog(@"discon error: %@", error);
    [WTYToast showWithText:@" 未连接  "];
    if (error != nil) {
        timer = [NSTimer scheduledTimerWithTimeInterval:4.0f target:self selector:@selector(reConnect) userInfo:nil repeats:YES];
    }
}

- (void) didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error{
    [WTYToast showWithText:@" 连接失败 "];
    timer = [NSTimer scheduledTimerWithTimeInterval:4.0f target:self selector:@selector(reConnect) userInfo:nil repeats:YES];
}

- (void) didFinishService:(WTYBleService *)bleService{
    NSLog(@"finishService");
    //[WTYToast showWithText:@"服务已建立"];
    //curBleService = bleService;
    [_tableview reloadData];
}
*/
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

-(void)setOwener:(HandRingViewController*)view
{
    parent=view;
}

- (IBAction)ClosePopup:(id)sender {
    if(parent!=nil)
    {
        bleCoreMgr.delegate = parent;
        [parent dismissPopupViewControllerAnimated:true completion:nil];
    }
}
@end
