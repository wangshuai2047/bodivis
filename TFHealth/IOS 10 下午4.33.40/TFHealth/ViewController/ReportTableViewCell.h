//
//  ReportTableViewCell.h
//  TFHealth
//
//  Created by chenzq on 14-7-20.
//  Copyright (c) 2014年 studio37. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReportTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *report_table_view;
@property (weak, nonatomic) IBOutlet UILabel *report_title;
@property (weak, nonatomic) IBOutlet UIView *chart_view;
@property (weak, nonatomic) IBOutlet UILabel *sport_desc;
@property (weak, nonatomic) IBOutlet UILabel *food_desc;
@property (weak, nonatomic) IBOutlet UIScrollView *chart_scroll_view;
@property (weak, nonatomic) IBOutlet UILabel *comp_title;
@property (weak, nonatomic) IBOutlet UIView *sport_container;
@property (weak, nonatomic) IBOutlet UIView *dot1;
@property (weak, nonatomic) IBOutlet UIView *dot2;
@end
