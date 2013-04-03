//
//  SessionLog.h
//  TrainCat
//
//  Created by Alankar Misra on 03/04/13.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Participant;

@interface SessionLog : NSManagedObject

@property (nonatomic, retain) NSDate * endTime;
@property (nonatomic) int16_t sid;
@property (nonatomic, retain) NSDate * startTime;
@property (nonatomic, retain) Participant *participant;

@end
