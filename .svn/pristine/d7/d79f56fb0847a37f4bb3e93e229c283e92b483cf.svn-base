//
//  ServiceCallbackDelegate.h
//  TFHealth
//
//  Created by nico on 14-6-24.
//  Copyright (c) 2014年 studio37. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequest/ASIHTTPRequest.h"

@protocol ServiceCallbackDelegate
@required
-(void)requestSuccessed:(NSString*)request;
-(void)requestFailed:(NSString*)request;

@end

@protocol ServiceObjectDelegate <NSObject>

-(void)serviceSuccessed:(NSDictionary*)keyValues pMethod:(NSString*)method;
-(void)serviceFailed:(NSString*) message pMethod:(NSString*)method;

@end
