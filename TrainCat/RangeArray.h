//
//  Range.h
//  TrainCat
//
//  Created by Alankar Misra on 22/03/13.
//  Reference: http://stackoverflow.com/questions/11792883/continuous-numbers-in-objective-c-array-like-range-in-python
//

#import <Foundation/Foundation.h>

@interface RangeArray : NSArray

- (id) initWithRangeFrom:(NSInteger)firstValue to:(NSInteger)lastValue;
- (NSNumber *)objectAtIndex:(NSUInteger)index;
- (NSUInteger) count;

@end
