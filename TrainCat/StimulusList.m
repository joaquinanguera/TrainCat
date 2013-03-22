//
//  StimlusList.m
//  TrainCat
//
//  Created by Alankar Misra on 22/03/13.
//
//

#import "StimulusList.h"

@implementation StimulusList

-(id)initWithName:(NSString *)name stimuli:(NSArray *)stimuli {
    self = [super init];
    if(self) {
        self.name = name;
        self.stimuli = stimuli;
    }
    return self;
}

-(NSString *) description {
    return [NSString stringWithFormat:@"%@: [%@]", self.name, [self.stimuli componentsJoinedByString:@","]];
}

@end
