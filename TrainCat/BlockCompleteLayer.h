//
//  BlockCompleteLayer.h
//  TrainCat
//
//  Created by Alankar Misra on 03/04/13.
//  Copyright 2013 Digital Sutras. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Constants.h"

@class Participant;

@interface BlockCompleteLayer : CCLayerColor

+(CCScene *) sceneWithParticipant:(Participant *) participant sessionType:(SessionType)sessionType;

@end
