//
//  Participant+Validation.m
//  TrainCat
//
//  Created by Alankar Misra on 22/03/13.
//
//

#import "Constants.h"
#import "Participant+Extension.h"
#import "AppDelegate.h"
#import "GameState.h"
#import "StimulusProgram.h"
#import "Session+Extension.h"
#import "Block+Extension.h"
#import "Trial.h"
#import "ArrayUtils.h"
#import "NSMutableArray+Extension.h"
#import "NSUserDefaults+Extensions.h"

@implementation Participant (Extension)

+(Participant *)dummyParticipant {
    return [Participant clearStateForParticipantWithId:kDemoParticipantId];
}

+(Participant *)participantWithId:(NSInteger)pid mustExist:(BOOL)mustExist {
    Participant *participant;
    NSManagedObjectContext *moc = getMOC();
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"Participant" inManagedObjectContext:moc];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDescription];
    
    NSNumber *opid = @(pid);
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

+(Participant *)clearStateForParticipantWithId:(NSInteger)pid {
    Participant *participant = [self participantWithId:pid mustExist:NO];
    AppController *delegate = getAppDelegate();
    if(participant) {
        [delegate.managedObjectContext deleteObject:participant];
    }
    
    // Create a new demo participant
    participant = [NSEntityDescription
                   insertNewObjectForEntityForName:@"Participant"
                   inManagedObjectContext:delegate.managedObjectContext];
    participant.pid = pid;
    participant.program = [NSKeyedArchiver archivedDataWithRootObject:pid == kDemoParticipantId ? [StimulusProgram createPractice] : [StimulusProgram create]];
    [delegate saveContext];
    
    return participant;    
}

- (BOOL)validatePid:(id *)ioValue error:(NSError **)outError {
    NSError *error = NULL;
    NSString *illegalParticipantIdFormatString = @"%04d is not a valid Participant Id. Participant Id's range from %04d to %04d.";
    int32_t pid = [*ioValue integerValue];
    if((pid != kDemoParticipantId) && (pid < kMinParticipantId || pid > kMaxParticipantId)) {
        NSString *errorMessage = [NSString stringWithFormat:illegalParticipantIdFormatString, pid, kMinParticipantId, kMinParticipantId];
        error = [[NSError alloc] initWithDomain:errorMessage code:0x2 userInfo:nil];
    } else { // duplicate?
        NSManagedObjectContext *moc = getMOC();
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        request.entity = [NSEntityDescription entityForName:@"Participant" inManagedObjectContext:moc];
        request.predicate = [NSPredicate predicateWithFormat:@"pid = %d",pid];
        NSError *executeFetchError= nil;
        NSInteger idCount = [moc countForFetchRequest:request error:&executeFetchError];
        if (executeFetchError) {
            NSString *errorMessage = [NSString stringWithFormat:@"Error looking up Participant %04d with error: %@", pid, [executeFetchError localizedDescription]];
            error = [[NSError alloc] initWithDomain:errorMessage code:0x4 userInfo:nil];
        } else if(idCount > 1) { // idCount will be 2 in case of duplicates cause we created the new duplicate object in the current managed object context
            error = [[NSError alloc] initWithDomain:((pid == kDemoParticipantId) ? [NSString stringWithFormat:illegalParticipantIdFormatString, pid, kMinParticipantId, kMinParticipantId] : @"Duplicate Participant Id") code:0x8 userInfo:nil];
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
    NSManagedObjectContext *moc = getMOC();
    GameState *gs =[NSEntityDescription insertNewObjectForEntityForName:@"GameState" inManagedObjectContext:moc];
    self.gameState = gs;
    self.program = [NSKeyedArchiver archivedDataWithRootObject:[StimulusProgram create]];
}

-(void)prepareForDeletion {
    // NSLog(@"Deleting %d", self.pid);
    [super prepareForDeletion];
    if([[NSUserDefaults standardUserDefaults] isLoggedIn:self.pid]) {
        // NSLog(@"Logging out %d", self.pid);
        [[NSUserDefaults standardUserDefaults] logout];
    }    
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

-(double)completionStat {
    double value = 0.0;
    
    if(self.sessions.count) {
        value = (self.sessions.count-1) * kMaxBlocks * kMaxTrialsPerBlock;
        Session *lastSession = self.sessions.lastObject;
        if(lastSession.blocks.count) {
            value += (lastSession.blocks.count-1) * kMaxTrialsPerBlock;
            Block *lastBlock = lastSession.blocks.lastObject;            
            value += lastBlock.trials.count;
        }
    }
    
    //// NSLog(@"completion Stat: sessionsCompleted: %f", value/(kMaxSessions*kMaxBlocks*kMaxTrialsPerBlock));
    return value/(kMaxSessions*kMaxBlocks*kMaxTrialsPerBlock);
}

-(NSString *)completionStatDescription {
    NSUInteger sc = self.sessions.count, bc = 0, tc = 0;
    if(sc) {
        Session *lastSession = self.sessions.lastObject;
        if(lastSession.blocks.count) {
            bc = lastSession.blocks.count;
            Block *lastBlock = lastSession.blocks.lastObject;
            tc = lastBlock.trials.count;
        }
    }
    return [NSString stringWithFormat:@"Sessions:%u, Blocks:%u, Trials:%u", sc, bc, tc];
}

-(NSUInteger)blocksCompletedInCurrentSession {
    NSUInteger result = 0;
    if(self.sessions.count) {
        Session *lastSession = self.sessions.lastObject;
        result = lastSession.blocks.count;
    }
    return result;
}

-(NSUInteger)levelForLastBlock {
    Block *block = [[[self.sessions lastObject] blocks] lastObject];
    return (block ? [self gradeBlock:block] : 0);
}


-(NSArray *)performanceStats {    
    NSMutableArray *blockPerf = [[NSMutableArray alloc] initWithCapacity:kMaxBlocks];
    [blockPerf ensureCount:kMaxBlocks];
    
    NSMutableArray *sessionPerf = [[NSMutableArray alloc] init]; // Average level achieved in each session
    for(Session *session in self.sessions) {
        double blockGradeSum = 0.0;
        for(Block *block in session.blocks) {
            blockGradeSum += [self gradeBlock:block];
        }
        [sessionPerf addObject:@(blockGradeSum/session.blocks.count)];
    }
    return sessionPerf;
}

-(NSUInteger)gradeBlock:(Block *)block {
    NSUInteger highestLevelAchieved = 0;
    
    NSMutableArray *correct = [[NSMutableArray alloc] initWithCapacity:kMaxLevel];
    [correct ensureCount:kMaxLevel];
    
    for(Trial *trial in block.trials) {
        if([trial.accuracy isEqualToString:@"Correct"]) {
            // - Increment the number of corrects at this level
            [correct incrementNumberAtIndex:trial.listId];
            // - Did you get two corrects at any level?
            NSUInteger lvl = [correct indexOfObjectIdenticalTo:@2];
            if(lvl != NSNotFound) {
                // - If you got two corrects at any level
                // Set that as the level achieved in this block (overwriting previous values)
                // NSLog(@"Block %d: Moving level from %d to %d for correct array: %@", block.bid, highestLevelAchieved, lvl+1, [correct componentsJoinedByString:@","]);
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
