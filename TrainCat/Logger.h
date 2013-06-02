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

// Dropbox
+(void)sendReportForParticipant:(Participant *)participant forSession:(NSUInteger)sid;
+(void)sendAllReportsForParticipant:(Participant *)participant;


// Generation
+(NSString *)makeSessionReportForParticipant:(Participant *)participant forSession:(NSUInteger)sid;
+(NSString *)makeSessionLogsForParticipant:(Participant *)participant;
+(NSString *)makeFullSessionsReportForParticipant:(Participant *)participant;

// Utility
+(NSString *)stringFromDate:(NSDate *)date;
+(void)printStimulusPack;


@end
