//
//  Block.h
//  TrainCat
//
//  Created by Alankar Misra on 03/04/13.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Session, Trial;

@interface Block : NSManagedObject

@property (nonatomic) int16_t highestLevelReached;
@property (nonatomic) int16_t bid;
@property (nonatomic, retain) Session *session;
@property (nonatomic, retain) NSOrderedSet *trials;
@end

@interface Block (CoreDataGeneratedAccessors)

- (void)insertObject:(Trial *)value inTrialsAtIndex:(NSUInteger)idx;
- (void)removeObjectFromTrialsAtIndex:(NSUInteger)idx;
- (void)insertTrials:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeTrialsAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInTrialsAtIndex:(NSUInteger)idx withObject:(Trial *)value;
- (void)replaceTrialsAtIndexes:(NSIndexSet *)indexes withTrials:(NSArray *)values;
- (void)addTrialsObject:(Trial *)value;
- (void)removeTrialsObject:(Trial *)value;
- (void)addTrials:(NSOrderedSet *)values;
- (void)removeTrials:(NSOrderedSet *)values;
@end
