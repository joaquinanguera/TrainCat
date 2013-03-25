//
//  TrainCatSession.m
//  TrainCat
//
//  Created by Alankar Misra on 22/03/13.
//
//

#import "StimulusSession.h"

@implementation StimulusSession

-(id)initWithCategoryID:(NSInteger)categoryID {
    return [self initWithCategoryID:categoryID blocks:[[NSMutableArray alloc] init]];
}

-(id)initWithCategoryID:(NSInteger)categoryID blocks:(NSMutableArray*)blocks {
    self = [super init];
    if(self) {
        self.categoryID = categoryID;
        self.blocks = blocks;
    }
    return self;
}

-(NSString *) description {
    return [NSString stringWithFormat:@"Category %d: (%@)", self.categoryID, [self.blocks componentsJoinedByString:@","]];
}

- (id)initWithCoder:(NSCoder *)decoder {
    if (self = [super init]) {
        self.categoryID = [decoder decodeIntegerForKey:@"categoryID"];
        self.blocks = [decoder decodeObjectForKey:@"blocks"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeInteger:self.categoryID forKey:@"categoryID"];
    [encoder encodeObject:self.blocks forKey:@"blocks"];
}

@end
