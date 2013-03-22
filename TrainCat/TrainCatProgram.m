//
//  TrainCatProgram.m
//  TrainCat
//
//  Created by Alankar Misra on 22/03/13.
//
//

#import "TrainCatProgram.h"

@implementation TrainCatProgram

-(id)init {
    return [self initWithSessions:[[NSMutableArray alloc] init]];
}

-(id)initWithSessions:(NSMutableArray *)sessions {
    self = [super init];
    if(self) {
        self.sessions = sessions;
    }
    return self;
}

-(NSString *) description {
    return [NSString stringWithFormat:@"%@", [self.sessions componentsJoinedByString:@"\n"]];
}


@end
