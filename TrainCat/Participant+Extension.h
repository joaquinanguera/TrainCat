//
//  Participant+Validation.h
//  TrainCat
//
//  Created by Alankar Misra on 22/03/13.
//
//

#import "Participant.h"
#import "Block+Extension.h"

@interface Participant (Extension)

+(Participant *)dummyParticipant;
+(Participant *)participantWithId:(NSInteger)pid mustExist:(BOOL)mustExist;
+(Participant *)clearStateForParticipantWithId:(NSInteger)pid;

- (BOOL)validatePid:(id *)ioValue error:(NSError **)outError;
-(double)completionStat;
- (NSArray *)performanceStats;
-(NSString *)completionStatDescription;
-(NSUInteger)blocksCompletedInCurrentSession;
-(NSUInteger)levelForLastBlock;
-(NSUInteger)gradeBlock:(Block *)block;

@end
