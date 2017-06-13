//
//  BEMSimpleLineGraphView.m
//  SimpleLineGraph
//
//  Created by Bobo on 12/27/13.
//  Copyright (c) 2013 Boris Emorine. All rights reserved.
//

#define circleSize 14
#define labelXaxisOffset 10
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

#import "BEMSimpleLineGraphView.h"

@implementation BEMSimpleLineGraphView

int numberOfPoints; // The number of Points in the Graph.
BEMCircle *closestDot;

int currentlyCloser;

- (void)reloadGraph {
    [self setNeedsLayout];
}

- (void)commonInit {
    // Do not make any calls to "self" in this method. During this point self is unstable and will return nil. That is why ivars are used below.
    
    // Do any initialization that's common to both -initWithFrame: and -initWithCoder: in this method
    _labelFont = [UIFont fontWithName:@"HelveticaNeue-Light" size:13];
    
    // DEFAULT VALUES
    _animationGraphEntranceSpeed = 5;
    _colorXaxisLabel = [UIColor blackColor];
    
    // Set the bottom color to the window's tint color (if no color is set)
    UIWindow *window = [[[UIApplication sharedApplication] windows] objectAtIndex:0];
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) _colorBottom = window.tintColor;
    else _colorBottom = [UIColor colorWithRed:0.0/255.0 green:191.0/255.0 blue:243.0/255.0 alpha:0.2];
    
    _colorTop = [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:0.0];
    _colorLine = [UIColor colorWithRed:0.0/255.0 green:191.0/255.0 blue:243.0/255.0 alpha:1];
    _alphaTop = 1.0;
    _alphaBottom = 1.0;
    _alphaLine = 1.0;
    _widthLine = 1.0;
    _enableTouchReport = NO;
    
    self.ArrayOfColors = [NSMutableArray arrayWithCapacity:4];
    [self.ArrayOfColors addObject:[UIColor colorWithRed:192.0/255.0 green:255.0/255.0 blue:140.0/255.0 alpha:1]];
    [self.ArrayOfColors addObject:[UIColor colorWithRed:255.0/255.0 green:247.0/255.0 blue:140.0/255.0 alpha:1]];
    [self.ArrayOfColors addObject:[UIColor colorWithRed:255.0/255.0 green:208.0/255.0 blue:140.0/255.0 alpha:1]];
    [self.ArrayOfColors addObject:[UIColor colorWithRed:140.0/255.0 green:234.0/255.0 blue:255.0/255.0 alpha:1]];
    
}

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        [self commonInit];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)coder {
    if ((self = [super initWithCoder:coder])) {
        [self commonInit];
    }
    return self;
}

