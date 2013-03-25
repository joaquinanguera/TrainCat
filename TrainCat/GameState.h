//
//  GameState.h
//  TrainCat
//
//  Created by Alankar Misra on 23/03/13.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Participant;

@interface GameState : NSManagedObject

@property (nonatomic) int16_t sessionID;
@property (nonatomic) int16_t blockID;
@property (nonatomic) int16_t listID;
@property (nonatomic) int16_t trialCount;
@property (nonatomic, retain) Participant *participant;

@end
