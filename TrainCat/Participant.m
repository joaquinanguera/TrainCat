//
//  Participant.m
//  TrainCat
//
//  Created by Alankar Misra on 28/02/13.
//
//

#import "Participant.h"
#import "Session.h"
#import "AppDelegate.h"


@implementation Participant

@dynamic pid;
@dynamic sessions;

- (BOOL)validatePid:(id *)ioValue error:(NSError **)outError {
    NSString *pid = [*ioValue stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSError *error = NULL;
    if ([pid isEqualToString:@""]) { // blank string?
        error = [[NSError alloc] initWithDomain:@"Empty Participant ID" code:0x1 userInfo:nil];
    } else { // duplicate?
        NSManagedObjectContext *moc = ((AppController *)[[UIApplication sharedApplication] delegate]).managedObjectContext;
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        request.entity = [NSEntityDescription entityForName:@"Participant" inManagedObjectContext:moc];
        request.predicate = [NSPredicate predicateWithFormat:@"pid = %@",pid];
        NSError *executeFetchError= nil;
        int idCount = [moc countForFetchRequest:request error:&executeFetchError];
        if (executeFetchError) {
            NSString *errorMessage = [NSString stringWithFormat:@"Error looking up Participant %@ with error: %@", pid, [executeFetchError localizedDescription]];
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
