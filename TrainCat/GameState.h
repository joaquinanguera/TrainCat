//
//  GameState.h
//  TrainCat
//
//  Created by Alankar Misra on 29/03/13.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Participant;

@interface GameState : NSManagedObject

@property (nonatomic) int16_t blockId;
@property (nonatomic) int16_t listId;
@property (nonatomic) int16_t sessionId;
@property (nonatomic) int16_t trialCount;
@property (nonatomic, retain) Participant *participant;

@end
