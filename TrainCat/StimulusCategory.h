//
//  StimulusCategory.h
//  TrainCat
//
//  Created by Alankar Misra on 22/03/13.
//
//

#import <Foundation/Foundation.h>

@interface StimulusCategory : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *exemplarLeft;
@property (nonatomic, copy) NSString *exemplarRight;
@property (nonatomic, strong) NSArray *blocks;

-(id)initWithName:(NSString *)name exemplarLeft:(NSString *)exemplarLeft exemplarRight:(NSString*)exemplarRight blocks:(NSArray *)blocks;

@end