- (void)layoutSubviews {
    
    
    numberOfPoints = [self.delegate numberOfPointsInGraph]; // The number of Points in the Graph.
    
    self.animationDelegate = [[BEMAnimations alloc] init];
    self.animationDelegate.delegate = self;
    
    [self drawGraph];
    [self drawXAxis];
    
    if (self.addLineArray.count) {
        [self addLine:self.addLineArray lineColor:[self.ArrayOfColors objectAtIndex:1]];
    }
    if (self.addWaterLineArray.count) {
        [self addLine:self.addWaterLineArray lineColor:[self.ArrayOfColors objectAtIndex:2]];
    }
    if (self.addMuscleLineArray.count) {
        [self addLine:self.addMuscleLineArray lineColor:[self.ArrayOfColors objectAtIndex:3]];
    }

    if (self.enableTouchReport == YES) {
        // Initialize the vertical gray line that appears where the user touches the graph.
        //        self.verticalLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, self.viewForBaselineLayout.frame.size.height)];
        //        self.verticalLine.backgroundColor = [UIColor redColor];
        //        self.verticalLine.alpha = 0;
        //        [self addSubview:self.verticalLine];
        
        UIView * chartView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 5, self.viewForBaselineLayout.frame.size.height)];
        chartView.backgroundColor = [UIColor redColor];
        [self addSubview:chartView];
        
        UIView *panView = [[UIView alloc] initWithFrame:CGRectMake(10, 10, self.viewForBaselineLayout.frame.size.width, self.viewForBaselineLayout.frame.size.height)];
        panView.backgroundColor = [UIColor clearColor];
        [self.viewForBaselineLayout addSubview:panView];
        
        UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
        panGesture.delegate = self;
        [panGesture setMaximumNumberOfTouches:1];
        [panView addGestureRecognizer:panGesture];
    }
    
    self.bubbleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.bubbleButton.backgroundColor=COLOR(255,112,57,1);
    self.bubbleButton.frame = CGRectMake(0, 0, 45, 20);
    self.bubbleButton.layer.masksToBounds = YES;
    self.bubbleButton.layer.cornerRadius = 6.0;
    self.bubbleButton.hidden=true;
    self.bubbleButton.titleLabel.font = [UIFont systemFontOfSize:11];
    self.bubbleButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.bubbleButton];
}
-(void)addLine:(NSArray*)valuesArray lineColor:(UIColor*)lineColor
{
    //valuesArray = [NSArray arrayWithObjects:@"200",@"1000",@"40000",@"10",@"11111",@"11123",@"43532",nil];
    float maxValue = [self maxValue]; // Biggest Y-axis value from all the points.
    float minValue = [self minValue]; // Smallest Y-axis value from all the points.
    
    float positionOnXAxis; // The position on the X-axis of the point currently being created.
    float positionOnYAxis; // The position on the Y-axis of the point currently being created.
    
    for (int i = 0; i < numberOfPoints; i++) {
        
        float dotValue = [[valuesArray objectAtIndex:i] floatValue];
        float tmp =1;
        if (maxValue - minValue>0) {
            tmp=maxValue - minValue;
        }
        positionOnXAxis = (self.viewForBaselineLayout.frame.size.width/(numberOfPoints - 1))*i;
        positionOnYAxis = (self.viewForBaselineLayout.frame.size.height - 80) - ((dotValue - minValue) / (tmp/ (self.viewForBaselineLayout.frame.size.height - 80))) + 20;
        
        BEMCircle *circleDot = [[BEMCircle alloc] initWithFrame:CGRectMake(0, 0, circleSize, circleSize)];
        circleDot.center = CGPointMake(positionOnXAxis, positionOnYAxis);
        circleDot.tag = i+100;
        circleDot.alpha = 0;
        circleDot.value = [NSString stringWithFormat:@"%f",dotValue];
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dotClick:)];
        [circleDot addGestureRecognizer:tap];
        circleDot.bigRoundColor = lineColor;
        circleDot.smallRoundColor = self.smallRoundColor;
        self.verticalLine = [[UIView alloc]initWithFrame:CGRectMake(positionOnXAxis, 0, 0.5, self.frame.size.height-20)];
        self.verticalLine.backgroundColor = self.colorVerticalLine;
        [self addSubview:self.verticalLine];
        
        self.barGraph = [[UIView alloc]initWithFrame:CGRectMake(positionOnXAxis-self.barGraphWidth/2, positionOnYAxis+10, self.barGraphWidth, self.frame.size.height-positionOnYAxis-30)];
        self.barGraph.layer.cornerRadius = 3;
        self.barGraph.backgroundColor = self.barGraphColor;
        [self addSubview:self.barGraph];
        [self addSubview:circleDot];
        [self.animationDelegate animationForDot:i circleDot:circleDot animationSpeed:self.animationGraphEntranceSpeed];
    }
    
    // CREATION OF THE LINE AND BOTTOM AND TOP FILL
    
    float xDot1; // Postion on the X-axis of the first dot.
    float yDot1; // Postion on the Y-axis of the first dot.
    float xDot2; // Postion on the X-axis of the next dot.
    float yDot2; // Postion on the Y-axis of the next dot.
    
    //    for (UIView *subview in [self subviews]) {
    //        if ([subview isKindOfClass:[BEMLine class]])
    //            [subview removeFromSuperview];
    //    }
    
    for (int i = 0; i < numberOfPoints - 1; i++) {
        
        for (UIView *dot in [self.viewForBaselineLayout subviews]) {
            if (dot.tag == i + 100)  {
                xDot1 = dot.center.x;
                yDot1 = dot.center.y;
            } else if (dot.tag == i + 101) {
                xDot2 = dot.center.x;
                yDot2 = dot.center.y;
            }
        }
        
        BEMLine *line = [[BEMLine alloc] initWithFrame:CGRectMake(0, 0, self.viewForBaselineLayout.frame.size.width, self.viewForBaselineLayout.frame.size.height)];
        line.opaque = NO;
        line.tag = i + 1000;
        line.alpha = 0;
        line.backgroundColor = [UIColor clearColor];
        line.firstPoint = CGPointMake(xDot1, yDot1);
        line.secondPoint = CGPointMake(xDot2, yDot2);
        line.topColor = [UIColor clearColor];
        line.bottomColor = [UIColor clearColor];
        line.color = lineColor;
        line.topAlpha = 0;
        line.bottomAlpha = self.alphaBottom;
        line.lineAlpha = self.alphaLine;
        line.lineWidth = self.widthLine;
        
        [self addSubview:line];
        [self sendSubviewToBack:line];
        [self sendSubviewToBack:self.barGraph];
        [self.animationDelegate animationForLine:i line:line animationSpeed:self.animationGraphEntranceSpeed];
    }
}

