//
//  Session+Extension.m
//  TrainCat
//
//  Created by Alankar Misra on 03/04/13.
//
//

#import "Session+Extension.h"

@implementation Session (Extension)

- (void)addBlocksObject:(Block *)value {
    NSMutableOrderedSet* tempSet = [NSMutableOrderedSet orderedSetWithOrderedSet:self.blocks];
    [tempSet addObject:value];
    self.blocks = tempSet;
}


@end
