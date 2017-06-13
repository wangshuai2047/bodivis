//
//  ColorBar.m
//  TFHealth
//
//  Created by hzth hzth－mac2 on 6/8/14.
//  Copyright (c) 2014 studio37. All rights reserved.
//

#import "ColorBar.h"
#define lowColor UIColorFromRGB(0xf0c759)
#define normalColor UIColorFromRGB(0x89e456)
#define highColor UIColorFromRGB(0xe84949)
@implementation ColorBar
#define Font 10
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.descriptionLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, 12)];
        self.descriptionLabel.textColor = [UIColor whiteColor];
        self.descriptionLabel.backgroundColor = [UIColor clearColor];
        self.descriptionLabel.font = [UIFont systemFontOfSize:12];
        [self addSubview:self.descriptionLabel];
        
        self.downArrowImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 28, 10, 6)];
        [self addSubview:self.downArrowImageView];

        
        float width = (frame.size.width-4)/3;
        UILabel * lowLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 40,width, 3)];
        lowLabel.backgroundColor = lowColor;
        
        [self addSubview:lowLabel];
        
        UILabel * normalLabel = [[UILabel alloc]initWithFrame:CGRectMake(width+2, 40, width, 3)];
        normalLabel.backgroundColor = normalColor;
        [self addSubview:normalLabel];
        
        UILabel * highLabel = [[UILabel alloc]initWithFrame:CGRectMake(width*2+4, 40, width, 3)];
        highLabel.backgroundColor = highColor;
        [self addSubview:highLabel];
        
        self.lowProperty = [[UILabel alloc]initWithFrame:CGRectMake(0, 48, width, 12)];
        self.lowProperty.textColor = [UIColor whiteColor];
        self.lowProperty.font = [UIFont systemFontOfSize:Font];
        self.lowProperty.backgroundColor = [UIColor clearColor];
        [self addSubview:self.lowProperty];
        
        self.normalProperty = [[UILabel alloc]initWithFrame:CGRectMake(width*1+2, 48, width, 12)];
        self.normalProperty.font = [UIFont systemFontOfSize:Font];
        self.normalProperty.textAlignment = NSTextAlignmentCenter;
        self.normalProperty.textColor = [UIColor whiteColor];
        self.normalProperty.backgroundColor = [UIColor clearColor];
        [self addSubview:self.normalProperty];
        
        self.highProperty = [[UILabel alloc]initWithFrame:CGRectMake(width*2+4, 48, width, 12)];
        self.highProperty.textColor = [UIColor whiteColor];
        self.highProperty.font = [UIFont systemFontOfSize:Font];
        self.highProperty.textAlignment = NSTextAlignmentRight;
        self.highProperty.backgroundColor = [UIColor clearColor];
        [self addSubview:self.highProperty];
        
    }
    return self;
}

-(void)setLevel:(int) level
{
    float width = (self.frame.size.width-4)/3;
    float left =level*width+width/2-2;
   
    [self.downArrowImageView setFrame:CGRectMake(left, 28, 10, 6)];
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
