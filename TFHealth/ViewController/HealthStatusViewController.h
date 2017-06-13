//
//  HealthStatusViewController.h
//  TFHealth
//
//  Created by hzth hzth－mac2 on 6/7/14.
//  Copyright (c) 2014 studio37. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VScaleManager.h"
#import "User.h"

@interface HealthStatusViewController : UIViewController<VScaleManagerDelegate>

-(void)refreshUI:(User*)user;

@end
