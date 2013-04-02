//
//  Participant+Validation.m
//  TrainCat
//
//  Created by Alankar Misra on 22/03/13.
//
//

#import "Participant+Extension.h"
#import "Session.h"
#import "AppDelegate.h"
#import "GameState.h"
#import "StimulusProgram.h"
#import "constants.h"

@implementation Participant (Extension)

- (BOOL)validatePid:(id *)ioValue error:(NSError **)outError {
    NSError *error = NULL;
    int32_t pid = [*ioValue integerValue];
    if((pid != DEMO_PARTICIPANT_ID) && (pid < 0 || pid >= 9999)) { 
        NSString *errorMessage = [NSString stringWithFormat:@"%04d out of bounds. Valid participant numbers range from 0001 to 9999.", pid];
        error = [[NSError alloc] initWithDomain:errorMessage code:0x2 userInfo:nil];
    } else { // duplicate?
        NSManagedObjectContext *moc = ((AppController *)[[UIApplication sharedApplication] delegate]).managedObjectContext;
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        request.entity = [NSEntityDescription entityForName:@"Participant" inManagedObjectContext:moc];
        request.predicate = [NSPredicate predicateWithFormat:@"pid = %d",pid];
        NSError *executeFetchError= nil;
        int idCount = [moc countForFetchRequest:request error:&executeFetchError];
        if (executeFetchError) {
            NSString *errorMessage = [NSString stringWithFormat:@"Error looking up Participant %04d with error: %@", pid, [executeFetchError localizedDescription]];
            error = [[NSError alloc] initWithDomain:errorMessage code:0x4 userInfo:nil];
        } else if(idCount > 1){ // idCount will be 2 in case of duplicates cause we created the new duplicate object in the current managed object context
            NSLog(@"%d", idCount);
            error = [[NSError alloc] initWithDomain:@"Duplicate Participant Id" code:0x8 userInfo:nil];
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
    NSManagedObjectContext *moc = ((AppController *)[[UIApplication sharedApplication] delegate]).managedObjectContext;
    GameState *gs =[NSEntityDescription insertNewObjectForEntityForName:@"GameState" inManagedObjectContext:moc];
    self.gameState = gs;
    self.program = [NSKeyedArchiver archivedDataWithRootObject:[StimulusProgram create]];
}

- (void)addSessionsObject:(Session *)value {
    NSMutableOrderedSet* tempSet = [NSMutableOrderedSet orderedSetWithOrderedSet:self.sessions];
    [tempSet addObject:value];
    self.sessions = tempSet;
}

- (void)addTrialsObject:(Trial *)value {
    NSMutableOrderedSet* tempSet = [NSMutableOrderedSet orderedSetWithOrderedSet:self.trials];
    [tempSet addObject:value];
    self.trials = tempSet;
}

+(Participant *)dummyParticipant {
    Participant *participant = [self participantWithId:DEMO_PARTICIPANT_ID mustExist:NO];
    AppController *delegate = ((AppController *)[[UIApplication sharedApplication] delegate]);
    if(participant) {
        [delegate.managedObjectContext deleteObject:participant];
    }

    // Create a new demo participant
    participant = [NSEntityDescription
                   insertNewObjectForEntityForName:@"Participant"
                   inManagedObjectContext:delegate.managedObjectContext];
    participant.pid = DEMO_PARTICIPANT_ID;
    participant.program = [NSKeyedArchiver archivedDataWithRootObject:[StimulusProgram createPractice]];
    [delegate saveContext];

    return participant;
}

+(Participant *)participantWithId:(int)pid mustExist:(BOOL)mustExist {
    Participant *participant;
    AppController *delegate = ((AppController *)[[UIApplication sharedApplication] delegate]);    
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"Participant" inManagedObjectContext:delegate.managedObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDescription];
    
    NSNumber *opid = [NSNumber numberWithInt:pid];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"pid=%@", opid];
    [request setPredicate:predicate];
    NSError *error;
    NSArray *array = [delegate.managedObjectContext executeFetchRequest:request error:&error];
    if(array == nil) {
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:[error domain] /* , [error userInfo] */
                                                          message:@"There was an error reading the Participant database. Contact the developer."
                                                         delegate:nil
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles:nil];
        [message show];
    } else if(!array.count && mustExist) {
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:[error domain] 
                                                          message:[NSString stringWithFormat:@"Could not find participant with id %d. Contact the developer.", pid]
                                                         delegate:nil
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles:nil];
        [message show];
    } else {
        participant = array[0];
    }
    return participant;
}



@end