- (void)drawGraph {
    // CREATION OF THE DOTS
    
    float maxValue = [self maxValue]; // Biggest Y-axis value from all the points.
    float minValue = [self minValue]; // Smallest Y-axis value from all the points.
    
    float positionOnXAxis; // The position on the X-axis of the point currently being created.
    float positionOnYAxis; // The position on the Y-axis of the point currently being created.
    
    for (UIView *subview in [self subviews]) {
        if ([subview isKindOfClass:[BEMCircle class]])
            [subview removeFromSuperview];
    }
    
    for (int i = 0; i < numberOfPoints; i++) {
        
        float dotValue = [self.delegate valueForIndex:i];
        float tmp = 1;
        if ((maxValue - minValue)>0) {
            tmp=(maxValue - minValue);
        }
        positionOnXAxis = (self.viewForBaselineLayout.frame.size.width/(numberOfPoints - 1))*i;
        positionOnYAxis = (self.viewForBaselineLayout.frame.size.height - 80) - ((dotValue - minValue) / (tmp / (self.viewForBaselineLayout.frame.size.height - 80))) + 20;
        
        BEMCircle *circleDot = [[BEMCircle alloc] initWithFrame:CGRectMake(0, 0, circleSize, circleSize)];
        circleDot.center = CGPointMake(positionOnXAxis, positionOnYAxis);
        circleDot.tag = i+100;
        circleDot.alpha = 0;
        circleDot.bigRoundColor = [self.ArrayOfColors objectAtIndex:0];
        circleDot.smallRoundColor = self.smallRoundColor;
        circleDot.value = [NSString stringWithFormat:@"%f",dotValue];
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dotClick:)];
        [circleDot addGestureRecognizer:tap];
        
        self.verticalLine = [[UIView alloc]initWithFrame:CGRectMake(positionOnXAxis, 0, 0.5, self.frame.size.height-20)];
        self.verticalLine.backgroundColor = self.colorVerticalLine;
        [self addSubview:self.verticalLine];
        
        self.barGraph = [[UIView alloc]initWithFrame:CGRectMake(positionOnXAxis-self.barGraphWidth/2, positionOnYAxis+10, self.barGraphWidth, self.frame.size.height-positionOnYAxis-30)];
        self.barGraph.layer.cornerRadius = 3;
        self.barGraph.backgroundColor = self.barGraphColor;
        [self addSubview:self.barGraph];
        [self addSubview:circleDot];
        [self sendSubviewToBack:self.barGraph];
        [self.animationDelegate animationForDot:i circleDot:circleDot animationSpeed:self.animationGraphEntranceSpeed];
    }
    
    // CREATION OF THE LINE AND BOTTOM AND TOP FILL
    
    float xDot1; // Postion on the X-axis of the first dot.
    float yDot1; // Postion on the Y-axis of the first dot.
    float xDot2; // Postion on the X-axis of the next dot.
    float yDot2; // Postion on the Y-axis of the next dot.
    
    for (UIView *subview in [self subviews]) {
        if ([subview isKindOfClass:[BEMLine class]])
            [subview removeFromSuperview];
    }
    
    for (int i = 0; i < numberOfPoints - 1; i++) {
        
        for (UIView *dot in [self.viewForBaselineLayout subviews]) {
            if (dot.tag == i + 100)  {
                xDot1 = dot.center.x;
                yDot1 = dot.center.y;
            } else if (dot.tag == i + 101) {
                xDot2 = dot.center.x;
                yDot2 = dot.center.y;
            }
        }
        
        BEMLine *line = [[BEMLine alloc] initWithFrame:CGRectMake(0, 0, self.viewForBaselineLayout.frame.size.width, self.viewForBaselineLayout.frame.size.height)];
        line.opaque = NO;
        line.tag = i + 1000;
        line.alpha = 0;
        line.backgroundColor = [UIColor clearColor];
        line.firstPoint = CGPointMake(xDot1, yDot1);
        line.secondPoint = CGPointMake(xDot2, yDot2);
        line.topColor = self.colorTop;
        line.bottomColor = self.colorBottom;
        line.color = [self.ArrayOfColors objectAtIndex:0];
        line.topAlpha = self.alphaTop;
        line.bottomAlpha = self.alphaBottom;
        line.lineAlpha = self.alphaLine;
        line.lineWidth = self.widthLine;
        
        [self addSubview:line];
        [self sendSubviewToBack:line];
        
        [self.animationDelegate animationForLine:i line:line animationSpeed:self.animationGraphEntranceSpeed];
    }
    NSArray * valuesArray1 = [NSArray arrayWithObjects:@"200",@"1000",@"40000",@"10",@"11111",@"11123",@"43532",nil];
    //[self addLine:valuesArray1];
    
}
-(void)dotClick:(UITapGestureRecognizer*)tap
{
    BEMCircle * dot = (BEMCircle*)tap.view;
    NSLog(@"%d",[dot.value intValue]);
    [self.bubbleButton setTitle:[NSString stringWithFormat:@"%.1f",[dot.value floatValue]] forState:UIControlStateNormal];
    CGPoint originPoint = dot.frame.origin;
    originPoint.y -= 10;
    self.bubbleButton.center = originPoint;
    self.bubbleButton.hidden=false;
}
- (void)handlePan:(UIPanGestureRecognizer *)recognizer {
    CGPoint translation = [recognizer locationInView:self.viewForBaselineLayout];
    
    self.verticalLine.frame = CGRectMake(translation.x, 0, 1, self.viewForBaselineLayout.frame.size.height);
    self.verticalLine.backgroundColor = [UIColor redColor];
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.verticalLine.alpha = 0.2;
    } completion:nil];
    
    closestDot = [self closestDotFromVerticalLine:self.verticalLine];
    closestDot.alpha = 0.8;
    
    if (closestDot.tag > 99 && closestDot.tag < 1000) {
        if ([self.delegate respondsToSelector:@selector(didTouchGraphWithClosestIndex:)])  [self.delegate didTouchGraphWithClosestIndex:((int)closestDot.tag - 100)];
    }
    
    // ON RELEASE
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        if ([self.delegate respondsToSelector:@selector(didReleaseGraphWithClosestIndex:)]) [self.delegate didReleaseGraphWithClosestIndex:(closestDot.tag - 100)];
        
        [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            closestDot.alpha = 0;
            self.verticalLine.alpha = 0;
        } completion:nil];
    }
}

