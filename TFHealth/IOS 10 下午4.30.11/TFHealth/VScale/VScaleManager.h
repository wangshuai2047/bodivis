//
//  VScaleManager.h
//  VScale_Sdk_Demo
//
//  Created by Ben on 13-10-10.
//  Copyright (c) 2013年 Vtrump. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VTScales.h"

@protocol  VScaleManagerDelegate;

typedef enum
{
    VC_STATUS_DISCONNECTED,
    VC_STATUS_DISCOVERED,
    VC_STATUS_CONNECTING,
    VC_STATUS_CONNECTED,
    VC_STATUS_SERVICE_READY,
    VC_STATUS_CACULATE,
    VC_STATUS_HOLDING,
} VCStatus;


@interface VScaleManager : NSObject<VTDeviceManagerDelegate, VTDeviceDelegate, VTProfileScaleDelegate>

/*用于指示应用状态*/
@property (nonatomic,assign)  VCStatus curStatus;
/*测量数据*/
@property (nonatomic,retain)  VTFatScaleTestResult *scaleResult;
@property (nonatomic,retain)  id<VScaleManagerDelegate> delegate;

+(VScaleManager *)sharedInstance;
-(void)scan;
- (void)disconnect;
@end


@protocol VScaleManagerDelegate <NSObject>

@required
-(void)updateDeviceStatus:(VCStatus)status;
-(void)updateUIData:(VTFatScaleTestResult*)result;

@end