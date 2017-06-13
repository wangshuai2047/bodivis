//
//  HandRingViewController.h
//  TFHealth
//
//  Created by chenzq on 14-7-16.
//  Copyright (c) 2014年 studio37. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BleCoreManager.h"
#import "AKPickerView.h"
#import "SportsRecordsViewController.h"

@interface HandRingViewController : UIViewController<AKPickerViewDelegate,BleCoreManagerDelegate>
{
    NSString *selectedItem;
}
@property UIViewController  *superview;
@property SportsRecordsViewController *recordview;
@property (strong,nonatomic) NSString *selectedItem;
@property (weak, nonatomic) IBOutlet UINavigationItem *navBar;

@end
