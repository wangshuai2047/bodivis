//
//  FoodSuggestionsViewController.h
//  TFHealth
//
//  Created by chenzq on 14-7-29.
//  Copyright (c) 2014年 studio37. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FoodSuggestionsViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextView *suggestionTextView;
@property (weak, nonatomic) IBOutlet UINavigationItem *navBar;
@property(strong,nonatomic) NSString * suggestion;
@end
