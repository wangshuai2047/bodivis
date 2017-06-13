//
//  HealthStatusTableViewCell.m
//  TFHealth
//
//  Created by hzth hzth－mac2 on 6/8/14.
//  Copyright (c) 2014 studio37. All rights reserved.
//

#import "HealthStatusTableViewCell.h"
#import "AnalyseColorBar.h"

@implementation HealthStatusTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
    CGRect frame = self.colorBarView.frame;
    frame.origin.x = 0;
    frame.origin.y = 0;
    self.bar = [[AnalyseColorBar alloc]initWithFrame:frame];
    [self.colorBarView addSubview:self.bar];
//    NSArray* items=[NSArray arrayWithObjects:@"低",@"正常",@"高", nil];
    NSArray *items = [NSArray arrayWithObjects:CustomLocalizedString(@"labelLow", nil),CustomLocalizedString(@"labelNormal", nil),CustomLocalizedString(@"labelHigh", nil), nil];
    [self.bar setNoneValueStyle:true];
    [self.bar setItems:items];
}
#pragma mark - 这里设置彩色条的属性
-(void)setColorBarDetailsWithDescriptionStr:(NSString *)descriptionStr PropertyArray:(NSArray *)properties Level:(int)level
{
    //    self.bar.descriptionLabel.text = descriptionStr;
    //    self.bar.lowProperty.text = [properties objectAtIndex:0];
    //    self.bar.normalProperty.text = [properties objectAtIndex:1];
    //    self.bar.highProperty.text = [properties objectAtIndex:2];
    //    self.bar.downArrowImageView.image = [UIImage imageNamed:@"1_trangleDown"];
    //    [self.bar setLevel:level];
}

-(void)setColorBarDetail:(NSString*)testValue pMin:(NSString*)minValue pMax:(NSString*)maxValue pLevel:(int)level
{
    [self.bar setMaxValue:maxValue];
    [self.bar setMinValue:minValue];
    [self.bar setTestValue:testValue];
    [self.bar setLevel:level];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
