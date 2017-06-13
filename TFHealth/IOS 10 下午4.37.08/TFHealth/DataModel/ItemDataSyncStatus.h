//
//  ItemDataSyncStatus.h
//  TFHealth
//
//  Created by nico on 14-9-23.
//  Copyright (c) 2014年 studio37. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface ItemDataSyncStatus : NSManagedObject

@property (nonatomic,retain) NSNumber* userId;
@property (nonatomic,retain) NSNumber* compflag;
@property (nonatomic,retain) NSNumber* itemflag;

@end