// Find which dot is currently the closest to the vertical line
- (BEMCircle *)closestDotFromVerticalLine:(UIView *)verticalLine {
    currentlyCloser = 1000;
    
    for (BEMCircle *dot in self.subviews) {
        
        if (dot.tag > 99 && dot.tag < 1000) {
            
            [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                dot.alpha = 0;
            } completion:nil];
            
            if (pow(((dot.center.x) - verticalLine.frame.origin.x), 2) < currentlyCloser) {
                currentlyCloser = pow(((dot.center.x) - verticalLine.frame.origin.x), 2);
                closestDot = dot;
            }
        }
    }
    
    return closestDot;
}

// Determines the biggest Y-axis value from all the points.
- (float)maxValue {
    float dotValue;
    float maxValue = 0;
    
    for (int i = 0; i < numberOfPoints; i++) {
        dotValue = [self.delegate valueForIndex:i];
        
        if (dotValue > maxValue) {
            maxValue = dotValue;
        }
    }
    
    return maxValue;
}

// Determines the smallest Y-axis value from all the points.
- (float)minValue {
    float dotValue;
    float minValue = INFINITY;
    
    for (int i = 0; i < numberOfPoints; i++) {
        dotValue = [self.delegate valueForIndex:i];
        
        if (dotValue < minValue) {
            minValue = dotValue;
        }
    }
    
    return minValue;
}

