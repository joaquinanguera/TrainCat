//
//  Participant+Validation.m
//  TrainCat
//
//  Created by Alankar Misra on 22/03/13.
//
//

#import "constants.h"
#import "Participant+Extension.h"
#import "AppDelegate.h"
#import "GameState.h"
#import "StimulusProgram.h"
#import "Session+Extension.h"
#import "Block+Extension.h"
#import "Trial.h"
#import "ArrayUtils.h"
#import "NSMutableArray+Extension.h"

@implementation Participant (Extension)

+(Participant *)dummyParticipant {
    return [Participant clearStateForParticipantWithId:DEMO_PARTICIPANT_ID];
}

+(Participant *)participantWithId:(int)pid mustExist:(BOOL)mustExist {
    Participant *participant;
    NSManagedObjectContext *moc = MOC;
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"Participant" inManagedObjectContext:moc];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDescription];
    
    NSNumber *opid = [NSNumber numberWithInt:pid];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"pid=%@", opid];
    [request setPredicate:predicate];
    NSError *error;
    NSArray *array = [moc executeFetchRequest:request error:&error];
    if(array == nil) {
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:[error domain] /* , [error userInfo] */
                                                          message:@"There was an error reading the Participant database. Contact the developer."
                                                         delegate:nil
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles:nil];
        [message show];
    } else if(!array.count) {
        if(mustExist) {
            UIAlertView *message = [[UIAlertView alloc] initWithTitle:[error domain]
                                                              message:[NSString stringWithFormat:@"Could not find participant with id %d. Contact the developer.", pid]
                                                             delegate:nil
                                                    cancelButtonTitle:@"OK"
                                                    otherButtonTitles:nil];
            [message show];
        }
    } else {
        participant = array[0];
    }
    return participant;
}

+(Participant *)clearStateForParticipantWithId:(int)pid {
    Participant *participant = [self participantWithId:pid mustExist:NO];
    AppController *delegate = APP_DELEGATE;
    if(participant) {
        [delegate.managedObjectContext deleteObject:participant];
    }
    
    // Create a new demo participant
    participant = [NSEntityDescription
                   insertNewObjectForEntityForName:@"Participant"
                   inManagedObjectContext:delegate.managedObjectContext];
    participant.pid = pid;
    participant.program = [NSKeyedArchiver archivedDataWithRootObject:pid == DEMO_PARTICIPANT_ID ? [StimulusProgram createPractice] : [StimulusProgram create]];
    [delegate saveContext];
    
    return participant;    
}

- (BOOL)validatePid:(id *)ioValue error:(NSError **)outError {
    NSError *error = NULL;
    NSString *illegalParticipantIdFormatString = @"%04d is not a valid Participant Id. Participant Id's range from %04d to %04d.";
    int32_t pid = [*ioValue integerValue];
    if((pid != DEMO_PARTICIPANT_ID) && (pid < 1 || pid > 9999)) {
        NSString *errorMessage = [NSString stringWithFormat:illegalParticipantIdFormatString, pid, MIN_PARTICIPANT_ID, MAX_PARTICIPANT_ID];
        error = [[NSError alloc] initWithDomain:errorMessage code:0x2 userInfo:nil];
    } else { // duplicate?
        NSManagedObjectContext *moc = MOC;
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        request.entity = [NSEntityDescription entityForName:@"Participant" inManagedObjectContext:moc];
        request.predicate = [NSPredicate predicateWithFormat:@"pid = %d",pid];
        NSError *executeFetchError= nil;
        int idCount = [moc countForFetchRequest:request error:&executeFetchError];
        if (executeFetchError) {
            NSString *errorMessage = [NSString stringWithFormat:@"Error looking up Participant %04d with error: %@", pid, [executeFetchError localizedDescription]];
            error = [[NSError alloc] initWithDomain:errorMessage code:0x4 userInfo:nil];
        } else if(idCount > 1) { // idCount will be 2 in case of duplicates cause we created the new duplicate object in the current managed object context
            error = [[NSError alloc] initWithDomain:((pid == DEMO_PARTICIPANT_ID) ? [NSString stringWithFormat:illegalParticipantIdFormatString, pid, MIN_PARTICIPANT_ID, MAX_PARTICIPANT_ID] : @"Duplicate Participant Id") code:0x8 userInfo:nil];
        }
    }
    if (error!= NULL) {
        if(outError != NULL) {
            *outError = error;
        }
        return NO;
    }
    return YES;
}

-(void)awakeFromInsert {
    [super awakeFromInsert];
    NSManagedObjectContext *moc = MOC;
    GameState *gs =[NSEntityDescription insertNewObjectForEntityForName:@"GameState" inManagedObjectContext:moc];
    self.gameState = gs;
    self.program = [NSKeyedArchiver archivedDataWithRootObject:[StimulusProgram create]];
}

- (void)addSessionLogsObject:(SessionLog *)value {
    NSMutableOrderedSet* tempSet = [NSMutableOrderedSet orderedSetWithOrderedSet:self.sessionLogs];
    [tempSet addObject:value];
    self.sessionLogs = tempSet;
}

- (void)addSessionsObject:(Session *)value {
    NSMutableOrderedSet* tempSet = [NSMutableOrderedSet orderedSetWithOrderedSet:self.sessions];
    [tempSet addObject:value];
    self.sessions = tempSet;
}

-(NSArray *)performanceData {
    
    NSMutableArray *blockPerf = [[NSMutableArray alloc] initWithCapacity:MAX_STIMULUS_BLOCKS];
    [blockPerf ensureCount:MAX_STIMULUS_BLOCKS];
    
    NSMutableArray *sessionPerf = [[NSMutableArray alloc] init]; // Average level achieved in each session
    for(Session *session in self.sessions) {
        double blockGradeSum = 0.0;
        for(Block *block in session.blocks) {
            blockGradeSum += [self gradeBlock:block];
        }
        [sessionPerf addObject:[NSNumber numberWithDouble:(blockGradeSum/session.blocks.count)]];
    }
    return sessionPerf;
}

-(int)gradeBlock:(Block *)block {
    int highestLevelAchieved = 0;
    
    NSMutableArray *correct = [[NSMutableArray alloc] initWithCapacity:MAX_STIMULUS_LEVEL];
    [correct ensureCount:MAX_STIMULUS_LEVEL];
    
    for(Trial *trial in block.trials) {
        if([trial.accuracy isEqualToString:@"Correct"]) {
            // - Increment the number of corrects at this level
            [correct incrementNumberAtIndex:trial.listId];
            // - Did you get two corrects at any level?
            NSUInteger lvl = [correct indexOfObjectIdenticalTo:[NSNumber numberWithInt:2]];
            if(lvl != NSNotFound) {
                // - If you got two corrects at any level
                // Set that as the level achieved in this block (overwriting previous values)
                NSLog(@"Block %d: Moving level from %d to %d for correct array: %@", block.bid, highestLevelAchieved, lvl+1, [correct componentsJoinedByString:@","]);
                highestLevelAchieved = (lvl+1);
                // Zero out the correct counts so we can start evaluating again
                [correct zeroOut];
            }
            // - If you did not get two corrects at any level, move along.
        }        
    }
    
    return highestLevelAchieved;
}


@end
