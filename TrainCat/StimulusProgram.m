//
//  Program.m
//  TrainCat
//
//  Created by Alankar Misra on 23/03/13.
//
//

#import "StimulusProgram.h"
#import "NSMutableArray+Extension.h"
#import "RangeArray.h"
#import "StimulusSession.h"
#import "StimulusPack.h"
#import "constants.h"

@implementation StimulusProgram

+(NSArray *)create {
    NSArray *pack = [StimulusPack sessions];
    NSMutableArray *categories = [[[RangeArray alloc] initWithRangeFrom:1 to:pack.count-1] mutableCopy];
    [categories shuffle];
    NSMutableArray *categorySequence = [categories mutableCopy];
    [categories shuffle];
    [categorySequence addObjectsFromArray:categories];
    
    NSNumber *zero = [NSNumber numberWithInt:0];
    NSNumber *one = [NSNumber numberWithInt:1];
    NSMutableArray *blocks = [NSMutableArray arrayWithObjects:zero,zero,zero,one,one,one, nil];
    
    NSMutableArray *program = [[NSMutableArray alloc] initWithCapacity:10];
    for(NSNumber *catId in categorySequence) {
        [blocks shuffle];
        [program addObject:[[StimulusSession alloc] initWithCategoryId:[catId integerValue] blocks:[blocks mutableCopy]]];
    }
    return program;
}

+(NSArray *)createPractice {
    NSMutableArray *blocks = [NSMutableArray arrayWithObjects:[NSNumber numberWithInt:0], nil];
    NSMutableArray *program = [[NSMutableArray alloc] initWithCapacity:1];
    [program addObject:[[StimulusSession alloc] initWithCategoryId:0 blocks:[blocks mutableCopy]]];
    return program;
}

@end
