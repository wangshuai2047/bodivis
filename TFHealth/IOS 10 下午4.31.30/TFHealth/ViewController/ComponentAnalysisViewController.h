//
//  ComponentAnalysisViewController.h
//  TFHealth
//
//  Created by hzth hzth－mac2 on 6/12/14.
//  Copyright (c) 2014 studio37. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AnalyseDetailData : NSObject

@property (retain,nonatomic) NSNumber* minValue;
@property (retain,nonatomic) NSNumber* maxValue;
@property (retain,nonatomic) NSNumber* testValue;
@property (retain,nonatomic) NSString* testStringValue;
@property (retain,nonatomic) NSString* description;
@property (retain,nonatomic) NSString* unit;
@property (assign,nonatomic) int level;
@property (retain,nonatomic) NSString* title;
@property (retain,nonatomic) NSString* levelTitle;
@property (retain,nonatomic) NSArray* displayItems;

@end

@interface ComponentAnalysisViewController : UIViewController
{
}

-(void)loadData;

-(NSString*)getDescription:(NSString*)title pMin:(NSNumber*)min pMax:(NSNumber*)max pValue:(NSNumber*)value;

-(AnalyseDetailData*)getDefaultData:(NSString*)title pUnit:(NSString*)unit;

-(int)getDataLevel:(NSNumber*)value pMin:(NSNumber*)min pMax:(NSNumber*)max;

-(NSString*)getLevelTitle:(int)level;

-(void)addData:(AnalyseDetailData*)data;

@end

