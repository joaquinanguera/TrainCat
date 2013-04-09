//
//  ArrayUtils.h
//  TrainCat
//
//  Created by Alankar Misra on 01/04/13.
//
//

#import <Foundation/Foundation.h>

@interface ArrayUtils : NSObject

+(NSArray *)randomBooleansWithCount:(NSUInteger)trialCount biasForTrue:(double)accuracyPercentage;

@end
