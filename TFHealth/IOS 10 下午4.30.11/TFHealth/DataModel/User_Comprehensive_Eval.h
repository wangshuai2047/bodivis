//
//  User_Comprehensive_Eval.h
//  TFHealth
//
//  Created by chenzq on 14-6-14.
//  Copyright (c) 2014年 studio37. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface User_Comprehensive_Eval : NSManagedObject

@property (nonatomic, retain) NSNumber * cid;
@property (nonatomic, retain) NSString * summary;
@property (nonatomic, retain) NSNumber * synchronizedStatus;
@property (nonatomic, retain) NSDate * testDate;
@property (nonatomic, retain) NSNumber * testScore;
@property (nonatomic, retain) NSNumber * userId;
@property (nonatomic, retain) NSManagedObject *comprehensiveEval_user_ship;
@property (nonatomic, retain) NSManagedObject *comprehensiveEval_userItemInfo_ship;

@end
