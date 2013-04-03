//
//  Logger.m
//  TrainCat
//
//  Created by Alankar Misra on 02/04/13.
//
//

#import "Logger.h"
#import "Participant+Extension.h"
#import "Trial.h"
#import "StimulusProgram.h"
#import "StimulusSession.h"
#import "StimulusCategory.h"
#import "StimulusPack.h"
#import "Session+Extension.h"
#import "GameState.h"


@implementation Logger

+(void)printAllBlocksForParticipant:(Participant *)participant {
    int count = 0;
    NSLog(@"%@", [[NSArray arrayWithObjects:@"<!>", @"#", @"Session Id", @"Category Name", @"Block Id", @"Trial", @"Exemplars", @"Morph Level", @"Morph Stimulus", @"RT", @"Response", @"Accuracy", nil] componentsJoinedByString:@","]);
    for(Trial *trial in participant.trials) {
        StimulusCategory *category = [StimulusPack sessions][trial.categoryId];
        NSLog(@"%@", [[NSArray arrayWithObjects:@"<!>", [NSNumber numberWithInt:++count], [NSNumber numberWithInt:(trial.sessionId+1)], category.name, [NSNumber numberWithInt:trial.blockId], [NSNumber numberWithInt:trial.trial], trial.exemplars, [NSNumber numberWithInt:trial.listId+1], trial.morphLabel, [NSNumber numberWithDouble:trial.responseTime], trial.response, trial.accuracy, nil] componentsJoinedByString:@","]);
        
    }
}

+(void)printAllSessionsForParticipant:(Participant *)participant {
    int count = 0;
    NSLog(@"%@", [[NSArray arrayWithObjects:@"<!>", @"#", @"Session Id", @"startTime", @"endTime", nil] componentsJoinedByString:@","]);
    for (SessionLog *session in participant.sessions) {
        NSLog(@"%@", [[NSArray arrayWithObjects:@"<!>", [NSNumber numberWithInt:++count], [NSNumber numberWithInt:(session.sid+1)], [self stringFromDate:session.startTime], [self stringFromDate:session.endTime], nil] componentsJoinedByString:@","]);
    }
}

+(NSString *)stringFromDate:(NSDate *)date {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd hh:mm a";
    NSTimeZone *gmt = [NSTimeZone timeZoneWithAbbreviation:@"GMT+05:30"];
    [dateFormatter setTimeZone:gmt];
    return [dateFormatter stringFromDate:date];
}

+(void)printStimulusPack {
    NSArray *stim = [StimulusPack sessions];
    for(StimulusCategory *cat in stim) {
        NSLog(@"%@", cat);
    }
}

+(void)printProgramForParticipant:(Participant *)participant {
    NSArray *program = [NSKeyedUnarchiver unarchiveObjectWithData:participant.program];
    for(StimulusSession *session in program) {
         NSLog(@"%@", session);
    }
}

@end
