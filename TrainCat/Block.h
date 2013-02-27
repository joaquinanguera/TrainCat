//
//  Block.h
//  TrainCat
//
//  Created by Alankar Misra on 27/02/13.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Session;

@interface Block : NSManagedObject

@property (nonatomic, retain) NSNumber * trial;
@property (nonatomic, retain) NSString * exemplars;
@property (nonatomic, retain) Session *session;

@end
