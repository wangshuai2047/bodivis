//
//  WriteFamilyInfViewController.h
//  TFHealth
//
//  Created by hzth hzth－mac2 on 6/3/14.
//  Copyright (c) 2014 studio37. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ServiceCallbackDelegate.h"

@interface WriteFamilyInfViewController : UIViewController<ServiceObjectDelegate>
- (IBAction)textFieldDoneEditing:(id)sender;
@property (assign, nonatomic) int sexId;//1男    //2女
@property (assign, nonatomic) int isOnclicks; //0未添加  //1已添加
@property (assign,nonatomic) int isModifyMode; //是否为修改模式 1:修改模式 否则正常模式
-(void)loadUserInfo;
@end
