//
//  TrainCatSession.h
//  TrainCat
//
//  Created by Alankar Misra on 22/03/13.
//
//

#import <Foundation/Foundation.h>

@interface StimulusSession : NSObject <NSCoding>

@property (nonatomic, assign) NSInteger categoryId;
@property (nonatomic, strong) NSMutableArray *blocks; // blockIDs (NSNumbers)

-(id)initWithCategoryId:(NSInteger)categoryId;
-(id)initWithCategoryId:(NSInteger)categoryId blocks:(NSMutableArray*)blocks;

@end
