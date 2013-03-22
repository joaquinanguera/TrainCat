//
//  TrainCatProgram.h
//  TrainCat
//
//  Created by Alankar Misra on 22/03/13.
//
//

#import <Foundation/Foundation.h>

@interface TrainCatProgram : NSObject

@property (nonatomic, strong) NSMutableArray *sessions;

-(id)init;
-(id)initWithSessions:(NSMutableArray *)sessions; // TrainCat Session Objects

@end
