//
//  RegisterViewController.h
//  TFHealth
//
//  Created by chenzq on 14-7-1.
//  Copyright (c) 2014年 studio37. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BFPaperCheckbox.h"

@interface DefaultInitViewController : UIViewController<BFPaperCheckboxDelegate>
- (IBAction)textFieldDoneEditing:(id)sender;
@property (assign, nonatomic) NSInteger userId;
@property (copy, nonatomic) NSString* username;
@end
