//
//  StimulusCategory.m
//  TrainCat
//
//  Created by Alankar Misra on 22/03/13.
//
//

#import "StimulusCategory.h"

@implementation StimulusCategory

-(id)initWithName:(NSString *)name exemplarLeft:(NSString *)exemplarLeft exemplarRight:(NSString*)exemplarRight blocks:(NSArray *)blocks {
    self = [super init];
    if(self) {
        self.name = name;
        self.exemplarLeft = exemplarLeft;
        self.exemplarRight = exemplarRight;
        self.blocks = blocks;
    }
    return self;
}

-(NSString *) description {
    return [NSString stringWithFormat:@"%@ (%@, %@):\n%@", self.name, self.exemplarLeft, self.exemplarRight, [self.blocks componentsJoinedByString:@"\n"]];
}

@end
