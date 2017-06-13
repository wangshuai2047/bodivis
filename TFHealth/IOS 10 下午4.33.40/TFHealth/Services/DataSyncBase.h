//
//  DataSyncBase.h
//  TFHealth
//
//  Created by nico on 14-11-17.
//  Copyright (c) 2014年 studio37. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ServiceCallbackDelegate.h"
#import "AppCloundService.h"

@protocol pDownload

-(BOOL)isExist:(int)uid uname:(NSString*)uname;
-(void)queryData;
-(void)updateData:(NSDictionary*)keyValues;
-(NSString*)getMethodName;
-(void)setInstance;
-(void)setDownloadFlag:(int)flag;
-(int)getDownloadFlag;
-(BOOL)isSingleResult;

@end

@interface DataSyncBase : NSObject<pDownload,ServiceObjectDelegate>

@property (nonatomic,assign) int userId;
@property (nonatomic,assign) NSString* userName;
@property (nonatomic,assign) AppCloundService* service;

-(void)downloadData;
-(NSDate*)convertDate:(id)value;
-(NSNumber*)getIntValue:(id)value;
-(NSString*)getStringValue:(id)value;
-(NSNumber*)getDoubleValue:(id)value;

@end
