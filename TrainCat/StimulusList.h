//
//  StimlusList.h
//  TrainCat
//
//  Created by Alankar Misra on 22/03/13.
//
//

#import <Foundation/Foundation.h>

@interface StimulusList : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, strong) NSArray *stimuli;

-(id)initWithName:(NSString *)name stimuli:(NSArray *)stimuli;

@end
