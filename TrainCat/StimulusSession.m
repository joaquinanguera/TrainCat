//
//  TrainCatSession.m
//  TrainCat
//
//  Created by Alankar Misra on 22/03/13.
//
//

#import "StimulusSession.h"

@implementation StimulusSession

-(id)initWithCategoryId:(NSInteger)categoryId {
    return [self initWithCategoryId:categoryId blocks:[[NSMutableArray alloc] init]];
}

-(id)initWithCategoryId:(NSInteger)categoryId blocks:(NSMutableArray*)blocks {
    self = [super init];
    if(self) {
        self.categoryId = categoryId;
        self.blocks = blocks;
    }
    return self;
}

-(NSString *) description {
    return [NSString stringWithFormat:@"Category %d: (%@)", self.categoryId, [self.blocks componentsJoinedByString:@","]];
}

- (id)initWithCoder:(NSCoder *)decoder {
    if (self = [super init]) {
        self.categoryId = [decoder decodeIntegerForKey:@"categoryId"];
        self.blocks = [decoder decodeObjectForKey:@"blocks"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeInteger:self.categoryId forKey:@"categoryId"];
    [encoder encodeObject:self.blocks forKey:@"blocks"];
}

@end
