//
//  Members.h
//  TFHealth
//
//  Created by chenzq on 14-6-14.
//  Copyright (c) 2014年 studio37. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class User;

@interface Members : NSManagedObject

@property (nonatomic, retain) NSNumber * memberType;
@property (nonatomic, retain) NSNumber * userId;
@property (nonatomic,retain) NSNumber * appUserId;
@property (nonatomic, retain) User *members_user_ship;

@end
