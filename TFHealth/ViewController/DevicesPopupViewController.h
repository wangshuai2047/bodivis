//
//  WriteVisitorInfViewController.h
//  TFHealth
//
//  Created by hzth hzth－mac2 on 6/3/14.
//  Copyright (c) 2014 studio37. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HandRingViewController.h"
#import "BleCoreManager.h"

@interface DevicesPopupViewController : UIViewController
-(void) setBleState:(WTYBleService*)bleService bleDis:(WTYBleDiscovery*)bleDis;
-(void)setOwener:(HandRingViewController*)view;
@end
