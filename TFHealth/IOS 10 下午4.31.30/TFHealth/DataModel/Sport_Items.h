//
//  Sport_Items.h
//  TFHealth
//
//  Created by chenzq on 14-6-14.
//  Copyright (c) 2014年 studio37. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Sport_Items : NSManagedObject

@property (nonatomic, retain) NSNumber * caloriesValue;
@property (nonatomic, retain) NSNumber * sportId;
@property (nonatomic, retain) NSString * sportName;
@property (nonatomic, retain) NSNumber * timeSpan;
@property (nonatomic, retain) NSString * unit;
@property (nonatomic, retain) NSManagedObject *sportItems_sportItemValue_ship;

@end
