//
//  FeedbackLayer.m
//  TrainCat
//
//  Created by Alankar Misra on 27/03/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "FeedbackLayer.h"
#import "constants.h"

@interface FeedbackLayer()
@property (nonatomic, strong) CCLabelTTF *label;
@property (nonatomic, strong) id feedbackAction;
@end

@implementation FeedbackLayer

-(id)init {
    if(self = [super init]) {
        CGSize winSize = [CCDirector sharedDirector].winSize;
        self.label = [CCLabelTTF labelWithString:@"" fontName:@"DevanagariSangamMN-Bold" fontSize:64];
        self.label.color = ccc3(0, 0, 0);
        self.label.position = ccp( winSize.width /2 , winSize.height/2 );
        [self addChild:self.label];
        
        self.feedbackAction = [CCSequence actions:
                               [CCDelayTime actionWithDuration:FEEDBACK_DURATION],
                               [CCCallFunc actionWithTarget:self selector:@selector(finished)],
                               nil];
    }
    
    return self;
}

-(void)showFeedback:(GradeType)gradeCode {
    NSArray *ra;
    switch(gradeCode) {
        case GradeTypeCorrect:
            ra = [self.class rightAnswer];
            self.label.string = ra[arc4random() % ra.count];
            break;
        case GradeTypeIncorrect:
            self.label.string = @"Incorrect! :(";
            break;
        default:
            self.label.string = @"No response! :(";
            break;
    }
    
    [self runAction:self.feedbackAction];
}

-(void)finished {
    if(self.delegate) [self.delegate feedbackDidFinish];
}

-(void)clear {
    //self.label.string = @"";
}

+(NSArray *)rightAnswer {
    static NSArray *_rightAnswer = nil;
    if(!_rightAnswer) {
        _rightAnswer = [[NSArray alloc] initWithObjects:@"Excellent!", @"Correct!", @"Genius!", @"Well done!", @"That's right!", @"Nicely done!", @"Perfect!", @"Awesome!", nil];
    }
    return _rightAnswer;
}

@end
