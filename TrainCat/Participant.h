//
//  Participant.h
//  TrainCat
//
//  Created by Alankar Misra on 03/04/13.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class GameState, SessionLog;

@interface Participant : NSManagedObject

@property (nonatomic) int32_t pid;
@property (nonatomic, retain) id program;
@property (nonatomic, retain) id state;
@property (nonatomic, retain) GameState *gameState;
@property (nonatomic, retain) NSOrderedSet *sessionLogs;
@property (nonatomic, retain) NSOrderedSet *sessions;
@end

@interface Participant (CoreDataGeneratedAccessors)

- (void)insertObject:(SessionLog *)value inSessionLogsAtIndex:(NSUInteger)idx;
- (void)removeObjectFromSessionLogsAtIndex:(NSUInteger)idx;
- (void)insertSessionLogs:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeSessionLogsAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInSessionLogsAtIndex:(NSUInteger)idx withObject:(SessionLog *)value;
- (void)replaceSessionLogsAtIndexes:(NSIndexSet *)indexes withSessionLogs:(NSArray *)values;
- (void)addSessionLogsObject:(SessionLog *)value;
- (void)removeSessionLogsObject:(SessionLog *)value;
- (void)addSessionLogs:(NSOrderedSet *)values;
- (void)removeSessionLogs:(NSOrderedSet *)values;
- (void)insertObject:(NSManagedObject *)value inSessionsAtIndex:(NSUInteger)idx;
- (void)removeObjectFromSessionsAtIndex:(NSUInteger)idx;
- (void)insertSessions:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeSessionsAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInSessionsAtIndex:(NSUInteger)idx withObject:(NSManagedObject *)value;
- (void)replaceSessionsAtIndexes:(NSIndexSet *)indexes withSessions:(NSArray *)values;
- (void)addSessionsObject:(NSManagedObject *)value;
- (void)removeSessionsObject:(NSManagedObject *)value;
- (void)addSessions:(NSOrderedSet *)values;
- (void)removeSessions:(NSOrderedSet *)values;
@end
