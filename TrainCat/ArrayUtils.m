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

+(NSArray *)randomBooleansWithCount:(uint)trialCount biasForTrue:(double)accuracyPercentage {
    NSMutableArray *responses = [[NSMutableArray alloc] initWithCapacity:trialCount];
    NSInteger correctResponses = floor(trialCount * accuracyPercentage);
    for(NSUInteger i=0; i<correctResponses; ++i) {
        responses[i] = @YES;
    }
    
    for(NSUInteger i=correctResponses; i<trialCount; ++i) {
        responses[i] = @NO;
    }
    
    [responses shuffle];
    
    return responses;
}


@end
