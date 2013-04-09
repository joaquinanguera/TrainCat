//
//  LineChartView.m
//  TrainCat
//
//  Created by Alankar Misra on 07/04/13.
//
//

#import "ParticipantPerformanceStatsChartView.h"
#import "PCLineChartView.h"

#define kParticipantPerformanceStatsChartViewMinValue 5
#define kParticipantPerformanceStatsChartViewMaxValue 10
#define kParticipantPerformanceStatsChartViewInterval 1
#define kParticipantPerformanceStatsChartViewTitle @"Level"

@implementation ParticipantPerformanceStatsChartView

-(void)chartWithPoints:(NSArray *)points {
    if(self.subviews.count) {
        [[self subviews][0] removeFromSuperview];
    }
    
    PCLineChartView *chart = [[PCLineChartView alloc] initWithFrame:CGRectMake(0,0,self.frame.size.width,self.frame.size.height)];
    chart.minValue = kParticipantPerformanceStatsChartViewMinValue;
    chart.maxValue = kParticipantPerformanceStatsChartViewMaxValue;
    chart.interval = kParticipantPerformanceStatsChartViewInterval;

    PCLineChartViewComponent *component = [[PCLineChartViewComponent alloc] init];
    component.labelFormat = @"%.1f";
    [component setTitle:kParticipantPerformanceStatsChartViewTitle];

    [component setPoints:points];
    [component setShouldLabelValues:YES];
    [component setColour:[UIColor colorWithRed:112.0/255 green:179.0/255 blue:71.0/255 alpha:255.0]];
    
    NSMutableArray *components = [[NSMutableArray alloc] initWithObjects:component, nil];
    [chart setComponents:components];
    
    NSMutableArray *xLabels = [[NSMutableArray alloc] initWithCapacity:points.count];
    for(NSUInteger i=0; i<points.count; ++i) {
        [xLabels addObject:@(i+1)];
    }
    [chart setXLabels:xLabels];
    [self addSubview:chart];
}

@end
