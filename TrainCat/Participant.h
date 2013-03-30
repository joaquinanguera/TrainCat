//
//  Participant.h
//  TrainCat
//
//  Created by Alankar Misra on 29/03/13.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class GameState, Session, Trial;

@interface Participant : NSManagedObject

@property (nonatomic) int32_t pid;
@property (nonatomic, retain) id program;
@property (nonatomic, retain) id state;
@property (nonatomic, retain) GameState *gameState;
@property (nonatomic, retain) NSOrderedSet *sessions;
@property (nonatomic, retain) NSOrderedSet *trials;
@end

@interface Participant (CoreDataGeneratedAccessors)

- (void)insertObject:(Session *)value inSessionsAtIndex:(NSUInteger)idx;
- (void)removeObjectFromSessionsAtIndex:(NSUInteger)idx;
- (void)insertSessions:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeSessionsAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInSessionsAtIndex:(NSUInteger)idx withObject:(Session *)value;
- (void)replaceSessionsAtIndexes:(NSIndexSet *)indexes withSessions:(NSArray *)values;
- (void)addSessionsObject:(Session *)value;
- (void)removeSessionsObject:(Session *)value;
- (void)addSessions:(NSOrderedSet *)values;
- (void)removeSessions:(NSOrderedSet *)values;
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
