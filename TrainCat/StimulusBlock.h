//
//  StimulusBlock.h
//  TrainCat
//
//  Created by Alankar Misra on 22/03/13.
//
//

#import <Foundation/Foundation.h>

@interface StimulusBlock : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, strong) NSArray *lists;

-(id)initWithName:(NSString *)name lists:(NSArray *)lists;

@end
