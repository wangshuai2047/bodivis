//
//  MealFoodTableViewCell.h
//  TFHealth
//
//  Created by hzth hzth－mac2 on 6/13/14.
//  Copyright (c) 2014 studio37. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MealFoodTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *foodNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *numLabel;
@property (weak, nonatomic) IBOutlet UILabel *calorie;

@end
