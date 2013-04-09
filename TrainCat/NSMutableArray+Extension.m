//
//  NSMutableArray+Shuffling.m
//  TrainCat
//
//  Created by Alankar Misra on 22/03/13.
//
//

#import "NSMutableArray+Extension.h"

@implementation NSMutableArray (Extension)

- (void)shuffle
{
    NSUInteger count = [self count];
    for (NSUInteger i=0; i<count; ++i) {
        // Select a random element between i and end of array to swap with.
        NSInteger nElements = count - i;
        NSInteger n = (arc4random() % nElements) + i;
        [self exchangeObjectAtIndex:i withObjectAtIndex:n];
    }
}

- (void)ensureCount:(NSUInteger)count {
    if(self.count < count) {
        for (NSUInteger i=self.count; i<count; ++i) {
            [self addObject:@0];
        }
    }
}

-(void)zeroOut {
    for(NSUInteger i=0, c=self.count; i<c; ++i) {
        self[i] = @0;
    }
}

-(double)sum {
    double s = 0.0;
    for(NSUInteger i=0, c=self.count; i<c; ++i) {
        s += [self[i] doubleValue];
    }
    return s;
}

-(void)incrementNumberAtIndex:(NSUInteger)index {
    self[index] = @([self[index] intValue]+1);
}

-(void)decrementNumberAtIndex:(NSUInteger)index {
    self[index] = @([self[index] intValue]-1);
}

@end
