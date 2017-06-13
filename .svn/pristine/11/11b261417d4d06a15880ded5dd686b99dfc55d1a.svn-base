//
//  HealthStatusTableViewCell.h
//  TFHealth
//
//  Created by hzth hzth－mac2 on 6/8/14.
//  Copyright (c) 2014 studio37. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AnalyseColorBar.h"
@interface HealthStatusTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *colorBarView;
@property (strong,nonatomic) NSString * description;
@property (strong,nonatomic) NSArray * properties;
@property (strong,nonatomic) NSArray * propertiesPersent;
@property (strong,nonatomic) AnalyseColorBar * bar;

-(void)setColorBarDetailsWithDescriptionStr:(NSString*)descriptionStr PropertyArray:(NSArray*)properties Level:(int)level;

-(void)setColorBarDetail:(NSString*)testValue pMin:(NSString*)minValue pMax:(NSString*)maxValue pLevel:(int)level;
@end
