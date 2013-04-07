//
//  BackgroundLayer.m
//  TrainCat
//
//  Created by Alankar Misra on 07/04/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "BackgroundLayer.h"
#import "constants.h"


@implementation BackgroundLayer
// Helper class method that creates a Scene with the BackgroundLayer as the only child.
+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	BackgroundLayer *gameLayer = [BackgroundLayer node];
    
	// add layer as a child to scene
	[scene addChild: gameLayer];
	
	// return the scene
	return scene;
}

-(id)init {
    if( (self=[super initWithColor:BACKGROUND_COLOR]) ) {
        CGSize winSize = [[CCDirector sharedDirector] winSize];
        CCSprite *background = [CCSprite spriteWithFile:@"background.png"];
        background.position = ccp(winSize.width/2, winSize.height/2);
        [self addChild:background];
    }
    return self;
}


@end
