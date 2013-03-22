//
//  TrainCatSession.h
//  TrainCat
//
//  Created by Alankar Misra on 22/03/13.
//
//

#import <Foundation/Foundation.h>

@interface TrainCatSession : NSObject

@property (nonatomic, assign) NSNumber *categoryID;
@property (nonatomic, strong) NSMutableArray *blocks; // blockIDs (NSNumbers)

-(id)initWithCategoryID:(NSNumber *)categoryID;
-(id)initWithCategoryID:(NSNumber *)categoryID blocks:(NSMutableArray*)blocks;

@end
