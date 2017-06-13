//
//  SportTipsViewController.h
//  TFHealth
//
//  Created by nico on 14-9-8.
//  Copyright (c) 2014年 studio37. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SportSuggestionsViewController.h"

@interface SportTipsViewController : UIViewController

-(void)setTips:(NSString*)tip;
-(void)setOwener:(SportSuggestionsViewController*)view;

@end
