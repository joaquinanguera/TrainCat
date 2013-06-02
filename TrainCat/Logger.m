//
//  Logger.m
//  TrainCat
//
//  Created by Alankar Misra on 02/04/13.
//
//

#import "Logger.h"
#import "Participant+Extension.h"
#import "Block+Extension.h"
#import "SessionLog+Extension.h"
#import "Trial.h"
#import "StimulusProgram.h"
#import "StimulusSession.h"
#import "StimulusCategory.h"
#import "StimulusPack.h"
#import "Session+Extension.h"
#import "GameState.h"
#import "DSDropbox.h"
#import "Constants.h"

@implementation Logger

+(void)sendReportForParticipant:(Participant *)participant forSession:(NSUInteger)sid {
    [DSDropbox writeToFile:[NSString stringWithFormat:@"%04d_session_%02d.csv", participant.pid, sid+1] theString:[self makeSessionReportForParticipant:participant forSession:sid]];
    [DSDropbox writeToFile:[NSString stringWithFormat:@"%04d_log_%02d.csv", participant.pid, sid+1] theString:[self makeSessionLogsForParticipant:participant]];
    //[DSDropbox writeToFile:[NSString stringWithFormat:@"%04d_program.txt", participant.pid] theString:[self makeProgramListingForParticipant:participant]];
}

+(void)sendAllReportsForParticipant:(Participant *)participant {
    [DSDropbox writeToFile:[NSString stringWithFormat:@"%04d_session_all.csv", participant.pid] theString:[self makeFullSessionsReportForParticipant:participant]];
    [DSDropbox writeToFile:[NSString stringWithFormat:@"%04d_log_all.csv", participant.pid] theString:[self makeSessionLogsForParticipant:participant]];
    //[DSDropbox writeToFile:[NSString stringWithFormat:@"%04d_program.txt", participant.pid] theString:[self makeProgramListingForParticipant:participant]];
}

+(NSString *)makeSessionReportForParticipant:(Participant *)participant forSession:(NSUInteger)sid {
    NSInteger count = 0;
    NSMutableString *report = [NSMutableString stringWithFormat:@"%@\n", [@[@"#", @"Session Id", @"Category Name", @"Block Id", @"Trial", @"Exemplars", @"Fixation Duration", @"Morph Level", @"Morph Stimulus", @"RT", @"Response", @"Accuracy",@"Level"] componentsJoinedByString:@","]];
    Session *session = participant.sessions[sid];
    for(Block *block in session.blocks) {
        for(Trial *trial in block.trials) {
            StimulusCategory *category = [StimulusPack sessions][trial.categoryId];
            [report appendFormat:@"%@\n", [@[@(++count), @(session.sid+1), category.name, @(block.bid), @(trial.trial), trial.exemplars, @(trial.fixationDuration), @(trial.listId+1), trial.morphLabel, @(trial.responseTime), trial.response, trial.accuracy, !(trial.trial % kMaxTrialsPerBlock) ? @([participant gradeBlock:block]) : @""] componentsJoinedByString:@","]];
        }        
    }
    return report;
}

+(NSString *)makeSessionLogsForParticipant:(Participant *)participant {
    NSInteger count = 0;
    NSMutableString *report = [NSMutableString stringWithFormat:@"%@\n", [@[@"#", @"Session Id", @"startTime", @"endTime"] componentsJoinedByString:@","]];
    for (SessionLog *session in participant.sessionLogs) {
        [report appendFormat:@"%@\n", [@[@(++count), @(session.sid+1), [self stringFromDate:session.startTime], [self stringFromDate:session.endTime]] componentsJoinedByString:@","]];
    }
    return report;
}

/*
+(NSString *)makeProgramListingForParticipant:(Participant *)participant {
    NSMutableString *report = [[NSMutableString alloc] init];
    NSArray *program = [NSKeyedUnarchiver unarchiveObjectWithData:participant.program];
    for(StimulusSession *session in program) {
        [report appendFormat:@"%@\n", session];
    }
    return report;
}
*/

+(NSString *)makeFullSessionsReportForParticipant:(Participant *)participant {
    NSMutableString *report = [[NSMutableString alloc] init];
    for(Session *session in participant.sessions) {
        [report appendString:[self makeSessionReportForParticipant:participant forSession:session.sid]];
    }
    return report;
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


@end
