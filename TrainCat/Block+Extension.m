//
//  Block+Extension.m
//  TrainCat
//
//  Created by Alankar Misra on 03/04/13.
//
//

#import "Block+Extension.h"

@implementation Block (Extension)

- (void)addTrialsObject:(Trial *)value {
    NSMutableOrderedSet* tempSet = [NSMutableOrderedSet orderedSetWithOrderedSet:self.trials];
    [tempSet addObject:value];
    self.trials = tempSet;
}


@end
