//
//  NormalAnalysisTableViewCell.m
//  TFHealth
//
//  Created by hzth hzth－mac2 on 6/12/14.
//  Copyright (c) 2014 studio37. All rights reserved.
//

#import "NormalAnalysisTableViewCell.h"

@implementation NormalAnalysisTableViewCell
- (IBAction)titleButtonClick:(id)sender {
    UIButton * button = (UIButton *)sender;
    //NSIndexPath * indPath = [NSIndexPath indexPathForRow:button.tag%1000 inSection:button.tag/1000];
    [self.delegate NormalAnalysisCellTitleButtonClick:self];
}

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
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
