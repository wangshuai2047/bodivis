//
//  HandringSleepViewController.h
//  TFHealth
//
//  Created by chenzq on 14-7-27.
//  Copyright (c) 2014年 studio37. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BleCoreManager.h"
#import "SportsRecordsViewController.h"

@interface HandringSleepViewController : UIViewController<BleCoreManagerDelegate>
@property UIViewController  *superview;
@property SportsRecordsViewController *recordview;
@end
