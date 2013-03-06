//
//  Participant.m
//  TrainCat
//
//  Created by Alankar Misra on 06/03/13.
//
//

#import "Participant.h"
#import "Session.h"
#import "AppDelegate.h"


@implementation Participant

@dynamic pid;
@dynamic sessions;


- (BOOL)validatePid:(id *)ioValue error:(NSError **)outError {
    int32_t pid = [*ioValue integerValue];
    NSLog(@"pid: %d", pid);
    NSError *error = NULL;
    if (!pid) { // blank or invalid pid?
        error = [[NSError alloc] initWithDomain:@"Empty or 0 Participant ID" code:0x1 userInfo:nil];
    } else { // duplicate?
        NSManagedObjectContext *moc = ((AppController *)[[UIApplication sharedApplication] delegate]).managedObjectContext;
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        request.entity = [NSEntityDescription entityForName:@"Participant" inManagedObjectContext:moc];
        request.predicate = [NSPredicate predicateWithFormat:@"pid = %d",pid];
        NSError *executeFetchError= nil;
        int idCount = [moc countForFetchRequest:request error:&executeFetchError];
        if (executeFetchError) {
            NSString *errorMessage = [NSString stringWithFormat:@"Error looking up Participant %04d with error: %@", pid, [executeFetchError localizedDescription]];
            error = [[NSError alloc] initWithDomain:errorMessage code:0x2 userInfo:nil];
        } else if(idCount > 1){ // idCount will be 2 in case of duplicates cause we created the new duplicate object in the current managed object context
            NSLog(@"%d", idCount);
            error = [[NSError alloc] initWithDomain:@"Duplicate Participant ID" code:0x2 userInfo:nil];
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


@end
