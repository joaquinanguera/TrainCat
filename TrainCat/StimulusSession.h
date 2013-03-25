//
//  TrainCatSession.h
//  TrainCat
//
//  Created by Alankar Misra on 22/03/13.
//
//

#import <Foundation/Foundation.h>

@interface StimulusSession : NSObject <NSCoding>

@property (nonatomic, assign) NSInteger categoryID;
@property (nonatomic, strong) NSMutableArray *blocks; // blockIDs (NSNumbers)

-(id)initWithCategoryID:(NSInteger)categoryID;
-(id)initWithCategoryID:(NSInteger)categoryID blocks:(NSMutableArray*)blocks;

@end
