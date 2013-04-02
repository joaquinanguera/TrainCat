//
//  Logger.h
//  TrainCat
//
//  Created by Alankar Misra on 02/04/13.
//
//

#import <Foundation/Foundation.h>
#import "Participant+Extension.h"

@interface Logger : NSObject
+(void)printAllBlocksForParticipant:(Participant *)participant;
+(void)printAllSessionsForParticipant:(Participant *)participant;
+(void)printProgramForParticipant:(Participant *)participant;
+(NSString *)stringFromDate:(NSDate *)date;
+(void)printStimulusPack;
@end
