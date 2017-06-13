//
//  WTYCmdStatus.h
//  TestBleCore
//
//  Created by y61235 on 14-8-12.
//  Copyright (c) 2014年 yftech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HeaderBleConstants.h"


@protocol WTYCmdStatus <NSObject>

-(void)sendCmdFinish:(ListCmd) listCmd cmdObject:(id)object;
-(void)sendCmdFailed:(ListCmd) listCmd cmdObject:(id)object;
-(void)showProgress:(int)progress Cmd:(ListCmd) listCmd;

@end
