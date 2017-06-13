//
//  SportSuggestionsViewController.h
//  TFHealth
//
//  Created by hzth hzth－mac2 on 5/27/14.
//  Copyright (c) 2014 studio37. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ServiceCallbackDelegate.h"

@interface SportSuggestionsViewController : UIViewController<ServiceObjectDelegate>
@property (weak, nonatomic) IBOutlet UITextView *suggestionTextView;
@property (weak, nonatomic) IBOutlet UINavigationItem *navBar;
@property(strong,nonatomic) NSString * suggestion;
@end
