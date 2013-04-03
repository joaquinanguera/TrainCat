//
//  NSMutableArray+Shuffling.h
//  TrainCat
//
//  Created by Alankar Misra on 22/03/13.
//
//

#import <Foundation/Foundation.h>

@interface NSMutableArray (Extension)

-(void)shuffle;
-(void)ensureCount:(NSUInteger)count;
-(void)zeroOut;
-(double)sum;
-(void)incrementNumberAtIndex:(NSUInteger)index;
-(void)decrementNumberAtIndex:(NSUInteger)index;

@end
