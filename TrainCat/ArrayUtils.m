//
//  ArrayUtils.m
//  TrainCat
//
//  Created by Alankar Misra on 01/04/13.
//
//

#import "ArrayUtils.h"
#import "NSMutableArray+Extension.h"

@implementation ArrayUtils

+(NSArray *)aiYesNoResponsesWithTrialCount:(uint)trialCount expectedAccuracyPercentage:(double)accuracyPercentage {
    NSMutableArray *responses = [[NSMutableArray alloc] initWithCapacity:trialCount];
    int correctResponses = floor(trialCount * accuracyPercentage);
    for(uint i=0; i<correctResponses; ++i) {
        responses[i] = [NSNumber numberWithBool:YES];
    }
    
    for(uint i=correctResponses; i<trialCount; ++i) {
        responses[i] = [NSNumber numberWithBool:NO];
    }
    
    [responses shuffle];
    
    return responses;
}


@end
