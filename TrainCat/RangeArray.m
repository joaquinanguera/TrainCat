//
//  Range.m
//  TrainCat
//
//  Created by Alankar Misra on 22/03/13.
//
//

#import "RangeArray.h"


@implementation RangeArray
{
    NSInteger start, count;
}

- (id) initWithRangeFrom:(NSInteger)firstValue to:(NSInteger)lastValue
{
    // should check firstValue < lastValue and take appropriate action if not
    if((self = [super init]))
    {
        start = firstValue;
        count = lastValue - firstValue + 1;
    }
    return self;
}

// to subclass NSArray only need to override count & objectAtIndex:

- (NSUInteger) count
{
    return count;
}

- (id)objectAtIndex:(NSUInteger)index
{
    if (index >= count)
        @throw [NSException exceptionWithName:NSRangeException reason:@"Index out of bounds" userInfo:nil];
    else
        return [NSNumber numberWithInteger:(start + index)];
}

@end
