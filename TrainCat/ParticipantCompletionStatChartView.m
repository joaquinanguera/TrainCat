//
//  PieChartView.m
//  TrainCat
//
//  Created by Alankar Misra on 07/04/13.
//
//

#import "ParticipantCompletionStatChartView.h"
#import "PCPieChart.h"
#import "Constants.h"
#import "Participant+Extension.h"

@interface ParticipantCompletionStatChartView()
@property (nonatomic, strong) UIView *chart;
@end

@implementation ParticipantCompletionStatChartView

-(void)chartWithCompletionStat:(double)completionStat {
    if(self.subviews.count) {
        [[self subviews][0] removeFromSuperview];
    }
    
    PCPieChart *pieChart = [[PCPieChart alloc] initWithFrame:self.frame];
    pieChart.sameColorLabel = NO;
    [pieChart setDiameter:self.frame.size.width/2.5];
    
    pieChart.titleFont = [UIFont fontWithName:kGameTextFont size:20];
    pieChart.percentageFont = [UIFont fontWithName:kGameTextFont size:30];
    
    NSMutableArray *components = [NSMutableArray array];
    
    if(fabs(0.0 - completionStat) > 0.001) { // not 0%
        // Complete
        PCPieComponent *completedComponent = [PCPieComponent pieComponentWithTitle:@"Completed" value:completionStat];
        [completedComponent setColour:[UIColor colorWithRed:112.0/255 green:179.0/255 blue:71.0/255 alpha:255.0]];
        [components addObject:completedComponent];
    }
    
    if(fabs(100.0 - completionStat) > 0.001) { // not 100%
        // Pending
        PCPieComponent *pendingComponent = [PCPieComponent pieComponentWithTitle:@"Pending" value:1.0-completionStat];
        [pendingComponent setColour:[UIColor colorWithRed:253.0/255 green:124.0/255 blue:50.0/255 alpha:255.0]];
        [components addObject:pendingComponent];
    }
    
    [pieChart setComponents:components];
    [self addSubview:pieChart];
}


@end
