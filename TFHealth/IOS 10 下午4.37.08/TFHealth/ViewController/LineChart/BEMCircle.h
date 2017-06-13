//
//  BEMCircle.h
//  SimpleLineGraph
//
//  Created by Bobo on 12/27/13.
//  Copyright (c) 2013 Boris Emorine. All rights reserved.
//


#import <UIKit/UIKit.h>

/// Class to draw the cicrle for the points.
@interface BEMCircle : UIView
@property (nonatomic,strong) UIColor * bigRoundColor;
@property (nonatomic,strong) UIColor * smallRoundColor;
@property (nonatomic,strong) NSString * value;
@end