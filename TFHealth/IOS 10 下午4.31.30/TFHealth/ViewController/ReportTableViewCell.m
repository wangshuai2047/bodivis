//
//  ReportTableViewCell.m
//  TFHealth
//
//  Created by chenzq on 14-7-20.
//  Copyright (c) 2014年 studio37. All rights reserved.
//

#import "ReportTableViewCell.h"

@implementation ReportTableViewCell

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
    UIColor *borderColor = [UIColor colorWithRed:255.0 green:255.0 blue:255.0 alpha:0.2];
    _report_table_view.layer.masksToBounds = YES;
    _report_table_view.layer.cornerRadius = 6.0;
    _report_table_view.layer.borderWidth = 1.0;
    _report_table_view.layer.borderColor = [borderColor CGColor];
    _report_table_view.layer.backgroundColor=[borderColor CGColor];
    
    _chart_scroll_view.layer.masksToBounds = YES;
    _chart_scroll_view.layer.cornerRadius = 6.0;
    _chart_scroll_view.layer.borderWidth = 1.0;
    _chart_scroll_view.layer.borderColor = [borderColor CGColor];
    _chart_scroll_view.layer.backgroundColor=[borderColor CGColor];
    
    _dot1.layer.masksToBounds = YES;
    _dot1.layer.cornerRadius = 8.0;
    _dot1.layer.borderWidth = 1.0;
    _dot1.layer.borderColor = [UIColor colorWithRed:192.0/255.0 green:255.0/255.0 blue:140.0/255.0 alpha:1].CGColor;
    _dot1.layer.backgroundColor=[UIColor colorWithRed:192.0/255.0 green:255.0/255.0 blue:140.0/255.0 alpha:1].CGColor;
    
    _dot2.layer.masksToBounds = YES;
    _dot2.layer.cornerRadius = 8.0;
    _dot2.layer.borderWidth = 1.0;
    _dot2.layer.borderColor = [UIColor colorWithRed:255.0/255.0 green:247.0/255.0 blue:140.0/255.0 alpha:1].CGColor;
    _dot2.layer.backgroundColor=[UIColor colorWithRed:255.0/255.0 green:247.0/255.0 blue:140.0/255.0 alpha:1].CGColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    //[super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
