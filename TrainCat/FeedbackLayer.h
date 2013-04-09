//
//  FeedbackLayer.h
//  TrainCat
//
//  Created by Alankar Misra on 27/03/13.
//  Copyright 2013 Digital Sutras. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Constants.h"

@protocol FeedbackLayerDelegate

-(void)feedbackDidFinish;

@end

@interface FeedbackLayer : CCLayer

@property (nonatomic, weak) id <FeedbackLayerDelegate> delegate;

-(void) clear;
-(void)showFeedback:(GradeType)gradeCode;
    
@end
