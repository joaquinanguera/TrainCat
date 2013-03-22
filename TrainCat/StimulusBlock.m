//
//  StimulusBlock.m
//  TrainCat
//
//  Created by Alankar Misra on 22/03/13.
//
//

#import "StimulusBlock.h"

@implementation StimulusBlock

-(id)initWithName:(NSString *)name lists:(NSArray *)lists {
    self = [super init];
    if(self) {
        self.name = name;
        self.lists = lists;
    }
    return self;
}

-(NSString *) description {
    return [NSString stringWithFormat:@"%@:\n%@", self.name, [self.lists componentsJoinedByString:@"\n"]];
}

@end
