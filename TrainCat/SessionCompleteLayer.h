//
//  SessionCompleteLayer.h
//  TrainCat
//
//  Created by Alankar Misra on 28/03/13.
//  Copyright 2013 Digital Sutras. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Participant+Extension.h"
#import "Constants.h"

@class Participant;

@interface SessionCompleteLayer : CCLayerColor

+(CCScene *) sceneWithParticipant:(Participant *) participant sessionId:(NSInteger)sessionId gameOver:(BOOL)isGameOver;

@end
