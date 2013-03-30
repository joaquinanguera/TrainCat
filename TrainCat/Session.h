//
//  Session.h
//  TrainCat
//
//  Created by Alankar Misra on 30/03/13.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Participant;

@interface Session : NSManagedObject

@property (nonatomic) int16_t sid;
@property (nonatomic, retain) NSDate * endTime;
@property (nonatomic, retain) NSDate * startTime;
@property (nonatomic, retain) Participant *participant;

@end
