//
//  WTYGetSleepInfo.h
//  TestBleCore
//
//  Created by y61235 on 14-8-20.
//  Copyright (c) 2014年 yftech. All rights reserved.
//

#import "YFBleSendCmd.h"


typedef enum ListSleepStatus{
    qingxing = 1,
    hunluan,
    qianshui,
    shenshui,
}ListSleepStatus;
@interface WTYPerSleepInfoModel : NSObject
@property (nonatomic, assign) int sleepStatus;
@property (nonatomic, assign) int totalMins;
@end
@interface WTYGetSleepInfoModel : NSObject
// yyyy-MM-dd HH:mm:ss
@property (nonatomic, strong) NSString *date;

@property (nonatomic, strong) NSMutableArray *sleepInfo;
@end
@interface WTYGetSleepInfo : YFBleSendCmd
@property (nonatomic, strong) NSMutableArray *sleepInfoArray;

- (void)start:(WTYBleService *)bleService
     protocol:(id<WTYCmdStatus>)protocol
      dataNum:(int)value
   startIndex:(int)nIndex;
@end
