//
//  BEMCircle.m
//  SimpleLineGraph
//
//  Created by Bobo on 12/27/13.
//  Copyright (c) 2013 Boris Emorine. All rights reserved.
//

#import "BEMCircle.h"

@implementation BEMCircle

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextAddEllipseInRect(ctx, rect);
    [self.bigRoundColor set];
    CGContextFillPath(ctx);
    
    CGContextRef ctx1 = UIGraphicsGetCurrentContext();
    CGContextAddEllipseInRect(ctx1, CGRectMake(3, 3, 8, 8));
    [self.smallRoundColor set];
    CGContextFillPath(ctx1);
}

@end