//
//  AnalysisDetailTableViewCell.m
//  TFHealth
//
//  Created by hzth hzth－mac2 on 6/15/14.
//  Copyright (c) 2014 studio37. All rights reserved.
//

#import "AnalysisDetailTableViewCell.h"
#import "AnalyseColorBar.h"

@implementation AnalysisDetailTableViewCell


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
    CGRect frame = self.colorbarView.frame;
    frame.origin.x = 0;
    frame.origin.y = 0;
    self.bar = [[AnalyseColorBar alloc]initWithFrame:frame];
    [self.colorbarView addSubview:self.bar];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
