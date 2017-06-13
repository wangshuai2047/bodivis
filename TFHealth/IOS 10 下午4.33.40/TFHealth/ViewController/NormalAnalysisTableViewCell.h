//
//  NormalAnalysisTableViewCell.h
//  TFHealth
//
//  Created by hzth hzth－mac2 on 6/12/14.
//  Copyright (c) 2014 studio37. All rights reserved.
//

#import <UIKit/UIKit.h>
 enum{
 LevelButtonTypeLow,
 LevelButtonTypeNormal,
 LevelButtonTypeHigh
 }LevelButtonType;
@protocol NormalAnalysisCellDelegate <NSObject>

-(void)NormalAnalysisCellTitleButtonClick:(UITableViewCell*)cell;

@end
 @interface NormalAnalysisTableViewCell : UITableViewCell
 @property (weak, nonatomic) IBOutlet UIButton *titleButton;
 @property (weak, nonatomic) IBOutlet UILabel *numLabel;
 @property (weak, nonatomic) IBOutlet UILabel *unitLabel;
 @property (weak, nonatomic) IBOutlet UIButton *levelButton;
@property (weak, nonatomic) id<NormalAnalysisCellDelegate>delegate;

 @end