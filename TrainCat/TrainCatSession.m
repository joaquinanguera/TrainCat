//
//  TrainCatSession.m
//  TrainCat
//
//  Created by Alankar Misra on 22/03/13.
//
//

#import "TrainCatSession.h"

@implementation TrainCatSession

-(id)initWithCategoryID:(NSNumber *)categoryID {
    return [self initWithCategoryID:categoryID blocks:[[NSMutableArray alloc] init]];
}

-(id)initWithCategoryID:(NSNumber *)categoryID blocks:(NSMutableArray*)blocks {
    self = [super init];
    if(self) {
        self.categoryID = categoryID;
        self.blocks = blocks;
    }
    return self;
}

-(NSString *) description {
    return [NSString stringWithFormat:@"Cateogry %@: (%@)", self.categoryID, [self.blocks componentsJoinedByString:@","]];
}

@end
