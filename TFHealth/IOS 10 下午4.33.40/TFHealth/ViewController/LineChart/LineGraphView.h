//
//  LineGraphView.h
//  TFHealth
//
//  Created by hzth hzth－mac2 on 6/7/14.
//  Copyright (c) 2014 studio37. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BEMSimpleLineGraphView.h"

@interface LineGraphView : UIView<BEMSimpleLineGraphDelegate>
@property (strong, nonatomic) NSMutableArray *ArrayOfValues;
@property (strong, nonatomic) NSMutableArray *ArrayOfDates;
@property (strong,nonatomic) UILabel *labelValues;
@property (strong,nonatomic) UILabel *labelDates;
@property (strong, nonatomic) BEMSimpleLineGraphView * graph;
-(id)initWithDictionary:(NSMutableDictionary*)dic AndFrame:(CGRect)frame;
-(id)initWithDictionaryLine:(NSMutableDictionary*)dic AndFrame:(CGRect)frame;

-(void)addLine:(NSArray *)valuesArray;
-(void)addWaterLine:(NSArray *)valuesArray;
-(void)addMuscleLine:(NSArray *)valuesArray;
-(void)addLineOfOnly:(NSArray *)valuesArray;
@end
