//
//  Trial.h
//  TrainCat
//
//  Created by Alankar Misra on 03/04/13.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Participant;

@interface Trial : NSManagedObject

@property (nonatomic, retain) NSString * accuracy;
@property (nonatomic) int16_t blockId;
@property (nonatomic) int16_t categoryId;
@property (nonatomic, retain) NSString * exemplars;
@property (nonatomic) int16_t listId;
@property (nonatomic, retain) NSString * morphLabel;
@property (nonatomic, retain) NSString * response;
@property (nonatomic) double responseTime;
@property (nonatomic) int16_t sessionId;
@property (nonatomic) int16_t trial;
@property (nonatomic, retain) NSString * blockName;
@property (nonatomic, retain) Participant *participant;

@end
