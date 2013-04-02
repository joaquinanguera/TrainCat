//
//  Participant+Validation.h
//  TrainCat
//
//  Created by Alankar Misra on 22/03/13.
//
//

#import "Participant.h"

@interface Participant (Extension)

+(Participant *)dummyParticipant;
+(Participant *)participantWithId:(int)pid mustExist:(BOOL)mustExist;

- (BOOL)validatePid:(id *)ioValue error:(NSError **)outError;

@end
