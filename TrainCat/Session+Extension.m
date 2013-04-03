//
//  Session+Extension.m
//  TrainCat
//
//  Created by Alankar Misra on 28/03/13.
//
//

#import "Session+Extension.h"

@implementation SessionLog (Extension)

-(void)awakeFromInsert {
    [super awakeFromInsert];
    self.startTime = self.endTime = [NSDate date];
}

@end
