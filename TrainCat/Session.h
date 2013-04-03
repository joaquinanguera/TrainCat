//
//  Session.h
//  TrainCat
//
//  Created by Alankar Misra on 03/04/13.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Block, Participant;

@interface Session : NSManagedObject

@property (nonatomic) int16_t sid;
@property (nonatomic, retain) Participant *participant;
@property (nonatomic, retain) NSOrderedSet *blocks;
@end

@interface Session (CoreDataGeneratedAccessors)

- (void)insertObject:(Block *)value inBlocksAtIndex:(NSUInteger)idx;
- (void)removeObjectFromBlocksAtIndex:(NSUInteger)idx;
- (void)insertBlocks:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeBlocksAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInBlocksAtIndex:(NSUInteger)idx withObject:(Block *)value;
- (void)replaceBlocksAtIndexes:(NSIndexSet *)indexes withBlocks:(NSArray *)values;
- (void)addBlocksObject:(Block *)value;
- (void)removeBlocksObject:(Block *)value;
- (void)addBlocks:(NSOrderedSet *)values;
- (void)removeBlocks:(NSOrderedSet *)values;
@end
