//
//  ColorBar.h
//  TFHealth
//
//  Created by hzth hzth－mac2 on 6/8/14.
//  Copyright (c) 2014 studio37. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ColorBar : UIView
@property (strong,nonatomic) UILabel * descriptionLabel;
@property (strong,nonatomic) UILabel * lowProperty;
@property (strong,nonatomic) UILabel * normalProperty;
@property (strong,nonatomic) UILabel * highProperty;
@property (strong,nonatomic) UIImageView * downArrowImageView;

-(void)setLevel:(int) level;
@end
