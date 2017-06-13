//
//  NSObject+ReportModel.h
//  TFHealth
//
//  Created by chenzq on 14-7-22.
//  Copyright (c) 2014年 studio37. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface ReportModel :NSObject

@property (nonatomic, retain) NSString * report_desc;
@property (nonatomic, retain) NSString * sport_desc;
@property (nonatomic, retain) NSString * food_desc;
@property (nonatomic, retain) NSMutableArray * xLable;
@property (nonatomic, retain) NSMutableArray * weightValues;
@property (nonatomic, retain) NSMutableArray * pfbValues;
@property (nonatomic, retain) NSString * comp_desc;
@end