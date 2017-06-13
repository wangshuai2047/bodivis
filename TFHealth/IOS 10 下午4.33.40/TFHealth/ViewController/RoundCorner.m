//
//  RoundCorner.m
//  TFHealth
//
//  Created by hzth hzth－mac2 on 6/15/14.
//  Copyright (c) 2014 studio37. All rights reserved.
//

#import "RoundCorner.h"

@implementation RoundCorner

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.layer.cornerRadius = 3;
    }
    return self;
}
-(void)awakeFromNib
{
    self.layer.cornerRadius = 4;
    self.layer.borderColor = [UIColor colorWithRed:187 green:169 blue:196 alpha:0.2].CGColor;
    self.layer.borderWidth = 1;
    self.layer.backgroundColor = [UIColor colorWithRed:218 green:218 blue:218 alpha:0.2].CGColor;
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
