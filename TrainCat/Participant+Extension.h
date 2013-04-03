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
+(Participant *)clearStateForParticipantWithId:(int)pid;

- (BOOL)validatePid:(id *)ioValue error:(NSError **)outError;
- (NSArray *)performanceData;

@end
