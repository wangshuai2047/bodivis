//
//  AnalyseColorBar.m
//  TFHealth
//
//  Created by nico on 14-7-25.
//  Copyright (c) 2014年 studio37. All rights reserved.
//

#import "AnalyseColorBar.h"
#define lowColor UIColorFromRGB(0xf0c759)
#define normalColor UIColorFromRGB(0x89e456)
#define highColor UIColorFromRGB(0xe84949)
#define Font 10
@interface AnalyseColorBar()
{
    NSArray* dItems;
    BOOL isNoneValue;
    float yOffset;
    NSArray* colors;
}
@end

@implementation AnalyseColorBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        isNoneValue = false;
        yOffset = 0;
        colors=[NSArray arrayWithObjects:UIColorFromRGB(0xf0c759),UIColorFromRGB(0x89e456),UIColorFromRGB(0xe84949),UIColorFromRGB(0x6349E9),UIColorFromRGB(0xE949DF),UIColorFromRGB(0x820000), nil];   
    }
    return self;
}

-(void)setColors:(NSArray*)color
{
    colors=color;
}

-(NSArray*)getColors
{
    return colors;
}

-(void)setLevel:(int) level
{
    int count = dItems.count;
    float width = (self.frame.size.width-4)/count;
    [self.downArrowImageView setFrame:CGRectMake(width*level+width/2-3, 35-yOffset, 6, 6)];
    [testValueProperty setFrame:CGRectMake(width*level+width/2-24, 8, 48, 24)];
}

-(void)setMinValue:(NSString*)value
{
    minValueProperty.text = value;
}

-(void)setMaxValue:(NSString*)value
{
    maxValueProperty.text = value;
}

-(void)setTestValue:(NSString*)value
{
    [testValueProperty setTitle:value forState:UIControlStateNormal];
}

-(void)setNoneValueStyle:(BOOL)isNone
{
    isNoneValue=isNone;
    yOffset=24;
}

-(void)setItems:(NSArray*)values
{
    for (UIView *view in self.subviews)
    {
        if ([view isKindOfClass:[UIView class]])
        {
            [view removeFromSuperview];
        }
    }
    dItems=values;
    if(values==nil || values.count==0)
    {
        return;
    }
    
    int count = values.count;
    float width = (self.frame.size.width-4)/count;
   
    testValueProperty = [[UIButton alloc] initWithFrame:CGRectMake(width+width/2-24, 8, 48, 24)];
    testValueProperty.titleLabel.textColor=[UIColor whiteColor];
    testValueProperty.titleLabel.font = [UIFont systemFontOfSize:12];
    [testValueProperty setBackgroundImage:[UIImage imageNamed:@"round_btn_normal"] forState:UIControlStateNormal];
    [testValueProperty setTitle:CustomLocalizedString(@"noData", nil) forState:UIControlStateNormal];
    testValueProperty.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    if(!isNoneValue)
    {
        [self addSubview:testValueProperty];
    }
    
    self.downArrowImageView = [[UIImageView alloc] initWithFrame:CGRectMake(width+width/2-3, 35-yOffset, 6, 6)];
    self.downArrowImageView.image = [UIImage imageNamed:@"1_trangleDown"];
    [self addSubview:self.downArrowImageView];
    
    minValueProperty = [[UILabel alloc]initWithFrame:CGRectMake(width/2+1, 42-yOffset, width, 12)];
    minValueProperty.textColor = [UIColor whiteColor];
    minValueProperty.font = [UIFont systemFontOfSize:12];
    minValueProperty.backgroundColor = [UIColor clearColor];
    minValueProperty.textAlignment = NSTextAlignmentCenter;
    minValueProperty.text=@"";
    [self addSubview:minValueProperty];
    
    maxValueProperty = [[UILabel alloc]initWithFrame:CGRectMake(width*1.5+2, 42-yOffset, width, 12)];
    maxValueProperty.textColor = [UIColor whiteColor];
    maxValueProperty.font = [UIFont systemFontOfSize:12];
    maxValueProperty.backgroundColor = [UIColor clearColor];
    maxValueProperty.textAlignment=NSTextAlignmentCenter;
    maxValueProperty.text=@"";
    [self addSubview:maxValueProperty];
    
    for (int i=0; i<count; i++)
    {
        //颜色横线
        UILabel* lbl =[[UILabel alloc]initWithFrame:CGRectMake(i*width+i*2, 57-yOffset,width, 3)];
        int colorIdx=i%colors.count;
        lbl.backgroundColor=[colors objectAtIndex:colorIdx];
        [self addSubview:lbl];
    }
    
    for(int i=0;i<count;i++)
    {
        double offset=i*width+i*2;
        if(count<=3)
        {
            offset=offset+width/2.0-10;
        }
         //肥胖一级二级三级等下部分显示小字
        UILabel* lbl = [[UILabel alloc]initWithFrame:CGRectMake(offset, 65-yOffset, width, 24)];
        lbl.numberOfLines = 0;
        lbl.textColor = [UIColor whiteColor];
        lbl.font = [UIFont systemFontOfSize:Font];
        lbl.backgroundColor = [UIColor clearColor];
        lbl.text=[values objectAtIndex:i];
        [self addSubview:lbl];
    }
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
