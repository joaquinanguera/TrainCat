//
//  FeedbackLayer.m
//  TrainCat
//
//  Created by Alankar Misra on 27/03/13.
//  Copyright 2013 Digital Sutras. All rights reserved.
//

#import "FeedbackLayer.h"
#import "SimpleAudioEngine.h"
#import "Constants.h"
#import "CCNode+Extension.h"

#define kFeedbackSoundCorrect @"correct2.mp3"
#define kFeedbackSoundIncorrect @"incorrect.mp3"
#define kFeedbackBlinks 2

@interface FeedbackLayer()
@property (nonatomic, strong) CCSprite *spriteIncorrect;
@property (nonatomic, strong) CCSprite *spriteCorrect;
@property (nonatomic, strong) CCLabelTTF *feedback;
@end

@implementation FeedbackLayer

-(id)init {
    if(self = [super init]) {
        [[SimpleAudioEngine sharedEngine] preloadEffect:kFeedbackSoundCorrect];
        [[SimpleAudioEngine sharedEngine] preloadEffect:kFeedbackSoundIncorrect];
        
        self.feedback = [CCLabelTTF
                             labelWithString:@""
                             dimensions:CGSizeMake(325,90) // Based on the spriteResponseCorrect graphic
                             hAlignment:kCCTextAlignmentCenter
                             vAlignment:kCCVerticalTextAlignmentTop
                             lineBreakMode:kCCLineBreakModeWordWrap
                             fontName:GAME_TEXT_FONT
                             fontSize:55];
        self.feedback.color = ccc3(0, 0, 0);
        
        [[[self.spriteCorrect alignMiddle] alignCenter] shiftUp:50];
        [[[self.spriteIncorrect alignMiddle] alignCenter] shiftUp:50];
        [[[self.feedback alignMiddle] alignCenter] shiftDown:self.spriteCorrect.contentSize.height/2];
        [self hideAllFeedback];
        
        [self addChild:self.spriteIncorrect];
        [self addChild:self.spriteCorrect];
        [self addChild:self.feedback];
    }
    
    return self;
}

-(id)feedbackCorrectAction {
    id blinkIconAction = [CCTargetedAction actionWithTarget:self.spriteCorrect action:[CCBlink actionWithDuration:FEEDBACK_DURATION blinks:kFeedbackBlinks]];
    id blinkTextAction = [CCTargetedAction actionWithTarget:self.feedback action:[CCBlink actionWithDuration:FEEDBACK_DURATION blinks:kFeedbackBlinks]];
    return [CCSpawn actions:
              [CCSequence actions:
               [CCDelayTime actionWithDuration:FEEDBACK_DURATION],
               [CCCallFunc actionWithTarget:self selector:@selector(finished)],
               nil],
              blinkIconAction,
              blinkTextAction,
              nil];
}

-(id)feedbackIncorrectAction {
    id blinkIconAction = [CCTargetedAction actionWithTarget:self.spriteIncorrect action:[CCBlink actionWithDuration:FEEDBACK_DURATION blinks:kFeedbackBlinks]];
    return [CCSpawn actions:
                             [CCSequence actions:
                              [CCDelayTime actionWithDuration:FEEDBACK_DURATION],
                              [CCCallFunc actionWithTarget:self selector:@selector(finished)],
                              nil],
                             blinkIconAction, nil];
}

-(CCSprite *)spriteIncorrect {
    if(!_spriteIncorrect) {
        _spriteIncorrect = [CCSprite spriteWithFile:@"spriteResponseIncorrect.png"];
    }
    return _spriteIncorrect;
}

-(CCSprite *)spriteCorrect {
    if(!_spriteCorrect) {
        _spriteCorrect = [CCSprite spriteWithFile:@"spriteResponseCorrect.png"];
    }
    return _spriteCorrect;
}

-(void)showFeedback:(GradeType)gradeCode {
    NSArray *ra;
    switch(gradeCode) {
        case GradeTypeCorrect:            
            ra = [self.class rightAnswer];
            self.feedback.string = ra[arc4random() % ra.count];
            self.feedback.visible = self.spriteCorrect.visible = YES;
            [self runAction:[self feedbackCorrectAction]];
            [[SimpleAudioEngine sharedEngine] playEffect:kFeedbackSoundCorrect];
            break;
        default:
            self.spriteCorrect.visible = NO;
            [self runAction:[self feedbackIncorrectAction]];
            [[SimpleAudioEngine sharedEngine] playEffect:kFeedbackSoundIncorrect];
            break;
    }
}

-(void)finished {
    [self stopAllActions];
    if(self.delegate) [self.delegate feedbackDidFinish];
}

-(void)clear {
    [self hideAllFeedback];
}

-(void)hideAllFeedback {
    self.feedback.visible = self.spriteCorrect.visible = self.spriteIncorrect.visible = NO;
}


+(NSArray *)rightAnswer {
    static NSArray *_rightAnswer = nil;
    if(!_rightAnswer) {
        _rightAnswer = @[@"Excellent!", @"Correct!", @"Genius!", @"Well done!", @"That's right!", @"Nicely done!", @"Perfect!", @"Awesome!"];
    }
    return _rightAnswer;
}

@end
