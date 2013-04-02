//
//  ActionLib.m
//  TrainCat
//
//  Created by Alankar Misra on 02/04/13.
//
//

#import "ActionLib.h"
#import "cocos2d.h"

@implementation ActionLib

+(id)pointLeftToRightAction {
    id moveLeft = [CCMoveBy actionWithDuration:0.25 position:ccp(20,0)];
    id moveRight = [moveLeft reverse];
    id moveLeftRight = [CCSequence actions:moveLeft, moveRight, nil];
    return [CCRepeatForever actionWithAction:moveLeftRight];
}

+(id)pointRightToLeftAction {
    id moveLeft = [CCMoveBy actionWithDuration:0.25 position:ccp(20,0)];
    id moveRight = [moveLeft reverse];
    id moveRightLeft = [CCSequence actions:moveRight, moveLeft, nil];
    return [CCRepeatForever actionWithAction:moveRightLeft];
}

+(id)pulse {
    id shrink = [CCScaleBy actionWithDuration:0.4 scale:0.8];
    id grow = [shrink reverse];
    id shrinkAndGrow = [CCSequence actions:shrink, grow, nil];
    return [CCRepeatForever actionWithAction:shrinkAndGrow];
}

@end
