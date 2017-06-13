//
//  User.h
//  TFHealth
//
//  Created by chenzq on 14-6-14.
//  Copyright (c) 2014年 studio37. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class DalidFood, Sport_Item_Value, User_Comprehensive_Eval, User_Item_Info;

@interface User : NSManagedObject

@property (nonatomic, retain) NSNumber * birthday;
@property (nonatomic, retain) NSNumber * height;
@property (nonatomic, retain) NSNumber * loginType;
@property (nonatomic, retain) NSString * nickName;
@property (nonatomic, retain) NSNumber * sex;
@property (nonatomic, retain) NSData * userIco;//用户头像
@property (nonatomic, retain) NSNumber * userId;
@property (nonatomic, retain) NSString * userName;
@property (nonatomic, retain) NSString * password;
@property (nonatomic, retain) NSNumber * weight;
@property (nonatomic, retain) User_Comprehensive_Eval *user_comprehensiveEval_ship;
@property (nonatomic, retain) DalidFood *user_dalidDood_ship;
@property (nonatomic, retain) NSManagedObject *user_members_ship;
@property (nonatomic, retain) NSManagedObject *user_personal_ship;
@property (nonatomic, retain) Sport_Item_Value *user_sportItemValue_ship;
@property (nonatomic, retain) User_Item_Info *user_userItemInfo_ship;

@end
