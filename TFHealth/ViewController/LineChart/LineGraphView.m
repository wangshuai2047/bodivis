//
//  LineGraphView.m
//  TFHealth
//
//  Created by hzth hzth－mac2 on 6/7/14.
//  Copyright (c) 2014 studio37. All rights reserved.
//

#import "LineGraphView.h"
#import "BEMSimpleLineGraphView.h"
@implementation LineGraphView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
-(id)initWithDictionary:(NSMutableDictionary*)dic AndFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
//        self.labelDates = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 40)];
//        self.labelDates.backgroundColor = [UIColor yellowColor];
//        
//        self.labelValues = [[UILabel alloc]initWithFrame:CGRectMake(100, 0, 100, 40)];
//        self.labelValues.backgroundColor = [UIColor greenColor];
//        [self addSubview:self.labelValues];
//        [self addSubview:self.labelDates];
        self.graph = [[BEMSimpleLineGraphView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        self.graph.enableTouchReport = NO;
        self.graph.colorTop = [dic objectForKey:@"colorTop"];
        self.graph.colorBottom = [dic objectForKey:@"colorBottom"];
        self.graph.colorLine = [dic objectForKey:@"colorLine"];
        self.graph.colorXaxisLabel = [dic objectForKey:@"colorXaxisLabel"];
        self.graph.colorVerticalLine = [dic objectForKey:@"colorVerticalLine"];
        self.graph.bigRoundColor = [dic objectForKey:@"bigRoundColor"];
        self.graph.smallRoundColor = [dic objectForKey:@"smallRoundColor"];
        self.graph.widthLine = [[dic objectForKey:@"widthLine"] floatValue];
        self.graph.barGraphWidth = 6;
        self.graph.barGraphColor = [dic objectForKey:@"barGraphColor"];;
        //    self.ArrayOfValues = (NSMutableArray*)[dic objectForKey:@"values"];
        //    self.ArrayOfDates = (NSMutableArray*)[dic objectForKey:@"dates"];
        self.ArrayOfValues = [[NSMutableArray alloc]init];
        self.ArrayOfDates = [[NSMutableArray alloc]init];
        self.ArrayOfDates = [dic valueForKey:@"dates"];
        self.ArrayOfValues = [dic valueForKey:@"values"];
        
        self.graph.delegate = self;
        [self addSubview:self.graph];
    }
    
    
    return self;
}

-(id)initWithDictionaryLine:(NSMutableDictionary*)dic AndFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.graph = [[BEMSimpleLineGraphView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        self.graph.enableTouchReport = NO;
        self.graph.colorTop = [dic objectForKey:@"colorTop"];
        self.graph.colorBottom = [dic objectForKey:@"colorBottom"];
        self.graph.colorLine = [dic objectForKey:@"colorLine"];
        self.graph.colorXaxisLabel = [dic objectForKey:@"colorXaxisLabel"];
        self.graph.colorVerticalLine = [dic objectForKey:@"colorVerticalLine"];
        self.graph.bigRoundColor = [dic objectForKey:@"bigRoundColor"];
        self.graph.smallRoundColor = [dic objectForKey:@"smallRoundColor"];
        self.graph.widthLine = [[dic objectForKey:@"widthLine"] floatValue];
        self.graph.barGraphWidth = 6;
        self.graph.barGraphColor = [dic objectForKey:@"barGraphColor"];
        self.ArrayOfValues = [[NSMutableArray alloc]init];
        self.ArrayOfDates = [[NSMutableArray alloc]init];
        self.ArrayOfDates = [dic valueForKey:@"dates"];
        self.ArrayOfValues = [dic valueForKey:@"values"];
        
        self.graph.delegate = self;
        [self addSubview:self.graph];
    }
    
    
    return self;
}

-(void)addLine:(NSArray *)valuesArray
{
    self.graph.addLineArray = valuesArray;
    
   // [self.graph addLine:valuesArray];
}

-(void)addWaterLine:(NSArray *)valuesArray
{
    self.graph.addWaterLineArray = valuesArray;
    
    // [self.graph addLine:valuesArray];
}

-(void)addMuscleLine:(NSArray *)valuesArray
{
    self.graph.addMuscleLineArray = valuesArray;
    
    // [self.graph addLine:valuesArray];
}


-(void)addLineOfOnly:(NSArray *)valuesArray
{
    self.graph.addLineArray = valuesArray;
    
    // [self.graph addLine:valuesArray];
}

#pragma mark - SimpleLineGraph Data Source

- (int)numberOfPointsInGraph {
    return (int)[self.ArrayOfValues count];
}

- (float)valueForIndex:(NSInteger)index {
    return [[self.ArrayOfValues objectAtIndex:index] floatValue];
}

#pragma mark - SimpleLineGraph Delegate

- (int)numberOfGapsBetweenLabels {
    return 0;
}

- (NSString *)labelOnXAxisForIndex:(NSInteger)index {
    return [self.ArrayOfDates objectAtIndex:index];
}

- (void)didTouchGraphWithClosestIndex:(int)index {
    
}

- (void)didReleaseGraphWithClosestIndex:(float)index {
        [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            self.labelValues.alpha = 0.0;
            self.labelDates.alpha = 0.0;
        } completion:^(BOOL finished){
    
            self.labelValues.text = [NSString stringWithFormat:@"11111"];
            self.labelDates.text = @"between 2000 and 2010";
    
            [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                self.labelValues.alpha = 1.0;
                self.labelDates.alpha = 1.0;
            } completion:nil];
        }];
    
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
