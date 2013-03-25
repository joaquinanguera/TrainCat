//
//  Participant+Validation.h
//  TrainCat
//
//  Created by Alankar Misra on 22/03/13.
//
//

#import "Participant.h"

@interface Participant (Extension)

- (BOOL)validatePid:(id *)ioValue error:(NSError **)outError;

@end
