//
//  PaternerTableViewCell.m
//  TFHealth
//
//  Created by hzth hzth－mac2 on 6/9/14.
//  Copyright (c) 2014 studio37. All rights reserved.
//

#import "PaternerTableViewCell.h"

@implementation PaternerTableViewCell

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
    self.headView.layer.cornerRadius = self.headView.frame.size.width/2;
    self.headView.layer.borderWidth = 5;
    self.headView.layer.masksToBounds = YES;
    self.headView.layer.borderColor = UIColorFromRGB(0x343963).CGColor;
    
}
-(void)initHeadViewImage:(UIImage *)image
{
    self.headView.layer.cornerRadius = self.headView.frame.size.width/2;
    self.headView.layer.borderWidth = 5;
    self.headView.layer.masksToBounds = YES;
    self.headView.layer.borderColor = UIColorFromRGB(0x343963).CGColor;
    self.headView.layer.contents = (id)[image CGImage];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