- (void)drawXAxis {
    if (![self.delegate respondsToSelector:@selector(numberOfGapsBetweenLabels)]) return;
    
    for (UIView *subview in [self subviews]) {
        if ([subview isKindOfClass:[UILabel class]])
            [subview removeFromSuperview];
    }
    
    int numberOfGaps = [self.delegate numberOfGapsBetweenLabels] + 1;
    
    if (numberOfGaps >= (numberOfPoints - 1)) {
        UILabel *firstLabel = [[UILabel alloc] initWithFrame:CGRectMake(3, self.frame.size.height - (labelXaxisOffset + 10), self.frame.size.width/2, 20)];
        firstLabel.text = [self.delegate labelOnXAxisForIndex:0];
        firstLabel.font = self.labelFont;
        firstLabel.textAlignment = 0;
        firstLabel.textColor = self.colorXaxisLabel;
        firstLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:firstLabel];
        
        UILabel *lastLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width/2 - 3, self.frame.size.height - (labelXaxisOffset + 10), self.frame.size.width/2, 20)];
        lastLabel.text = [self.delegate labelOnXAxisForIndex:(numberOfPoints - 1)];
        lastLabel.font = self.labelFont;
        lastLabel.textAlignment = 2;
        lastLabel.textColor = self.colorXaxisLabel;
        lastLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:lastLabel];
    } else {
        for (int i = 1; i <= (numberOfPoints/numberOfGaps); i++) {
            UILabel *labelXAxis = [[UILabel alloc] init];
            labelXAxis.text = [self.delegate labelOnXAxisForIndex:(i * numberOfGaps - 1)];
            [labelXAxis sizeToFit];
            [labelXAxis setCenter:CGPointMake((self.viewForBaselineLayout.frame.size.width/(numberOfPoints-1))*(i*numberOfGaps - 1), self.frame.size.height - labelXaxisOffset)];
            labelXAxis.font = self.labelFont;
            labelXAxis.textAlignment = 1;
            labelXAxis.textColor = self.colorXaxisLabel;
            labelXAxis.backgroundColor = [UIColor clearColor];
            [self addSubview:labelXAxis];
        }
    }
}

@end